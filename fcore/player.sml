structure Player =
struct
  open GameType

  fun mkPlayer
    ( health
    , xAxis
    , yAxis
    , x
    , y
    , jumpPressed
    , recoil
    , attacked
    , mainAttack
    , facing
    , mainAttackPressed
    , enemies
    , charge
    , projectiles
    ) =
    { yAxis = yAxis
    , xAxis = xAxis
    , recoil = recoil
    , attacked = attacked
    , mainAttack = mainAttack
    , mainAttackPressed = mainAttackPressed
    , facing = facing
    , health = health
    , x = x
    , y = y
    , jumpPressed = jumpPressed
    , enemies = enemies
    , charge = charge
    , projectiles = projectiles
    }

  fun withPatch (player: player, patch) =
    let
      val
        { yAxis
        , xAxis
        , recoil
        , attacked
        , mainAttack
        , mainAttackPressed
        , facing
        , health
        , x
        , y
        , jumpPressed
        , enemies
        , charge
        , projectiles
        } = player
    in
      case patch of
        W_X_AXIS xAxis =>
          mkPlayer
            ( health
            , xAxis
            , yAxis
            , x
            , y
            , jumpPressed
            , recoil
            , attacked
            , mainAttack
            , facing
            , mainAttackPressed
            , enemies
            , charge
            , projectiles
            )
      | W_Y_AXIS yAxis =>
          mkPlayer
            ( health
            , xAxis
            , yAxis
            , x
            , y
            , jumpPressed
            , recoil
            , attacked
            , mainAttack
            , facing
            , mainAttackPressed
            , enemies
            , charge
            , projectiles
            )
      | W_RECOIL recoil =>
          mkPlayer
            ( health
            , xAxis
            , yAxis
            , x
            , y
            , jumpPressed
            , recoil
            , attacked
            , mainAttack
            , facing
            , mainAttackPressed
            , enemies
            , charge
            , projectiles
            )
      | W_ATTACKED attacked =>
          mkPlayer
            ( health
            , xAxis
            , yAxis
            , x
            , y
            , jumpPressed
            , recoil
            , attacked
            , mainAttack
            , facing
            , mainAttackPressed
            , enemies
            , charge
            , projectiles
            )
      | W_MAIN_ATTACK mainAttack =>
          mkPlayer
            ( health
            , xAxis
            , yAxis
            , x
            , y
            , jumpPressed
            , recoil
            , attacked
            , mainAttack
            , facing
            , mainAttackPressed
            , enemies
            , charge
            , projectiles
            )
      | W_FACING facing =>
          mkPlayer
            ( health
            , xAxis
            , yAxis
            , x
            , y
            , jumpPressed
            , recoil
            , attacked
            , mainAttack
            , facing
            , mainAttackPressed
            , enemies
            , charge
            , projectiles
            )
      | W_HEALTH health =>
          mkPlayer
            ( health
            , xAxis
            , yAxis
            , x
            , y
            , jumpPressed
            , recoil
            , attacked
            , mainAttack
            , facing
            , mainAttackPressed
            , enemies
            , charge
            , projectiles
            )
      | W_X x =>
          mkPlayer
            ( health
            , xAxis
            , yAxis
            , x
            , y
            , jumpPressed
            , recoil
            , attacked
            , mainAttack
            , facing
            , mainAttackPressed
            , enemies
            , charge
            , projectiles
            )
      | W_Y y =>
          mkPlayer
            ( health
            , xAxis
            , yAxis
            , x
            , y
            , jumpPressed
            , recoil
            , attacked
            , mainAttack
            , facing
            , mainAttackPressed
            , enemies
            , charge
            , projectiles
            )
      | W_JUMP_PRESSED jumpPressed =>
          mkPlayer
            ( health
            , xAxis
            , yAxis
            , x
            , y
            , jumpPressed
            , recoil
            , attacked
            , mainAttack
            , facing
            , mainAttackPressed
            , enemies
            , charge
            , projectiles
            )
      | W_ENEMIES enemies =>
          mkPlayer
            ( health
            , xAxis
            , yAxis
            , x
            , y
            , jumpPressed
            , recoil
            , attacked
            , mainAttack
            , facing
            , mainAttackPressed
            , enemies
            , charge
            , projectiles
            )
      | W_CHARGE charge =>
          mkPlayer
            ( health
            , xAxis
            , yAxis
            , x
            , y
            , jumpPressed
            , recoil
            , attacked
            , mainAttack
            , facing
            , mainAttackPressed
            , enemies
            , charge
            , projectiles
            )
      | W_PROJECTILES projectiles =>
          mkPlayer
            ( health
            , xAxis
            , yAxis
            , x
            , y
            , jumpPressed
            , recoil
            , attacked
            , mainAttack
            , facing
            , mainAttackPressed
            , enemies
            , charge
            , projectiles
            )
    end

  fun withPatches (player: player, lst) =
    case lst of
      hd :: tl =>
        let val player = withPatch (player, hd)
        in withPatches (player, tl)
        end
    | [] => player

  (* helper functions checking input *)
  fun getXAxis (lh, rh) =
    case (lh, rh) of
      (false, false) => STAY_STILL
    | (false, true) => MOVE_RIGHT
    | (true, false) => MOVE_LEFT
    | (true, true) => STAY_STILL

  fun getFacing (facing, xAxis) =
    case xAxis of
      STAY_STILL => facing
    | MOVE_LEFT => FACING_LEFT
    | MOVE_RIGHT => FACING_RIGHT

  (* function returns default yAxis when neither up/down are pressed
   * or both are pressed. 
   *
   * In the case where the user was previously jumping,
   * we enter the floating stage, because it's normal for games
   * to have a very brief floating/gliding period before applying gravity.
   *
   * In the case where the user was previously floating, we want the player to
   * keep floating at this point (another function will apply gravity if we
   * floated enough).
   *
   * In every other case, we return the FALLING variant,
   * which has the same effect as returning the ON_GROUND variant,
   * except that it means gravity is applied if we walk off a platform.
   * *)
  fun defaultYAxis prevAxis =
    case prevAxis of
      JUMPING _ => FLOATING 0
    | FLOATING _ => prevAxis
    | DROP_BELOW_PLATFORM => prevAxis
    | _ => FALLING

  (* We want to prevent a double jump
   * or jumping while the player is falling
   * so we only switch to the JUMPING case if the player
   * is on the ground. *)
  fun onJumpPressed (prevAxis, jumpPressed) =
    case prevAxis of
      ON_GROUND =>
        if jumpPressed then (* apply gravity *) FALLING else JUMPING 0
    | _ => prevAxis

  fun checkWalls (player, walls, lst, acc) =
    let
      open QuadTree
    in
      case lst of
        (QUERY_ON_LEFT_SIDE, wallID) :: tl =>
          let
            val {x = wallX, width = wallWidth, ...} =
              Vector.sub (walls, wallID - 1)

            val newX = wallX + wallWidth
            val acc = W_X newX :: acc
          in
            checkWalls (player, walls, tl, acc)
          end
      | (QUERY_ON_RIGHT_SIDE, wallID) :: tl =>
          let
            val {x = wallX, width = wallWidth, ...} =
              Vector.sub (walls, wallID - 1)

            val newX = wallX - Constants.playerSize
            val acc = W_X newX :: acc
          in
            checkWalls (player, walls, tl, acc)
          end
      | (QUERY_ON_BOTTOM_SIDE, wallID) :: tl =>
          let
            val {y = wallY, ...} = Vector.sub (walls, wallID - 1)

            val newY = wallY - Constants.playerSize
            val acc = W_Y_AXIS ON_GROUND :: W_Y newY :: acc
          in
            checkWalls (player, walls, tl, acc)
          end
      | (QUERY_ON_TOP_SIDE, wallID) :: tl => checkWalls (player, walls, tl, acc)
      | [] => acc
    end

  fun checkPlatforms (player, platforms, lst, acc) =
    let
      open QuadTree
    in
      case lst of
        platID :: tl =>
          (case #yAxis player of
             DROP_BELOW_PLATFORM =>
               (* pass through, allowing player to drop below the platform *)
               checkPlatforms (player, platforms, tl, acc)
           | JUMPING _ =>
               (* pass through, allowing player to jump above the platform *)
               checkPlatforms (player, platforms, tl, acc)
           | _ =>
               let
                 (* default case: 
                  * player will land on platform and stay on the ground there. *)
                 val {y = platY, ...} = Vector.sub (platforms, platID - 1)

                 val newY = platY - Constants.playerSize
                 val acc = W_Y_AXIS ON_GROUND :: W_Y newY :: acc
               in
                 checkPlatforms (player, platforms, tl, acc)
               end)
      | [] => acc
    end

  (* only checks for collisions with environment (walls and platforms) *)
  fun getEnvironmentPatches (player, game) =
    let
      val {walls, wallTree, platformTree, platforms, ...} = game

      val {x, y, ...} = player

      val size = Constants.playerSize
      val ww = Constants.worldWidth
      val wh = Constants.worldHeight

      val platCollisions = QuadTree.getCollisionsBelow
        (x, y, size, size, 0, 0, ww, wh, 0, platformTree)
      val acc = checkPlatforms (player, platforms, platCollisions, [])

      val wallCollisions = QuadTree.getCollisionSides
        (x, y, size, size, 0, 0, ww, wh, 0, wallTree)
    in
      checkWalls (player, walls, wallCollisions, acc)
    end

  fun getJumpPatches (player, upHeld, downHeld, acc) =
    let
      val {yAxis, jumpPressed, ...} = player
    in
      case (upHeld, downHeld) of
        (false, false) =>
          let
            val yAxis = defaultYAxis yAxis
            val jumpPressed = false
          in
            W_JUMP_PRESSED jumpPressed :: W_Y_AXIS yAxis :: acc
          end
      | (true, true) =>
          let val yAxis = defaultYAxis yAxis
          in W_Y_AXIS yAxis :: acc
          end
      | (true, false) =>
          let
            val yAxis = onJumpPressed (yAxis, jumpPressed)
            val jumpPressed = true
          in
            W_Y_AXIS yAxis :: W_JUMP_PRESSED jumpPressed :: acc
          end
      | (false, true) =>
          let
            val jumpPressed = false
            val yAxis = DROP_BELOW_PLATFORM
          in
            W_Y_AXIS yAxis :: W_JUMP_PRESSED jumpPressed :: acc
          end
    end

  fun prevWasNotAttacking prevAttack = prevAttack <> MAIN_ATTACKING

  (* called only when player has no projectiles or was not previously attacking *)
  fun helpGetMainAttackPatches (attackHeld, chargeHeld, charge) =
    if attackHeld andalso charge > 0 then W_MAIN_ATTACK MAIN_ATTACKING
    else if chargeHeld andalso not attackHeld then W_MAIN_ATTACK MAIN_CHARGING
    else W_MAIN_ATTACK MAIN_NOT_ATTACKING

  fun degreesToRadians degrees = Real32.fromInt degrees * Constants.projectilePi

  fun defeatedEnemiesToProjectiles
    (pos, defeteadEnemies, player as {x, y, facing, ...}, acc) =
    if pos = Vector.length defeteadEnemies then
      Vector.fromList acc
    else
      let
        val diff =
          Constants.halfPlayerSizeReal - (Constants.projectileSize / 2.0)
        val x = Real32.fromInt x + diff
        val y = Real32.fromInt y + diff

        val {angle} = Vector.sub (defeteadEnemies, pos)
        val angle = degreesToRadians angle

        val x = ((Real32.Math.cos angle) * Constants.projectileDistance) + x
        val y = ((Real32.Math.sin angle) * Constants.projectileDistance) + y

        val x = Real32.toInt IEEEReal.TO_NEAREST x
        val y = Real32.toInt IEEEReal.TO_NEAREST y

        val acc = {x = x, y = y, facing = facing} :: acc
      in
        defeatedEnemiesToProjectiles (pos + 1, defeteadEnemies, player, acc)
      end

  fun getThrowPatches (defeteadEnemies, projectiles, player, acc) =
    let
      val newProjectiles =
        defeatedEnemiesToProjectiles (0, defeteadEnemies, player, [])

      (* concatenate new projectiles with previous projectiles *)
      val allProjectiles = Vector.concat [newProjectiles, projectiles]

      (* remove defeated enemies from player record *)
      val enemies = Vector.fromList []
    in
      W_MAIN_ATTACK MAIN_THROWING :: W_PROJECTILES allProjectiles
      :: W_ENEMIES enemies :: acc
    end

  fun getMainAttackPatches
    ( prevAttack
    , defeteadEnemies
    , projectiles
    , attackHeld
    , chargeHeld
    , charge
    , player
    , acc
    ) =
    case prevAttack of
      MAIN_NOT_ATTACKING =>
        if attackHeld andalso Vector.length defeteadEnemies > 0 then
          (* shoot projectiles if player was not attacking previously, 
           * and there is more than one enemy *)
          getThrowPatches (defeteadEnemies, projectiles, player, acc)
        else
          let
            val mainAttack =
              helpGetMainAttackPatches (attackHeld, chargeHeld, charge)
          in
            mainAttack :: acc
          end
    | MAIN_CHARGING =>
        if attackHeld andalso Vector.length defeteadEnemies > 0 then
          getThrowPatches (defeteadEnemies, projectiles, player, acc)
        else
          let
            val mainAttack =
              helpGetMainAttackPatches (attackHeld, chargeHeld, charge)
          in
            mainAttack :: acc
          end
    | MAIN_ATTACKING =>
        let
          val mainAttack =
            helpGetMainAttackPatches (attackHeld, chargeHeld, charge)
        in
          mainAttack :: acc
        end
    | MAIN_THROWING =>
        if attackHeld then
          acc
        else
          let
            val mainAttack =
              helpGetMainAttackPatches (attackHeld, chargeHeld, charge)
          in
            mainAttack :: acc
          end

  fun getInputPatches (player: player, input) =
    let
      val
        { x
        , y
        , yAxis
        , jumpPressed
        , facing
        , mainAttack
        , mainAttackPressed
        , charge
        , enemies
        , projectiles
        , ...
        } = player

      val {leftHeld, rightHeld, upHeld, downHeld, attackHeld, chargeHeld} =
        input

      val xAxis = getXAxis (leftHeld, rightHeld)
      val facing = getFacing (facing, xAxis)

      val charge =
        case mainAttack of
          MAIN_CHARGING => Int.min (charge + 1, Constants.maxCharge)
        | MAIN_ATTACKING => Int.max (charge - 1, 0)
        | _ => charge

      val acc = [W_X_AXIS xAxis, W_FACING facing, W_CHARGE charge]

      val acc = getMainAttackPatches
        ( mainAttack
        , enemies
        , projectiles
        , attackHeld
        , chargeHeld
        , charge
        , player
        , acc
        )

      val acc = getJumpPatches (player, upHeld, downHeld, acc)
    in
      acc
    end

  fun getRecoilPatches player =
    case #recoil player of
      NO_RECOIL => []
    | RECOIL_LEFT recoiled =>
        (* if player is recoiling, don't accept or adjust any input.
         * However, if player has reached the recoil limit, exit the recoil
         * state and accept input.
         * *)
        if recoiled = Constants.recoilLimit then
          [W_RECOIL NO_RECOIL]
        else
          let
            val {x, y, health, attacked, facing, xAxis, ...} = player
            (* difference between RECOIL_LEFT and RECOIL_RIGHT
             * is the direction player moves back in *)
            val x = x - 5

            val xAxis = STAY_STILL
            val yAxis = FALLING
            val jumpPressed = false
            val recoiled = recoiled + 1
            val recoil = RECOIL_LEFT recoiled
            val facing = getFacing (facing, xAxis)
          in
            [ W_X x
            , W_X_AXIS xAxis
            , W_Y_AXIS yAxis
            , W_JUMP_PRESSED jumpPressed
            , W_RECOIL recoil
            , W_FACING facing
            ]
          end
    | RECOIL_RIGHT recoiled =>
        if recoiled = Constants.recoilLimit then
          [W_RECOIL NO_RECOIL]
        else
          let
            val {x, y, health, attacked, facing, xAxis, ...} = player
            val x = x + 5

            val xAxis = STAY_STILL
            val yAxis = FALLING
            val jumpPressed = false
            val recoiled = recoiled + 1
            val recoil = RECOIL_RIGHT recoiled
            val facing = getFacing (facing, xAxis)
          in
            [ W_X x
            , W_X_AXIS xAxis
            , W_Y_AXIS yAxis
            , W_JUMP_PRESSED jumpPressed
            , W_RECOIL recoil
            , W_FACING facing
            ]
          end

  fun helpMoveProjectiles (pos, projectiles, acc) =
    if pos < 0 then
      Vector.fromList acc
    else
      let
        val {x, y, facing} = Vector.sub (projectiles, pos)
      in
        if x <= 0 orelse x >= Constants.worldWidth then
          (* filter out since projectile is not visible *)
          helpMoveProjectiles (pos - 1, projectiles, acc)
        else
          let
            val x =
              case facing of
                FACING_LEFT => x - Constants.movePlayerBy
              | FACING_RIGHT => x + Constants.movePlayerBy

            val newTile = {x = x, y = y, facing = facing}
            val acc = newTile :: acc
          in
            helpMoveProjectiles (pos - 1, projectiles, acc)
          end
      end

  fun getProjectilePatches ({projectiles, ...}) =
    let
      val newProjectiles = helpMoveProjectiles
        (Vector.length projectiles - 1, projectiles, [])
    in
      [W_PROJECTILES newProjectiles]
    end

  fun runPhysicsAndInput (game: game_type, input) =
    let
      val player = #player game

      val patches = getProjectilePatches player
      val player = withPatches (player, patches)

      val patches = getRecoilPatches player
      val player = withPatches (player, patches)

      val player =
        (* we only accept and handle input if player is not recoiling *)
        case #recoil player of
          NO_RECOIL =>
            let val patches = getInputPatches (player, input)
            in withPatches (player, patches)
            end
        | _ => player

      val player =
        let
          val e = #enemies player
          val e =
            Vector.map
              (fn {angle} => {angle = if angle < 360 then angle + 5 else 0}) e
          val patches = [W_ENEMIES e]
        in
          withPatches (player, patches)
        end

      val patches = PlayerPhysics.getPatches player
      val player = withPatches (player, patches)

      val patches = getEnvironmentPatches (player, game)
    in
      withPatches (player, patches)
    end

  (* block is placeholder asset *)
  fun helpGetDrawVec (x, y, size, width, height, attacked, mainAttack) =
    case mainAttack of
      MAIN_NOT_ATTACKING =>
        (case attacked of
           NOT_ATTACKED =>
             Block.lerp (x, y, size, size, width, height, 0.5, 0.5, 0.5)
         | ATTACKED amt =>
             if amt mod 5 = 0 then
               Block.lerp (x, y, size, size, width, height, 0.9, 0.9, 0.9)
             else
               Block.lerp (x, y, size, size, width, height, 0.5, 0.5, 0.5))
    | MAIN_THROWING =>
        (case attacked of
           NOT_ATTACKED =>
             Block.lerp (x, y, size, size, width, height, 0.5, 0.5, 0.5)
         | ATTACKED amt =>
             if amt mod 5 = 0 then
               Block.lerp (x, y, size, size, width, height, 0.9, 0.9, 0.9)
             else
               Block.lerp (x, y, size, size, width, height, 0.5, 0.5, 0.5))
    | MAIN_ATTACKING =>
        (case attacked of
           NOT_ATTACKED =>
             Block.lerp (x, y, size, size, width, height, 1.0, 0.5, 0.5)
         | ATTACKED amt =>
             if amt mod 5 = 0 then
               Block.lerp (x, y, size, size, width, height, 1.0, 0.9, 0.9)
             else
               Block.lerp (x, y, size, size, width, height, 1.0, 0.5, 0.5))
    | MAIN_CHARGING =>
        (case attacked of
           NOT_ATTACKED =>
             Block.lerp (x, y, size, size, width, height, 1.0, 0.5, 0.5)
         | ATTACKED amt =>
             if amt mod 5 = 0 then
               Block.lerp (x, y, size, size, width, height, 1.0, 0.9, 0.9)
             else
               Block.lerp (x, y, size, size, width, height, 1.0, 0.5, 0.5))

  fun getDrawVec (player: player, width, height) =
    let
      val {x, y, attacked, mainAttack, ...} = player
      val wratio = width / Constants.worldWidthReal
      val hratio = height / Constants.worldHeightReal
    in
      if wratio < hratio then
        let
          val scale = Constants.worldHeightReal * wratio
          val yOffset =
            if height > scale then (height - scale) / 2.0
            else if height < scale then (scale - height) / 2.0
            else 0.0

          val x = Real32.fromInt x * wratio
          val y = Real32.fromInt y * wratio + yOffset

          val realSize = Constants.playerSizeReal * wratio
        in
          helpGetDrawVec (x, y, realSize, width, height, attacked, mainAttack)
        end
      else
        let
          val scale = Constants.worldWidthReal * hratio
          val xOffset =
            if width > scale then (width - scale) / 2.0
            else if width < scale then (scale - width) / 2.0
            else 0.0

          val x = Real32.fromInt x * hratio + xOffset
          val y = Real32.fromInt y * hratio

          val realSize = Constants.playerSizeReal * hratio
        in
          helpGetDrawVec (x, y, realSize, width, height, attacked, mainAttack)
        end
    end

  fun getFieldVec (player: player, width, height) =
    case #mainAttack player of
      MAIN_NOT_ATTACKING => Vector.fromList []
    | MAIN_THROWING => Vector.fromList []
    | _ =>
        let
          val {x, y, ...} = player
          val wratio = width / Constants.worldWidthReal
          val hratio = height / Constants.worldHeightReal
        in
          if wratio < hratio then
            let
              val scale = Constants.worldHeightReal * wratio
              val yOffset =
                if height > scale then (height - scale) / 2.0
                else if height < scale then (scale - height) / 2.0
                else 0.0

              val x = (Real32.fromInt x - Constants.halfPlayerSizeReal) * wratio
              val y =
                (Real32.fromInt y - Constants.halfPlayerSizeReal) * wratio
                + yOffset

              val realSize = (Constants.playerSizeReal * 2.0) * wratio

              val {charge, ...} = player
              val alpha = Real32.fromInt charge / 60.0
            in
              Field.lerp
                (x, y, realSize, realSize, width, height, 0.7, 0.7, 1.0, alpha)
            end
          else
            let
              val scale = Constants.worldWidthReal * hratio
              val xOffset =
                if width > scale then (width - scale) / 2.0
                else if width < scale then (scale - width) / 2.0
                else 0.0

              val x =
                (Real32.fromInt x - Constants.halfPlayerSizeReal) * hratio
                + xOffset
              val y = (Real32.fromInt y - Constants.halfPlayerSizeReal) * hratio

              val realSize = (Constants.playerSizeReal * 2.0) * hratio

              val {charge, ...} = player
              val alpha = Real32.fromInt charge / 60.0
            in
              Field.lerp
                (x, y, realSize, realSize, width, height, 0.7, 0.7, 1.0, alpha)
            end
        end

  fun helpGetPelletVec
    ( playerX
    , playerY
    , pos
    , enemies
    , width
    , height
    , ratio
    , xOffset
    , yOffset
    , acc
    ) =
    if pos = Vector.length enemies then
      Vector.concat acc
    else
      let
        val {angle} = Vector.sub (enemies, pos)
        (* convert degrees to radians *)
        val angle = degreesToRadians angle

        (* calculate pellet's x and y *)
        val pelletX =
          ((Real32.Math.cos angle) * Constants.projectileDistance) + playerX
        val pelletX = pelletX * ratio + xOffset

        val pelletY =
          ((Real32.Math.sin angle) * Constants.projectileDistance) + playerY
        val pelletY = pelletY * ratio + yOffset

        val defeatedSize = Constants.projectileSize * ratio

        val vec = Field.lerp
          ( pelletX
          , pelletY
          , defeatedSize
          , defeatedSize
          , width
          , height
          , 0.3
          , 0.9
          , 0.3
          , 1.0
          )
        val acc = vec :: acc
      in
        helpGetPelletVec
          ( playerX
          , playerY
          , pos + 1
          , enemies
          , width
          , height
          , ratio
          , xOffset
          , yOffset
          , acc
          )
      end

  fun getPelletVec (player: player, width, height) =
    if Vector.length (#enemies player) = 0 then
      Vector.fromList []
    else
      let
        val {x, y, enemies, ...} = player

        (* get centre (x, y) coordinates of player *)
        val diff =
          Constants.halfPlayerSizeReal - (Constants.projectileSize / 2.0)
        val x = Real32.fromInt x + diff
        val y = Real32.fromInt y + diff

        val wratio = width / Constants.worldWidthReal
        val hratio = height / Constants.worldHeightReal
      in
        if wratio < hratio then
          let
            val scale = Constants.worldHeightReal * wratio
            val yOffset =
              if height > scale then (height - scale) / 2.0
              else if height < scale then (scale - height) / 2.0
              else 0.0
          in
            helpGetPelletVec
              (x, y, 0, enemies, width, height, wratio, 0.0, yOffset, [])
          end
        else
          let
            val scale = Constants.worldWidthReal * hratio
            val xOffset =
              if width > scale then (width - scale) / 2.0
              else if width < scale then (scale - width) / 2.0
              else 0.0
          in
            helpGetPelletVec
              (x, y, 0, enemies, width, height, hratio, xOffset, 0.0, [])
          end
      end
end
