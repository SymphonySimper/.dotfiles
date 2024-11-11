{ ... }:
{
  programs.nixvim = {
    plugins.harpoon = {
      enable = true;
      markBranch = true;
      keymaps = {
        addFile = "<leader>H";
        toggleQuickMenu = "<leader>h";
        navFile = (
          builtins.listToAttrs (
            builtins.map
              (
                num:
                let
                  n = builtins.toString num;
                in
                {
                  name = n;
                  value = "<leader>${n}";
                }
              )
              [
                1
                2
                3
                4
                5
                6
                7
                8
                9
              ]
          )
        );
      };
    };
  };
}
