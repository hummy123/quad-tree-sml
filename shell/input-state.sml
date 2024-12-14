structure InputState =
struct
  (* global state detecting button inputs *)
  val state =
    { leftHeld = ref false
    , rightHeld = ref false
    , upHeld = ref false
    , downHeld = ref false
    }

  fun getSnapshot () =
    { leftHeld = !(#leftHeld state)
    , rightHeld = !(#rightHeld state)
    , upHeld = !(#upHeld state)
    , downHeld = !(#downHeld state)
    }

  fun getPlayerXAxis () =
    let
      val lh = #leftHeld state
      val rh = #rightHeld state

      open Player
    in
      case (!lh, !rh) of
        (false, false) => STAY_STILL
      | (false, true) => MOVE_RIGHT
      | (true, false) => MOVE_LEFT
      | (true, true) => STAY_STILL
    end

  open Input

  fun handleKey (key, action) =
    if key = ARROW_UP then
      if action = PRESS then (#upHeld state) := true
      else if action = RELEASE then (#upHeld state) := false
      else ()
    else if key = ARROW_DOWN then
      if action = PRESS then (#downHeld state) := true
      else if action = RELEASE then (#downHeld state) := false
      else ()
    else if key = ARROW_LEFT then
      if action = PRESS then (#leftHeld state) := true
      else if action = RELEASE then (#leftHeld state) := false
      else ()
    else if key = ARROW_RIGHT then
      if action = PRESS then (#rightHeld state) := true
      else if action = RELEASE then (#rightHeld state) := false
      else ()
    else
      ()

  fun keyCallback (key, scancode, action, mods) =
    let open Input
    in if mods = 0 then handleKey (key, action) else ()
    end

  fun registerCallbacks window =
    let
      val () = Input.exportKeyCallback keyCallback
      val () = Input.setKeyCallback window
    in
      ()
    end
end
