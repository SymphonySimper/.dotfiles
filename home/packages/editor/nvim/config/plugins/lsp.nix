{ ... }: {
  programs.nixvim.plugins = {
    lsp = {
      enable = true;
      servers = {
        nixd = {
          enable = true;
          settings.formatting.command = "nixpkgs-fmt";
        };
      };
    };
    lsp-format = { enable = true; };
  };
}
