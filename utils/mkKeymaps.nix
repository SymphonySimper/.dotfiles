let
  mkKeymap = keymaps: map
    (keymap: {
      action = builtins.elemAt keymap 0;
      key = builtins.elemAt keymap 1;
      mode = builtins.elemAt keymap 2;
      options = {
        desc = builtins.elemAt keymap 3;
        silent = true;
      };
      lua = if builtins.length keymap == 5 then builtins.elemAt keymap 4 else false;
    })
    keymaps;
in
mkKeymap
