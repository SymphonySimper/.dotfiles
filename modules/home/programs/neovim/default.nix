{ config, lib, ... }: {
  imports = [
    ./conform.nix
    ./fzf-lua.nix
    ./keymaps.nix
    ./lsp.nix
    ./options.nix
    ./tree-sitter.nix
  ];

  options.programs.neovim = {
    config.lua = lib.mkOption {
      type = lib.types.lines;
      description = "Config to be added to init.lua";
      default = "";
    };
  };

  config = {
    programs.neovim = {
      enable = true;
      # defaultEditor = false;
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;
      waylandSupport = config.desktop.enable;

      withNodeJs = lib.mkForce false;
      withPerl = lib.mkForce false;
      withRuby = lib.mkForce false;
      withPython3 = lib.mkForce false;

      initLua = config.programs.neovim.config.lua;
    };
  };
}
