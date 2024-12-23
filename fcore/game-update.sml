structure GameUpdate =
struct
  open GameType

  fun getEnemyRecoilPatches (player, playerOnRight, acc) =
    if playerOnRight then
      let
        val newRecoil = RECOIL_RIGHT 0
        val newAttacked = ATTACKED 0
      in
        W_RECOIL newRecoil :: W_ATTACKED newAttacked :: W_FACING FACING_LEFT
        :: W_Y_AXIS FALLING :: W_X_AXIS STAY_STILL :: acc
      end
    else
      let
        val newRecoil = RECOIL_LEFT 0
        val newAttacked = ATTACKED 0
      in
        W_RECOIL newRecoil :: W_ATTACKED newAttacked :: W_FACING FACING_RIGHT
        :: W_Y_AXIS FALLING :: W_X_AXIS STAY_STILL :: acc
      end

  fun checkEnemies (player: player, enemies: enemy vector, lst, acc) =
    case lst of
      id :: tl =>
        let
          val playerOnRight =
            (* check if collision is closer to left side of enemy or right
             * and then chose appropriate direction to recoil in *)
            let
              val {x, ...} = player
              val pFinishX = x + Player.size
              val pHalfW = Player.size div 2
              val pCentreX = x + pHalfW

              val {x = ex, y = ey, ...} = Vector.sub (enemies, id - 1)
              val eFinishX = ex + Enemy.size
              val eHalfW = Enemy.size div 2
              val eCentreX = ex + eHalfW
            in
              eCentreX < pCentreX
            end

          val acc = getEnemyRecoilPatches (player, playerOnRight, acc)
        in
          checkEnemies (player, enemies, tl, acc)
        end
    | [] => acc

  fun checkEnemiesWhileAttacking (player, enemies, lst, acc) =
    let
      open QuadTree
    in
      case lst of
        enemyID :: tl => (* placeholder *) acc
      | [] => acc
    end

  fun checkPlayerEnemyCollisions (player, game) =
    let
      val {x, y, mainAttack, attacked, ...} = player
      val {enemies, enemyTree, ...} = game
      val size = Player.size
    in
      case mainAttack of
        MAIN_NOT_ATTACKING =>
          (case attacked of
             NOT_ATTACKED =>
               let
                 val enemyCollisions = QuadTree.getCollisions
                   (x, y, size, size, 0, 0, 1920, 1080, 0, enemyTree)
               in
                 checkEnemies (player, enemies, enemyCollisions, [])
               end
           | ATTACKED amt =>
               if amt = Player.attackedLimit then
                 (* if reached limit, detect enemies again *)
                 let
                   val enemyCollisions = QuadTree.getCollisions
                     (x, y, size, size, 0, 0, 1920, 1080, 0, enemyTree)
                   val lst = [W_ATTACKED NOT_ATTACKED]
                 in
                   checkEnemies (player, enemies, enemyCollisions, lst)
                 end
               else
                 (* if attacked, don't detect collisions, 
                  * allowing a brief invincibility period as is common in many games 
                  * *)
                 let
                   val amt = amt + 1
                   val attacked = ATTACKED amt
                 in
                   [W_ATTACKED attacked]
                 end)
      | MAIN_ATTACKING amt =>
          let
            val enemyCollisions = QuadTree.getCollisions
              (x, y, size, size, 0, 0, 1920, 1080, 0, enemyTree)
          in
            checkEnemiesWhileAttacking (player, enemies, enemyCollisions, [])
          end
    end

  fun update (game, input) =
    let
      val {player, walls, wallTree, platforms, platformTree, enemies, enemyTree} =
        game

      val player = Player.runPhysicsAndInput (game, input)

      (* check player-enemy collisions and react *)
      val playerPatches = checkPlayerEnemyCollisions (player, game)
      val player = Player.withPatches (player, playerPatches)
    in
      { player = player
      , walls = walls
      , wallTree = wallTree
      , platforms = platforms
      , platformTree = platformTree
      , enemies = enemies
      , enemyTree = enemyTree
      }
    end
end
