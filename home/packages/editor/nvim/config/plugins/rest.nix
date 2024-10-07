{ lib, pkgs, ... }:
{
  programs.nixvim = {
    plugins.rest = {
      enable = true;
      enableHttpFiletypeAssociation = true;
      enableTelescope = true;
    };

    keymaps = (
      lib.my.mkKeymaps [
        [
          "<cmd>Rest run<cr>"
          "<leader>rr"
          "n"
          "Run request under the cursor"
        ]
        [
          "<cmd>Rest run last<cr>"
          "<leader>rl"
          "n"
          "Re-run latest request"
        ]
      ]
    );

    extraFiles = {
      "ftplugin/json.lua".text = # lua
        ''
          vim.bo.formatexpr = ""
          vim.bo.formatprg = "${lib.getExe pkgs.jq}"
        '';
    };
  };
}
