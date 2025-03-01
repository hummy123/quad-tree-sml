signature LEVEL_TYPE =
sig
  type level_type =
    { player: PlayerType.player
    , walls: Wall.t vector
    , wallTree: QuadTree.t
    , platforms: Platform.t vector
    , platformTree: QuadTree.t
    , enemies: EnemyMap.t
    , graph: PlatSet.elem vector vector
    , fallingEnemies: FallingEnemyMap.t
    }

  val initial: level_type
end

structure LevelType :> LEVEL_TYPE =
struct
  type level_type =
    { player: PlayerType.player
    , walls: Wall.t vector
    , wallTree: QuadTree.t
    , platforms: Platform.t vector
    , platformTree: QuadTree.t
    , enemies: EnemyMap.t
    , graph: PlatSet.elem vector vector
    , fallingEnemies: FallingEnemyMap.t
    }

  fun enemyMapFromList (hd :: tl, map) =
        let val map = EnemyMap.add (#id hd, hd, map)
        in enemyMapFromList (tl, map)
        end
    | enemyMapFromList ([], map) = map

  val initial =
    let
      val player =
        { yAxis = EntityType.JUMPING 0
        , xAxis = EntityType.STAY_STILL
        , facing = EntityType.FACING_RIGHT
        , recoil = PlayerType.NO_RECOIL
        , attacked = PlayerType.NOT_ATTACKED
        , mainAttack = PlayerType.MAIN_NOT_ATTACKING
        , mainAttackPressed = false
        , health = 3
        , x = 500
        , y = 800
        , jumpPressed = false
        , enemies = Vector.fromList []
        , charge = Constants.maxCharge
        , projectiles = Vector.fromList []
        , platID = ~1
        , animTimer = 0
        }

      val wall1 = {id = 1, x = 0, y = 0, width = 100, height = 1080}
      val wall2 = {id = 2, x = 1820, y = 0, width = 100, height = 1080}
      val wall3 = {id = 3, x = 0, y = 980, width = 1920, height = 108}
      val walls = Vector.fromList [wall1, wall2, wall3]
      val wallTree = Wall.generateTree walls

      val plat1 = {id = 1, x = 255, y = 855, width = 199}
      val plat2 = {id = 2, x = 750, y = 855, width = 199}
      val plat3 = {id = 3, x = 399, y = 755, width = 399}
      val plat4 = {id = 4, x = 255, y = 655, width = 199}
      val plat5 = {id = 5, x = 750, y = 655, width = 199}
      val plat6 = {id = 6, x = 171, y = 555, width = 99}
      val plat7 = {id = 7, x = 934, y = 555, width = 99}
      val plat8 = {id = 8, x = 399, y = 555, width = 399}
      val plat9 = {id = 9, x = 255, y = 455, width = 199}
      val plat10 = {id = 10, x = 750, y = 455, width = 199}
      val plat11 = {id = 11, x = 399, y = 355, width = 399}
      val plat12 = {id = 12, x = 255, y = 255, width = 199}
      val plat13 = {id = 13, x = 750, y = 255, width = 199}
      val plat14 = {id = 14, x = 399, y = 155, width = 399}
      val plat15 = {id = 15, x = 171, y = 155, width = 99}
      val plat16 = {id = 16, x = 934, y = 155, width = 99}
      val platforms = Vector.fromList
        [ plat1
        , plat2
        , plat3
        , plat4
        , plat5
        , plat6
        , plat7
        , plat8
        , plat9
        , plat10
        , plat11
        , plat12
        , plat13
        , plat14
        , plat15
        , plat16
        ]
      val platformTree = Platform.generateTree platforms

      val enemy1 =
        { id = 1
        , x = 751
        , y = 555
        , health = 1
        , xAxis = EntityType.MOVE_RIGHT
        , yAxis = EntityType.FALLING
        , variant = EnemyType.FOLLOW_SLIME
        , batDirY = EnemyType.UP
        , platID = ~1
        , nextPlatID = ~1
        , batRest = 0
        , batMaxY = 485
        , batMinY = 625
        , facing = EntityType.FACING_RIGHT
        , shieldOn = false
        }
      val enemy2 =
        { id = 2
        , x = 351
        , y = 555
        , health = 1
        , xAxis = EntityType.MOVE_RIGHT
        , yAxis = EntityType.FALLING
        , variant = EnemyType.SHIELD_SLIME
        , batDirY = EnemyType.UP
        , platID = ~1
        , nextPlatID = ~1
        , batRest = 0
        , batMaxY = 485
        , batMinY = 625
        , facing = EntityType.FACING_RIGHT
        , shieldOn = false
        }
      val enemies = enemyMapFromList ([enemy1, enemy2], EnemyMap.empty)
      val graph = Graph.fromPlatforms (platforms, platformTree)
    in
      { player = player
      , walls = walls
      , wallTree = wallTree
      , platforms = platforms
      , platformTree = platformTree
      , enemies = enemies
      , graph = graph
      , fallingEnemies = FallingEnemyMap.empty
      }
    end
end
