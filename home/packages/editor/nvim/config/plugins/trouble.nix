{ ... }: {
  programs.nixvim = {
    plugins.trouble = {
      enable = true;
      settings = {
        auto_close = true;
        use_diagnostic_signs = true;
      };
    };

    keymaps = [
      {
        action = "<CMD>TroubleToggle workspace_diagnostics<CR>";
        key = "<leader>xx";
        mode = "n";
        options.desc = "Workspace Diagnostics (Trouble)";
      }
    ];
  };
}
