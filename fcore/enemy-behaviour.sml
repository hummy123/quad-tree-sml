structure EnemyBehaviour =
struct
  open GameType

  fun canWalkAhead (x, y, wallTree, platformTree) =
    let
      val ww = Constants.worldWidth
      val wh = Constants.worldHeight

      val searchWidth = Constants.enemySize

      val y = y + Constants.enemySize - 5
      val searchHeight = 10
    in
      QuadTree.hasCollisionAt
        (x, y, searchWidth, searchHeight, 0, 0, ww, wh, ~1, wallTree)
      orelse
      QuadTree.hasCollisionAt
        (x, y, searchWidth, searchHeight, 0, 0, ww, wh, ~1, platformTree)
    end

  (* same function takes either wallTree or platformTree and returns true
   * if standing on tree.
   * Function is monomorphic in the sense that wallTree and platformTree 
   * are both same type (no generics/parametric polymorphism).
   * *)
  fun standingOnArea (enemy, tree) =
    let
      val {x = ex, y = ey, ...} = enemy

      val ey = ey + Constants.enemySize - 1

      val width = Constants.enemySize
      val height = 2

      val ww = Constants.worldWidth
      val wh = Constants.worldHeight
    in
      QuadTree.hasCollisionAt (ex, ey, width, height, 0, 0, ww, wh, ~1, tree)
    end

  fun getPatrollPatches (enemy: enemy, wallTree, platformTree, acc) =
    let
      (* This function is meant to check 
       * if enemy should switch the horizontal direction 
       * if the enemy is patrolling.
       *
       * Algorithm:
       * 1. Check if enemy there is a wall ahead of the enemy
       *    in the direction the enemy is walking.
       * 1.1. If there is a wall, then invert the direction.
       *
       * 2. If there is no wall, check if there is space to 
       *    walk ahead on, such that enemy will not fall
       *    if enemy continues to walk.
       * 2.1. If continuing to walk will cause the enemy to fall,
       *      then invert the direction.
       *
       * 3. Else, do not invert direction and simply return given list.
       * *)

      val {x, y, xAxis, ...} = enemy
    in
      case xAxis of
        MOVE_LEFT =>
          let
            (* search to see if there is wall on left side *)
            val searchStartX = x - Constants.moveEnemyBy
            val searchWidth = Constants.enemySize
            val searchHeight = Constants.enemySize - 5

            val ww = Constants.worldWidth
            val wh = Constants.worldHeight

            val hasWallAhead = QuadTree.hasCollisionAt
              ( searchStartX
              , y
              , searchWidth
              , searchHeight
              , 0
              , 0
              , ww
              , wh
              , ~1
              , wallTree
              )
          in
            if
              hasWallAhead
            then EnemyPatch.W_X_AXIS MOVE_RIGHT :: acc
            else (* invert direction if moving further left 
                  * will result in falling down  *) if
              canWalkAhead (searchStartX, y, wallTree, platformTree)
            then acc
            else EnemyPatch.W_X_AXIS MOVE_RIGHT :: acc
          end
      | MOVE_RIGHT =>
          let
            (* enemy's x field is top left coordinate 
             * but we want to check top * right coordinate, 
             * so add enemySize *)
            val searchStartX = x + Constants.enemySize + Constants.moveEnemyBy
            val searchWidth = Constants.enemySize
            val searchHeight = Constants.enemySize - 5

            val ww = Constants.worldWidth
            val wh = Constants.worldHeight

            val hasWallAhead = QuadTree.hasCollisionAt
              ( searchStartX
              , y
              , searchWidth
              , searchHeight
              , 0
              , 0
              , ww
              , wh
              , ~1
              , wallTree
              )
          in
            if
              hasWallAhead
            then EnemyPatch.W_X_AXIS MOVE_LEFT :: acc
            else (* invert direction if moving further right
                  * will result in falling down  *) if
              canWalkAhead (searchStartX, y, wallTree, platformTree)
            then acc
            else EnemyPatch.W_X_AXIS MOVE_LEFT :: acc
          end
      | STAY_STILL => acc
    end

  fun getHighestPlatform (collisions, platforms, highestY, highestID) =
    case collisions of
      id :: tl =>
        let
          val {y = platY, ...} = Platform.find (id, platforms)
        in
          (* platY < highestY is correct because lowest number = highest 
           * in * this case *)
          if platY < highestY then getHighestPlatform (tl, platforms, platY, id)
          else getHighestPlatform (tl, platforms, highestY, highestID)
        end
    | [] => highestID

  fun getPlatformBelowPlayer (player: player, platformTree, platforms) =
    let
      val {x, y, ...} = player

      val searchWidth = Constants.playerSize
      val searchHeight = Constants.worldHeight - y

      val ww = Constants.worldWidth
      val wh = Constants.worldHeight

      val collisions = QuadTree.getCollisions
        (x, y, searchWidth, searchHeight, 0, 0, ww, wh, ~1, platformTree)
    in
      getHighestPlatform (collisions, platforms, wh, ~1)
    end

  fun canJumpOnPID (collisions, pID) =
    case collisions of
      id :: tl => (id = pID) orelse canJumpOnPID (tl, pID)
    | [] => false

  fun canJumpOnPlatform (player, platforms, enemy: enemy, platformTree) =
    let
      val pID = getPlatformBelowPlayer (player, platformTree, platforms)

      val {x, y, ...} = enemy

      val distance = Constants.moveEnemyBy * Constants.jumpLimit

      val distance = distance div 2
      val yDistance = distance

      val y = y - yDistance + Constants.enemySize

      val ww = Constants.worldWidth
      val wh = Constants.worldHeight

      val mx = x - distance

      val rightCollisions = QuadTree.getCollisions
        (x, y, distance, yDistance, 0, 0, ww, wh, ~1, platformTree)

      val leftCollisions = QuadTree.getCollisions
        (mx, y, distance, yDistance, 0, 0, ww, wh, ~1, platformTree)
    in
      canJumpOnPID (rightCollisions, pID)
      orelse canJumpOnPID (leftCollisions, pID)
    end

  (* pathfinding *)
  fun getFollowPatches
    (player: player, enemy, wallTree, platformTree, platforms, acc) =
    let
      val {x = px, y = py, ...} = player
      val {x = ex, y = ey, yAxis = eyAxis, ...} = enemy

      val xAxis = if px < ex then MOVE_LEFT else MOVE_RIGHT

      val isOnWall = standingOnArea (enemy, wallTree)
      val isOnPlatform = standingOnArea (enemy, platformTree)
      val hasPlatformAbove =
        canJumpOnPlatform (player, platforms, enemy, platformTree)
      val () = print ("canJump: " ^ Bool.toString hasPlatformAbove ^ "\n")
      val shouldJump = (isOnWall orelse isOnPlatform) andalso hasPlatformAbove

      val yAxis =
        if ey > py andalso shouldJump then
          case eyAxis of
            ON_GROUND => JUMPING 0
          | FALLING => JUMPING 0
          | _ => eyAxis
        else
          eyAxis
    in
      EnemyPatch.W_Y_AXIS yAxis :: EnemyPatch.W_X_AXIS xAxis :: acc
    end

  fun getVariantPatches
    (enemy, walls, wallTree, platforms, platformTree, player, acc) =
    let
      open EnemyVariants
    in
      case #variant enemy of
        PATROL_SLIME => getPatrollPatches (enemy, wallTree, platformTree, acc)
      | FOLLOW_SIME =>
          getFollowPatches
            (player, enemy, wallTree, platformTree, platforms, acc)
    end
end
