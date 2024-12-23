structure GlDraw =
struct
  type t =
    { window: MLton.Pointer.t
    , wallVertexBuffer: Word32.word
    , wallProgram: Word32.word
    , wallLength: int
    , playerVertexBuffer: Word32.word
    , playerProgram: Word32.word
    , playerLength: int
    }

  fun createShader (shaderType, shaderString) =
    let
      val shader = Gles3.createShader shaderType
      val _ = Gles3.shaderSource (shader, shaderString)
      val _ = Gles3.compileShader shader
    in
      shader
    end

  fun createProgram (vertexShader, fragmentShader) =
    let
      val program = Gles3.createProgram ()
      val _ = Gles3.attachShader (program, vertexShader)
      val _ = Gles3.attachShader (program, fragmentShader)
      val _ = Gles3.linkProgram program
    in
      program
    end

  fun create window =
    let
      (* create vertex buffer, program, etc. *)
      val xyrgbVertexShader = createShader
        (Gles3.VERTEX_SHADER, GlShaders.xyrgbVertexShaderString)

      val rgbFragmentShader = createShader
        (Gles3.FRAGMENT_SHADER, GlShaders.rgbFragmentShaderString)

      (* wall here includes both walls and platforms *)
      val wallVertexBuffer = Gles3.createBuffer ()
      val wallProgram = createProgram (xyrgbVertexShader, rgbFragmentShader)

      val playerVertexBuffer = Gles3.createBuffer ()
      val playerProgram = createProgram (xyrgbVertexShader, rgbFragmentShader)
    in
      { window = window
      , wallVertexBuffer = wallVertexBuffer
      , wallProgram = wallProgram
      , wallLength = 0
      , playerVertexBuffer = playerVertexBuffer
      , playerProgram = playerProgram
      , playerLength = 0
      }
    end

  fun uploadWall (shellState: t, vec) =
    let
      val
        { window
        , playerVertexBuffer
        , playerProgram
        , playerLength
        , wallVertexBuffer
        , wallProgram
        , wallLength = _
        } = shellState

      val _ = Gles3.bindBuffer wallVertexBuffer
      val _ = Gles3.bufferData (vec, Vector.length vec, Gles3.STATIC_DRAW)
      val newWallLength = Vector.length vec div 5
    in
      { window = window
      , playerVertexBuffer = playerVertexBuffer
      , playerProgram = playerProgram
      , playerLength = playerLength
      , wallVertexBuffer = wallVertexBuffer
      , wallProgram = wallProgram
      , wallLength = newWallLength
      }
    end

  fun uploadPlayer (shellState: t, vec) =
    let
      val
        { window
        , wallVertexBuffer
        , wallProgram
        , wallLength
        , playerVertexBuffer
        , playerProgram
        , playerLength = _
        } = shellState

      val _ = Gles3.bindBuffer playerVertexBuffer
      val _ = Gles3.bufferData (vec, Vector.length vec, Gles3.STATIC_DRAW)
      val newPlayerLength = Vector.length vec div 5
    in
      { window = window
      , wallVertexBuffer = wallVertexBuffer
      , wallProgram = wallProgram
      , wallLength = wallLength
      , playerVertexBuffer = playerVertexBuffer
      , playerProgram = playerProgram
      , playerLength = newPlayerLength
      }
    end

  fun drawXyrgb (vertexBuffer, program, drawLength) =
    if drawLength > 0 then
      let
        val _ = Gles3.bindBuffer vertexBuffer
        (* enable xy component from uploaded array *)
        val _ = Gles3.vertexAttribPointer (0, 2, 5, 0)
        val _ = Gles3.enableVertexAttribArray 0
        (* enable rgb component from uploaded array *)
        val _ = Gles3.vertexAttribPointer (1, 3, 5, 8)
        val _ = Gles3.enableVertexAttribArray 1

        val _ = Gles3.useProgram program
        val _ = Gles3.drawArrays (Gles3.TRIANGLES, 0, drawLength)
      in
        ()
      end
    else
      ()

  fun drawWall ({wallVertexBuffer, wallProgram, wallLength, ...}: t) =
    drawXyrgb (wallVertexBuffer, wallProgram, wallLength)

  fun drawPlayer ({playerVertexBuffer, playerProgram, playerLength, ...}: t) =
    drawXyrgb (playerVertexBuffer, playerProgram, playerLength)

  fun draw (shellState: t) =
    let
      val _ = drawWall shellState
      val _ = drawPlayer shellState
    in
      ()
    end

  fun helpLoop (shellState as {window, ...}: t, game) =
    case Glfw.windowShouldClose window of
      false =>
        let
          val _ = Gles3.clearColor (1.0, 1.0, 1.0, 1.0)
          val _ = Gles3.clear ()

          (* todo:
           * - update game state
           * - consume draw messages 
           * - finally, draw 
           * *)

          val input = InputState.getSnapshot ()
          val width = InputState.getWidth ()
          val height = InputState.getHeight ()

          val game = GameUpdate.update (game, input)

          val playerVec = Player.getDrawVec (#player game, width, height)
          val enemyVec = Enemy.getDrawVec (#enemies game, width, height)
          val playerVec = Vector.concat [playerVec, enemyVec]

          val wallVec = Wall.getDrawVec (#walls game, width, height)
          val platVec = Platform.getDrawVec (#platforms game, width, height)
          val wallVec = Vector.concat [wallVec, platVec]

          val shellState = uploadWall (shellState, wallVec)
          val shellState = uploadPlayer (shellState, playerVec)

          val _ = draw shellState

          val _ = Glfw.swapBuffers window
          val _ = Glfw.pollEvents ()
        in
          helpLoop (shellState, game)
        end
    | true => Glfw.terminate ()

  fun loop window =
    let val shellState = create window
    in helpLoop (shellState, GameType.initial)
    end
end
