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


  fun getVariantPatches (enemy, walls, wallTree, platforms, platformTree, acc) =
    let
      open EnemyVariants
    in
      case #variant enemy of
        PATROL_SLIME => getPatrollPatches (enemy, wallTree, platformTree, acc)
    end
end
