{ myUtils, ... }:
{
  programs.nixvim = {
    plugins.trouble = {
      enable = true;
      settings = {
        auto_close = true;
        use_diagnostic_signs = true;
      };
    };

    keymaps = myUtils.mkKeymaps [
      [
        "<CMD>TroubleToggle workspace_diagnostics<CR>"
        "<leader>xx"
        "n"
        "Workspace Diagnostics (Trouble)"
      ]
    ];
  };
}
