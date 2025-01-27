signature QUAD_TREE =
sig
  type t

  val empty: t

  datatype collision_side =
    QUERY_ON_LEFT_SIDE
  | QUERY_ON_TOP_SIDE
  | QUERY_ON_RIGHT_SIDE
  | QUERY_ON_BOTTOM_SIDE

  val insert: int * int * int * int * 
              int * int * int * int * 
              int * t -> t

  val fromItem: int * int * int * int * int -> t

  val getCollisions: int * int * int * int * 
                     int * int * int * int * 
                     int * t -> int list

  val helpGetCollisions: int * int * int * int * 
                         int * int * int * int * 
                         int * int list * t 
                         -> int list

  val getCollisionSides: int * int * int * int * int * int * int * int * int * t
                         -> (collision_side * int) list

  val getCollisionsBelow: int * int * int * int * int * int * int * int * int * t
                         -> int list

  val hasCollisionAt: int * int * int * int *
                      int * int * int * int *
                      int * t -> bool

  val getItemID: int * int * int * int *
                 int * int * int * int *
                 t -> int
end

structure QuadTree: QUAD_TREE =
struct
  open QuadTreeType

  type item = QuadTreeType.item

  fun visitTopLeft (iX, iY, iW, iH, qX, qY, qW, qH) =
    let
      val midX = qW div 2 + qX
      val midY = qH div 2 + qY
    in
      iX <= midX andalso iY <= midY
    end

  fun visitTopRight (iX, iY, iW, iH, qX, qY, qW, qH) =
    let
      val midX = qW div 2 + qX
      val midY = qH div 2 + qY
    in
      iX >= midX andalso iY <= midY
    end

  fun visitBottomLeft (iX, iY, iW, iH, qX, qY, qW, qH) =
    let
      val midX = qW div 2 + qX
      val midY = qH div 2 + qY

      val iFinishY = iY + iH
    in
      iX <= midX andalso iFinishY >= midY
    end

  fun visitBottomRight (iX, iY, iW, iH, qX, qY, qW, qH) =
    let
      val midX = qW div 2 + qX
      val midY = qH div 2 + qY

      val iFinishX = iX + iH
      val iFinishY = iY + iH
    in
      iFinishX >= midX andalso iFinishY >= midY
    end

  fun mkItem (id, startX, startY, width, height) : item =
    { itemID = id
    , startX = startX
    , startY = startY
    , width = width
    , height = height
    }

  fun itemToString {itemID, startX, startY, width, height} =
    String.concat
      [ "{itemID = "
      , Int.toString itemID
      , ", startX = "
      , Int.toString startX
      , ", startY = "
      , Int.toString startY
      , ", width = "
      , Int.toString width
      , ", height = "
      , Int.toString height
      , "}"
      ]

  type t = QuadTreeType.t

  val empty = LEAF (Vector.fromList [])

  fun fromItem (itemID, startX, startY, width, height) =
    let
      val item = mkItem (itemID, startX, startY, width, height)
      val elements = Vector.fromList [item]
    in
      LEAF elements
    end

  (* max size of vector before we split it further *)
  val maxSize = 3

  fun isItemInQuad (iX, iY, iWidth, iHeight, qX, qY, qWidth, qHeight) =
    iX >= qX andalso iY >= qY andalso iWidth <= qWidth
    andalso iHeight <= qHeight

  fun whichQuadrant
    (itemX, itemY, itemWidth, itemHeight, quadX, quadY, quadWidth, quadHeight) =
    let
      (* calculate quadrants *)
      val halfWidth = quadWidth div 2
      val halfHeight = quadHeight div 2

      val middleX = quadX + halfWidth
      val middleY = quadY + halfHeight

      val isInTopLeft = isItemInQuad
        ( itemX
        , itemY
        , itemWidth
        , itemHeight
        , quadX
        , quadY
        , halfWidth
        , halfHeight
        )

      val isInTopRight = isItemInQuad
        ( itemX
        , itemY
        , itemWidth
        , itemHeight
        , middleX
        , quadY
        , halfWidth
        , halfHeight
        )

      val isInBottomLeft = isItemInQuad
        ( itemX
        , itemY
        , itemWidth
        , itemHeight
        , quadX
        , middleY
        , halfWidth
        , halfHeight
        )

      val isInBottomRight = isItemInQuad
        ( itemX
        , itemY
        , itemWidth
        , itemHeight
        , middleX
        , middleY
        , halfWidth
        , halfHeight
        )
    in
      if isInTopLeft then TOP_LEFT
      else if isInTopRight then TOP_RIGHT
      else if isInBottomLeft then BOTTOM_LEFT
      else if isInBottomRight then BOTTOM_RIGHT
      else PARENT_QUADRANT
    end

  fun splitLeaf (qX, qY, qW, qH, tl, tr, bl, br, elements, pos) =
    if pos < 0 then
      let
        val tl = Vector.fromList tl
        val tr = Vector.fromList tr
        val bl = Vector.fromList bl
        val br = Vector.fromList br
      in
        NODE
          { topLeft = LEAF tl
          , topRight = LEAF tr
          , bottomLeft = LEAF bl
          , bottomRight = LEAF br
          }
      end
    else
      let
        val item = Vector.sub (elements, pos)
        val {startX = iX, startY = iY, width = iW, height = iH, ...} = item

        val vtl = visitTopLeft (iX, iY, iW, iH, qX, qY, qW, qH)
        val vtr = visitTopRight (iX, iY, iW, iH, qX, qY, qW, qH)
        val vbl = visitBottomLeft (iX, iY, iW, iH, qX, qY, qW, qH)
        val vbr = visitBottomRight (iX, iY, iW, iH, qX, qY, qW, qH)

        val tl = if vtl then item :: tl else tl

        val tr = if vtr then item :: tr else tr

        val bl = if vbl then item :: bl else bl

        val br = if vbr then item :: br else br
      in
        splitLeaf (qX, qY, qW, qH, tl, tr, bl, br, elements, pos - 1)
      end

  fun insert
    ( itemX
    , itemY
    , itemWidth
    , itemHeight
    , quadX
    , quadY
    , quadWidth
    , quadHeight
    , itemID
    , tree: t
    ) =
    case tree of
      NODE {topLeft, topRight, bottomLeft, bottomRight} =>
        let
          val halfW = quadWidth div 2
          val halfH = quadHeight div 2

          val midX = halfW + quadX
          val midY = halfH + quadY

          val iX = itemX
          val iY = itemY
          val iW = itemWidth
          val iH = itemHeight

          val qX = quadX
          val qY = quadY
          val qW = quadWidth
          val qH = quadHeight

          val vtl = visitTopLeft (iX, iY, iW, iH, qX, qY, qW, qH)
          val vtr = visitTopRight (iX, iY, iW, iH, qX, qY, qW, qH)
          val vbl = visitBottomLeft (iX, iY, iW, iH, qX, qY, qW, qH)
          val vbr = visitBottomRight (iX, iY, iW, iH, qX, qY, qW, qH)

          val tl =
            if vtl then
              insert (iX, iY, iW, iH, qX, qY, halfW, halfH, itemID, topLeft)
            else
              topLeft

          val tr =
            if vtr then
              insert (iX, iY, iW, iH, midX, qY, halfW, halfH, itemID, topRight)
            else
              topRight

          val bl =
            if vbl then
              insert
                (iX, iY, iW, iH, qX, midY, halfW, halfH, itemID, bottomLeft)
            else
              bottomLeft

          val br =
            if vbr then
              insert
                (iX, iY, iW, iH, midX, midY, halfW, halfH, itemID, bottomRight)
            else
              bottomRight
        in
          NODE {topLeft = tl, topRight = tr, bottomLeft = bl, bottomRight = br}
        end
    | LEAF elements =>
        if Vector.length elements + 1 > maxSize then
          (* have to calculate quadrants and split *)
          let
            val pos = Vector.length elements - 1
            val item = mkItem (itemID, itemX, itemY, itemWidth, itemHeight)

            val halfW = quadWidth div 2
            val halfH = quadHeight div 2

            val midX = halfW + quadX
            val midY = halfH + quadY

            val iX = itemX
            val iY = itemY
            val iW = itemWidth
            val iH = itemHeight

            val qX = quadX
            val qY = quadY
            val qW = quadWidth
            val qH = quadHeight

            val vtl = visitTopLeft (iX, iY, iW, iH, qX, qY, qW, qH)
            val vtr = visitTopRight (iX, iY, iW, iH, qX, qY, qW, qH)
            val vbl = visitBottomLeft (iX, iY, iW, iH, qX, qY, qW, qH)
            val vbr = visitBottomRight (iX, iY, iW, iH, qX, qY, qW, qH)

            val pos = Vector.length elements - 1
            val item = mkItem (itemID, itemX, itemY, itemWidth, itemHeight)

            val tl = if vtl then [item] else []

            val tr = if vtr then [item] else []

            val bl = if vbl then [item] else []

            val br = if vbr then [item] else []

            val pe = []
          in
            splitLeaf
              ( quadX
              , quadY
              , quadWidth
              , quadHeight
              , tl
              , tr
              , bl
              , br
              , elements
              , pos
              )
          end
        else
          (* can insert itemID in elements vector *)
          let
            val item = mkItem (itemID, itemX, itemY, itemWidth, itemHeight)
            val elements = Vector.concat [elements, Vector.fromList [item]]
          in
            LEAF elements
          end

  fun isBetween (start, checkStart, finish, checkFinish) =
    (* if check containhs start/finish *)
    (checkStart <= start andalso checkFinish >= finish)
    orelse
    (* if start/finish containhs check *)
    (start <= checkStart andalso finish >= checkFinish)
    orelse
    (* if checkStart between start and finish *)
    (start <= checkStart andalso finish >= checkStart)
    orelse
    (* if checkFinish is between start and finish *)
    (start <= checkFinish andalso finish >= checkFinish)

  fun isColliding (iX, iY, iW, iH, itemID, checkWith: item) =
    let
      val itemEndX = iX + iW
      val itemEndY = iY + iH
      val {itemID = checkID, startX, startY, width, height, ...} = checkWith
      val endX = startX + width
      val endY = startY + height
    in
      isBetween (iX, startX, itemEndX, endX)
      andalso isBetween (iY, startY, itemEndY, endY) andalso itemID <> checkID
    end

  fun getCollisionsVec (iX, iY, iW, iH, itemID, pos, elements, acc) =
    if pos = Vector.length elements then
      acc
    else
      let
        val item = Vector.sub (elements, pos)
        val acc =
          if isColliding (iX, iY, iW, iH, itemID, item) then #itemID item :: acc
          else acc
      in
        getCollisionsVec (iX, iY, iW, iH, itemID, pos + 1, elements, acc)
      end

  fun getCollisionsAll (iX, iY, iW, iH, qW, qH, itemID, acc, tree) =
    case tree of
      NODE {topLeft, topRight, bottomLeft, bottomRight} =>
        let
          val halfWidth = qW div 2
          val halfHeight = qH div 2

          val acc = getCollisionsAll
            (iX, iY, iW, iH, halfWidth, halfHeight, itemID, acc, topLeft)

          val acc = getCollisionsAll
            (iX, iY, iW, iH, halfWidth, halfHeight, itemID, acc, topRight)

          val acc = getCollisionsAll
            (iX, iY, iW, iH, halfWidth, halfHeight, itemID, acc, bottomLeft)
        in
          getCollisionsAll
            (iX, iY, iW, iH, halfWidth, halfWidth, itemID, acc, bottomRight)
        end
    | LEAF elements =>
        getCollisionsVec (iX, iY, iW, iH, itemID, 0, elements, acc)

  fun helpGetCollisions
    ( itemX
    , itemY
    , itemWidth
    , itemHeight
    , quadX
    , quadY
    , quadWidth
    , quadHeight
    , itemID
    , acc
    , tree: t
    ) =
    case tree of
      NODE {topLeft, topRight, bottomLeft, bottomRight} =>
        let
          val halfW = quadWidth div 2
          val halfH = quadHeight div 2

          val midX = halfW + quadX
          val midY = halfH + quadY

          val iX = itemX
          val iY = itemY
          val iW = itemWidth
          val iH = itemHeight

          val qX = quadX
          val qY = quadY
          val qW = quadWidth
          val qH = quadHeight

          val vtl = visitTopLeft (iX, iY, iW, iH, qX, qY, qW, qH)
          val vtr = visitTopRight (iX, iY, iW, iH, qX, qY, qW, qH)
          val vbl = visitBottomLeft (iX, iY, iW, iH, qX, qY, qW, qH)
          val vbr = visitBottomRight (iX, iY, iW, iH, qX, qY, qW, qH)

          val acc =
            if vtl then
              helpGetCollisions
                (iX, iY, iW, iH, qX, qY, halfW, halfH, itemID, acc, topLeft)
            else
              acc

          val acc =
            if vtr then
              helpGetCollisions
                (iX, iY, iW, iH, midX, qY, halfW, halfH, itemID, acc, topRight)
            else
              acc

          val acc =
            if vbl then
              helpGetCollisions
                ( iX
                , iY
                , iW
                , iH
                , qX
                , midY
                , halfW
                , halfH
                , itemID
                , acc
                , bottomLeft
                )
            else
              acc

          val acc =
            if vbl then
              helpGetCollisions
                ( iX
                , iY
                , iW
                , iH
                , midX
                , midY
                , halfW
                , halfH
                , itemID
                , acc
                , bottomRight
                )
            else
              acc
        in
          acc
        end
    | LEAF elements =>
        getCollisionsVec
          (itemX, itemY, itemWidth, itemHeight, itemID, 0, elements, acc)

  fun getCollisions
    ( itemX
    , itemY
    , itemWidth
    , itemHeight
    , quadX
    , quadY
    , quadWidth
    , quadHeight
    , itemID
    , tree
    ) =
    helpGetCollisions
      ( itemX
      , itemY
      , itemWidth
      , itemHeight
      , quadX
      , quadY
      , quadWidth
      , quadHeight
      , itemID
      , []
      , tree
      )

  (* no variant to represent 'no collision' case
   * because caller should only try getting collision side 
   * after checking that there is any collision. *)
  datatype collision_side =
    QUERY_ON_LEFT_SIDE
  | QUERY_ON_TOP_SIDE
  | QUERY_ON_RIGHT_SIDE
  | QUERY_ON_BOTTOM_SIDE

  (* getCollisionSide function ported from this answer:
   * https://stackoverflow.com/a/56607347
   * *)
  fun getCollisionSide (iX, iY, iW, iH, checkWith: item) =
    let
      val iFinishX = iX + iW
      val iFinishY = iY + iH
      val iHalfW = iW div 2
      val iHalfH = iH div 2
      val iCentreX = iX + iHalfW
      val iCentreY = iY + iHalfH

      val {startX = cX, startY = cY, width = cW, height = cH, ...} = checkWith

      val cFinishX = cX + cW
      val cFinishY = cY + cH
      val cHalfW = cW div 2
      val cHalfH = cH div 2
      val cCentreX = cX + cHalfW
      val cCentreY = cY + cHalfH

      val diffX = iCentreX - cCentreX
      val diffY = iCentreY - cCentreY

      val minXDist = iHalfW + cHalfW
      val minYDist = iHalfH + cHalfH

      val depthX = if diffX > 0 then minXDist - diffX else (~minXDist) - diffX

      val depthY = if diffY > 0 then minYDist - diffY else (~minYDist) - diffY
    in
      if abs depthX < abs depthY then
        if depthX > 0 then QUERY_ON_LEFT_SIDE else QUERY_ON_RIGHT_SIDE
      else if depthY > 0 then
        QUERY_ON_TOP_SIDE
      else
        QUERY_ON_BOTTOM_SIDE
    end

  (* like getCollisionsVec, but instead of consing just the itemID, 
   * it also conses the "collision-side" information.
   * *)
  fun getCollisionSideVec (iX, iY, iW, iH, itemID, pos, elements, acc) =
    if pos = Vector.length elements then
      acc
    else
      let
        val item = Vector.sub (elements, pos)
        val acc =
          if isColliding (iX, iY, iW, iH, itemID, item) then
            let val side = getCollisionSide (iX, iY, iW, iH, item)
            in (side, #itemID item) :: acc
            end
          else
            acc
      in
        getCollisionSideVec (iX, iY, iW, iH, itemID, pos + 1, elements, acc)
      end

  fun getCollisionSidesAll (iX, iY, iW, iH, qW, qH, itemID, acc, tree) =
    case tree of
      NODE {topLeft, topRight, bottomLeft, bottomRight} =>
        let
          val halfWidth = qW div 2
          val halfHeight = qH div 2

          val acc = getCollisionSidesAll
            (iX, iY, iW, iH, halfWidth, halfHeight, itemID, acc, topLeft)

          val acc = getCollisionSidesAll
            (iX, iY, iW, iH, halfWidth, halfHeight, itemID, acc, topRight)

          val acc = getCollisionSidesAll
            (iX, iY, iW, iH, halfWidth, halfHeight, itemID, acc, bottomLeft)
        in
          getCollisionSidesAll
            (iX, iY, iW, iH, halfWidth, halfWidth, itemID, acc, bottomRight)
        end
    | LEAF elements =>
        getCollisionSideVec (iX, iY, iW, iH, itemID, 0, elements, acc)

  fun helpGetCollisionSides
    ( itemX
    , itemY
    , itemWidth
    , itemHeight
    , quadX
    , quadY
    , quadWidth
    , quadHeight
    , itemID
    , acc
    , tree: t
    ) =
    case tree of
      NODE {topLeft, topRight, bottomLeft, bottomRight} =>
        let
          val halfW = quadWidth div 2
          val halfH = quadHeight div 2

          val midX = halfW + quadX
          val midY = halfH + quadY

          val iX = itemX
          val iY = itemY
          val iW = itemWidth
          val iH = itemHeight

          val qX = quadX
          val qY = quadY
          val qW = quadWidth
          val qH = quadHeight

          val vtl = visitTopLeft (iX, iY, iW, iH, qX, qY, qW, qH)
          val vtr = visitTopRight (iX, iY, iW, iH, qX, qY, qW, qH)
          val vbl = visitBottomLeft (iX, iY, iW, iH, qX, qY, qW, qH)
          val vbr = visitBottomRight (iX, iY, iW, iH, qX, qY, qW, qH)

          val acc =
            if vtl then
              helpGetCollisionSides
                (iX, iY, iW, iH, qX, qY, halfW, halfH, itemID, acc, topLeft)
            else
              acc

          val acc =
            if vtr then
              helpGetCollisionSides
                (iX, iY, iW, iH, midX, qY, halfW, halfH, itemID, acc, topRight)
            else
              acc

          val acc =
            if vbl then
              helpGetCollisionSides
                ( iX
                , iY
                , iW
                , iH
                , qX
                , midY
                , halfW
                , halfH
                , itemID
                , acc
                , bottomLeft
                )
            else
              acc

          val acc =
            if vbl then
              helpGetCollisionSides
                ( iX
                , iY
                , iW
                , iH
                , midX
                , midY
                , halfW
                , halfH
                , itemID
                , acc
                , bottomRight
                )
            else
              acc
        in
          acc
        end
    | LEAF elements =>
        getCollisionSideVec
          (itemX, itemY, itemWidth, itemHeight, itemID, 0, elements, acc)

  fun getCollisionSides
    ( itemX
    , itemY
    , itemWidth
    , itemHeight
    , quadX
    , quadY
    , quadWidth
    , quadHeight
    , itemID
    , tree
    ) =
    helpGetCollisionSides
      ( itemX
      , itemY
      , itemWidth
      , itemHeight
      , quadX
      , quadY
      , quadWidth
      , quadHeight
      , itemID
      , []
      , tree
      )

  fun getCollisionsBelowVec (iX, iY, iW, iH, itemID, pos, elements, acc) =
    if pos = Vector.length elements then
      acc
    else
      let
        val item = Vector.sub (elements, pos)
        val {itemID = curID, ...} = item
      in
        if isColliding (iX, iY, iW, iH, itemID, item) then
          case getCollisionSide (iX, iY, iW, iH, item) of
            QUERY_ON_BOTTOM_SIDE =>
              getCollisionsBelowVec
                (iX, iY, iW, iH, itemID, pos + 1, elements, curID :: acc)
          | _ =>
              getCollisionsBelowVec
                (iX, iY, iW, iH, itemID, pos + 1, elements, acc)
        else
          getCollisionsBelowVec (iX, iY, iW, iH, itemID, pos + 1, elements, acc)
      end

  fun getCollisionsBelowAll (iX, iY, iW, iH, qW, qH, itemID, acc, tree) =
    case tree of
      NODE {topLeft, topRight, bottomLeft, bottomRight} =>
        let
          val halfWidth = qW div 2
          val halfHeight = qH div 2

          val acc = getCollisionsBelowAll
            (iX, iY, iW, iH, halfWidth, halfHeight, itemID, acc, topLeft)

          val acc = getCollisionsBelowAll
            (iX, iY, iW, iH, halfWidth, halfHeight, itemID, acc, topRight)

          val acc = getCollisionsBelowAll
            (iX, iY, iW, iH, halfWidth, halfHeight, itemID, acc, bottomLeft)
        in
          getCollisionsBelowAll
            (iX, iY, iW, iH, halfWidth, halfWidth, itemID, acc, bottomRight)
        end
    | LEAF elements =>
        getCollisionsBelowVec (iX, iY, iW, iH, itemID, 0, elements, acc)

  fun helpGetCollisionsBelow
    ( itemX
    , itemY
    , itemWidth
    , itemHeight
    , quadX
    , quadY
    , quadWidth
    , quadHeight
    , itemID
    , acc
    , tree: t
    ) =
    case tree of
      NODE {topLeft, topRight, bottomLeft, bottomRight} =>
        let
          val halfW = quadWidth div 2
          val halfH = quadHeight div 2

          val midX = halfW + quadX
          val midY = halfH + quadY

          val iX = itemX
          val iY = itemY
          val iW = itemWidth
          val iH = itemHeight

          val qX = quadX
          val qY = quadY
          val qW = quadWidth
          val qH = quadHeight

          val vtl = visitTopLeft (iX, iY, iW, iH, qX, qY, qW, qH)
          val vtr = visitTopRight (iX, iY, iW, iH, qX, qY, qW, qH)
          val vbl = visitBottomLeft (iX, iY, iW, iH, qX, qY, qW, qH)
          val vbr = visitBottomRight (iX, iY, iW, iH, qX, qY, qW, qH)

          val acc =
            if vtl then
              helpGetCollisionsBelow
                (iX, iY, iW, iH, qX, qY, halfW, halfH, itemID, acc, topLeft)
            else
              acc

          val acc =
            if vtr then
              helpGetCollisionsBelow
                (iX, iY, iW, iH, midX, qY, halfW, halfH, itemID, acc, topRight)
            else
              acc

          val acc =
            if vbl then
              helpGetCollisionsBelow
                ( iX
                , iY
                , iW
                , iH
                , qX
                , midY
                , halfW
                , halfH
                , itemID
                , acc
                , bottomLeft
                )
            else
              acc

          val acc =
            if vbl then
              helpGetCollisionsBelow
                ( iX
                , iY
                , iW
                , iH
                , midX
                , midY
                , halfW
                , halfH
                , itemID
                , acc
                , bottomRight
                )
            else
              acc
        in
          acc
        end
    | LEAF elements =>
        getCollisionsBelowVec
          (itemX, itemY, itemWidth, itemHeight, itemID, 0, elements, acc)

  fun getCollisionsBelow
    ( itemX
    , itemY
    , itemWidth
    , itemHeight
    , quadX
    , quadY
    , quadWidth
    , quadHeight
    , itemID
    , tree
    ) =
    helpGetCollisionsBelow
      ( itemX
      , itemY
      , itemWidth
      , itemHeight
      , quadX
      , quadY
      , quadWidth
      , quadHeight
      , itemID
      , []
      , tree
      )

  fun hasCollisionAtVec (iX, iY, iW, iH, itemID, pos, elements) =
    if pos = Vector.length elements then
      false
    else
      let
        val item = Vector.sub (elements, pos)
      in
        if isColliding (iX, iY, iW, iH, itemID, item) then
          let
            val _ = print
              ("quad-tree.sml: has collision: \n" ^ itemToString item ^ "\n")
          in
            true
          end
        else
          hasCollisionAtVec (iX, iY, iW, iH, itemID, pos + 1, elements)
      end

  fun hasCollisionAt
    ( itemX
    , itemY
    , itemWidth
    , itemHeight
    , quadX
    , quadY
    , quadWidth
    , quadHeight
    , itemID
    , tree
    ) =
    case tree of
      NODE {topLeft, topRight, bottomLeft, bottomRight} =>
        let
          val halfW = quadWidth div 2
          val halfH = quadHeight div 2

          val midX = halfW + quadX
          val midY = halfH + quadY

          val iX = itemX
          val iY = itemY
          val iW = itemWidth
          val iH = itemHeight

          val qX = quadX
          val qY = quadY
          val qW = quadWidth
          val qH = quadHeight

          val vtl = visitTopLeft (iX, iY, iW, iH, qX, qY, qW, qH)
          val vtr = visitTopRight (iX, iY, iW, iH, qX, qY, qW, qH)
          val vbl = visitBottomLeft (iX, iY, iW, iH, qX, qY, qW, qH)
          val vbr = visitBottomRight (iX, iY, iW, iH, qX, qY, qW, qH)

          val tl =
            if vtl then
              hasCollisionAt
                (iX, iY, iW, iH, qX, qY, halfW, halfH, itemID, topLeft)
            else
              false

          val tr =
            if vtr then
              hasCollisionAt
                (iX, iY, iW, iH, midX, qY, halfW, halfH, itemID, topRight)
            else
              false

          val bl =
            if vbl then
              hasCollisionAt
                (iX, iY, iW, iH, qX, midY, halfW, halfH, itemID, bottomLeft)
            else
              false

          val br =
            if vbl then
              hasCollisionAt
                (iX, iY, iW, iH, midX, midY, halfW, halfH, itemID, bottomRight)
            else
              false
        in
          tl orelse tr orelse bl orelse br
        end
    | LEAF elements =>
        hasCollisionAtVec
          (itemX, itemY, itemWidth, itemHeight, itemID, 0, elements)

  fun getItemIDVec (iX, iY, iW, iH, pos, elements) =
    if pos = Vector.length elements then
      ~1
    else
      let
        val item = Vector.sub (elements, pos)
      in
        if isColliding (iX, iY, iW, iH, ~1, item) then #itemID item
        else getItemIDVec (iX, iY, iW, iH, pos + 1, elements)
      end

  fun getItemID (itemX, itemY, itemW, itemH, quadX, quadY, quadW, quadH, tree) =
    case tree of
      NODE {topLeft, topRight, bottomLeft, bottomRight} =>
        let
          val halfW = quadW div 2
          val halfH = quadH div 2

          val midX = halfW + quadX
          val midY = halfH + quadY

          val iX = itemX
          val iY = itemY
          val iW = itemW
          val iH = itemH

          val qX = quadX
          val qY = quadY
          val qW = quadW
          val qH = quadH

          val vtl = visitTopLeft (iX, iY, iW, iH, qX, qY, qW, qH)
          val vtr = visitTopRight (iX, iY, iW, iH, qX, qY, qW, qH)
          val vbl = visitBottomLeft (iX, iY, iW, iH, qX, qY, qW, qH)
          val vbr = visitBottomRight (iX, iY, iW, iH, qX, qY, qW, qH)

          val try1 =
            if vtl then
              getItemID (iX, iY, iW, iH, qX, qY, halfW, halfH, topLeft)
            else
              ~1

          val try2 =
            if vtr then
              getItemID (iX, iY, iW, iH, midX, qY, halfW, halfH, topRight)
            else
              ~1

          val try3 =
            if vbl then
              getItemID (iX, iY, iW, iH, qX, midY, halfW, halfH, bottomLeft)
            else
              ~1

          val try4 =
            if vbl then
              getItemID (iX, iY, iW, iH, midX, midY, halfW, halfH, bottomRight)
            else
              ~1

          (* get max: we assume query was narrow enough 
           * that only one ID is valid *)
          val a = Int.max (try1, try2)
          val a = Int.max (a, try3)
          val a = Int.max (a, try4)
        in
          a
        end
    | LEAF elements => getItemIDVec (itemX, itemY, itemW, itemH, 0, elements)
end
