structure Player =
struct
  datatype y_axis = ON_GROUND | FALLING | JUMPING of int
  datatype x_axis = MOVE_LEFT | STAY_STILL | MOVE_RIGHT

  (* width/height *)
  val size = 35
  val realSize = 35.0

  val moveBy = 5
  val jumpLimit = 150

  type t = {yAxis: y_axis, xAxis: x_axis, health: int, x: int, y: int}

  (* placeholder *)
  val initial: t =
    {yAxis = JUMPING 0, xAxis = STAY_STILL, health = 3, x = 500, y = 500}

  (* placeholder *)
  fun getVec ({x, y, ...}: t) =
    Block.lerp (x, y, realSize, realSize, 1920.0, 1080.0, 0.5, 0.5, 0.5)

  fun mkPlayer (health, xAxis, yAxis, x, y) =
    {yAxis = yAxis, xAxis = xAxis, health = health, x = x, y = y}

  fun checkWalls (yAxis, xAxis, x, y, health, lst) =
    let
      open QuadTree
    in
      case lst of
        (QUERY_ON_LEFT_SIDE, wallID) :: tl =>
          let
            val {x = wallX, width = wallWidth, ...} = Wall.getID wallID
            val newX = wallX + wallWidth
          in
            checkWalls (yAxis, xAxis, newX, y, health, tl)
          end
      | (QUERY_ON_RIGHT_SIDE, wallID) :: tl =>
          let
            val {x = wallX, width = wallWidth, ...} = Wall.getID wallID
            val newX = wallX - size
          in
            checkWalls (yAxis, xAxis, newX, y, health, tl)
          end
      | (QUERY_ON_BOTTOM_SIDE, wallID) :: tl =>
          let
            val {y = wallY, ...} = Wall.getID wallID
            val newY = wallY - size
          in
            checkWalls (ON_GROUND, xAxis, x, newY, health, tl)
          end
      | (QUERY_ON_TOP_SIDE, wallID) :: tl =>
          checkWalls (yAxis, xAxis, x, y, health, tl)
      | [] => mkPlayer (health, xAxis, yAxis, x, y)
    end

  fun helpMove (x, y, xAxis, yAxis, health) =
    let
      (* check against wall quad tree *)
      val desiredX =
        case xAxis of
          STAY_STILL => x
        | MOVE_LEFT => x - moveBy
        | MOVE_RIGHT => x + moveBy
    in
      case yAxis of
        ON_GROUND =>
          let
            val collisions = QuadTree.getCollisionSides
              (desiredX, y, size, size, 0, 0, 1920, 1080, 0, Wall.tree)
          in
            (* using default yAxis of FALLING when on ground 
             * ensures that gravity is applied 
             * when player walks off from platform *)
            checkWalls (FALLING, xAxis, desiredX, y, health, collisions)
          end
      | FALLING =>
          let
            val desiredY = y + moveBy
            val collisions = QuadTree.getCollisionSides
              (desiredX, desiredY, size, size, 0, 0, 1920, 1080, 0, Wall.tree)
          in
            checkWalls (yAxis, xAxis, desiredX, desiredY, health, collisions)
          end
      | JUMPING jumped =>
          if jumped + moveBy > jumpLimit then
            (* if we are above the jump limit, trigger a fall *)
            let
              val collisions = QuadTree.getCollisionSides
                (desiredX, y, size, size, 0, 0, 1920, 1080, 0, Wall.tree)
            in
              checkWalls (FALLING, xAxis, desiredX, y, health, collisions)
            end
          else
            (* jump *)
            let
              val newJumped = jumped + moveBy
              val yAxis = JUMPING newJumped
              val desiredY = y - moveBy

              val collisions = QuadTree.getCollisionSides
                (desiredX, desiredY, size, size, 0, 0, 1920, 1080, 0, Wall.tree)
            in
              checkWalls (yAxis, xAxis, desiredX, desiredY, health, collisions)
            end
    end

  fun getXAxis (lh, rh) =
    case (lh, rh) of
      (false, false) => STAY_STILL
    | (false, true) => MOVE_RIGHT
    | (true, false) => MOVE_LEFT
    | (true, true) => STAY_STILL

  fun getYAxis (uh, dh, yAxis) =
    case (uh, dh) of
      (false, false) => yAxis
    | (true, false) =>
        (case yAxis of
           ON_GROUND => JUMPING 0
         | _ => yAxis)
    | (false, true) => 
        (* todo: should move down if on platform *) 
        yAxis
    | (true, true) => yAxis

  fun move
    ({x, y, yAxis, health, ...}: t, {leftHeld, rightHeld, upHeld, downHeld}) =
    let
      val xAxis = getXAxis (leftHeld, rightHeld)
      val yAxis = getYAxis (upHeld, downHeld, yAxis)
    in
      helpMove (x, y, xAxis, yAxis, health)
    end
end
