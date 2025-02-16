structure GlfwKeyMap =
struct
  open CoreKey

  structure KeyMap =
    MakeGapMap
      (struct
         type key = int
         type value = CoreKey.key_code

         fun l (a: int, b: int) = a < b
         fun eq (a: int, b: int) = a = b
         fun g (a: int, b: int) = a > b

         val maxNodeSize = 1024
       end)

  val map = ref KeyMap.empty

  fun codeFromKey (key: int) =
    KeyMap.get (key, !map)

  fun helpInitKeyMap (pos, pairs, acc) =
    if pos = Vector.length pairs then
      map := acc
    else
      let
        val (code, key) = Vector.sub (pairs, pos)
        val acc = KeyMap.add (code, key, acc)
      in
        helpInitKeyMap (pos + 1, pairs, acc)
      end

  fun initKeyMap () =
    let
      (* vector of (glfw_key_code, Core.key_code) tuples. *)
      val pairs =
       #[ (32, KEY_SPACE)
        , (39, KEY_APOSTROPHE)
        , (44, KEY_COMMA)
        , (45, KEY_MINUS)
        , (46, KEY_PERIOD)
        , (47, KEY_SLASH)
        , (48, KEY_0)
        , (49, KEY_1)
        , (50, KEY_2)
        , (51, KEY_3)
        , (52, KEY_4)
        , (53, KEY_5)
        , (54, KEY_6)
        , (55, KEY_7)
        , (56, KEY_8)
        , (57, KEY_9)
        , (59, KEY_SEMICOLON)
        , (61, KEY_EQUAL)
        , (65, KEY_A)
        , (66, KEY_B)
        , (67, KEY_C)
        , (68, KEY_D)
        , (69, KEY_E)
        , (70, KEY_F)
        , (71, KEY_G)
        , (72, KEY_H)
        , (73, KEY_I)
        , (74, KEY_J)
        , (75, KEY_K)
        , (76, KEY_L)
        , (77, KEY_M)
        , (78, KEY_N)
        , (79, KEY_O)
        , (80, KEY_P)
        , (81, KEY_Q)
        , (82, KEY_R)
        , (83, KEY_S)
        , (84, KEY_T)
        , (85, KEY_U)
        , (86, KEY_V)
        , (87, KEY_W)
        , (88, KEY_X)
        , (89, KEY_Y)
        , (90, KEY_Z)
        , (91, KEY_LEFT_BRACKET)
        , (92, KEY_BACKSLASH)
        , (93, KEY_RIGHT_BRACKET)
        , (96, KEY_GRAVE_ACCENT)
        , (161, KEY_WORLD_1)
        , (162, KEY_WORLD_2)
        , (256, KEY_ESCAPE)
        , (257, KEY_ENTER)
        , (258, KEY_TAB)
        , (259, KEY_BACKSPACE)
        , (260, KEY_INSERT)
        , (261, KEY_DELETE)
        , (262, KEY_RIGHT)
        , (263, KEY_LEFT)
        , (264, KEY_DOWN)
        , (265, KEY_UP)
        , (266, KEY_PAGE_UP)
        , (267, KEY_PAGE_DOWN)
        , (268, KEY_HOME)
        , (269, KEY_END)
        , (280, KEY_CAPS_LOCK)
        , (281, KEY_SCROLL_LOCK)
        , (282, KEY_NUM_LOCK)
        , (283, KEY_PRINT_SCREEN)
        , (284, KEY_PAUSE)
        , (290, KEY_F1)
        , (291, KEY_F2)
        , (292, KEY_F3)
        , (293, KEY_F4)
        , (294, KEY_F5)
        , (295, KEY_F6)
        , (296, KEY_F7)
        , (297, KEY_F8)
        , (298, KEY_F9)
        , (299, KEY_F10)
        , (300, KEY_F11)
        , (301, KEY_F12)
        , (302, KEY_F13)
        , (303, KEY_F14)
        , (304, KEY_F15)
        , (305, KEY_F16)
        , (306, KEY_F17)
        , (307, KEY_F18)
        , (308, KEY_F19)
        , (309, KEY_F20)
        , (310, KEY_F21)
        , (311, KEY_F22)
        , (312, KEY_F23)
        , (313, KEY_F24)
        , (314, KEY_F25)
        , (320, KEY_KP_0)
        , (321, KEY_KP_1)
        , (322, KEY_KP_2)
        , (323, KEY_KP_3)
        , (324, KEY_KP_4)
        , (325, KEY_KP_5)
        , (326, KEY_KP_6)
        , (327, KEY_KP_7)
        , (328, KEY_KP_8)
        , (329, KEY_KP_9)
        , (330, KEY_KP_DECIMAL)
        , (331, KEY_KP_DIVIDE)
        , (332, KEY_KP_MULTIPLY)
        , (333, KEY_KP_SUBTRACT)
        , (334, KEY_KP_ADD)
        , (335, KEY_KP_ENTER)
        , (336, KEY_KP_EQUAL)
        , (340, KEY_LEFT_SHIFT)
        , (341, KEY_LEFT_CONTROL)
        , (342, KEY_LEFT_ALT)
        , (343, KEY_LEFT_SUPER)
        , (344, KEY_RIGHT_SHIFT)
        , (345, KEY_RIGHT_CONTROL)
        , (346, KEY_RIGHT_ALT)
        , (347, KEY_RIGHT_SUPER)
        , (348, KEY_MENU)
        ]
    in
      KeyMap.empty
    end
end
