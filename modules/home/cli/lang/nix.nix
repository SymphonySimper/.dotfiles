{
  inputs,
  pkgs,
  lib,
  config,
  my,
  ...
}:
{
  options.my.programs.nixpkgs-update.enable = lib.mkEnableOption "nixpkgs-update";
  config = {
    home = {
      shellAliases = {
        snrs = "cd $HOME/.dotfiles && sudo nixos-rebuild switch --flake";
        nix_flake_update = "nix flake update --commit-lock-file";
        hmbs = "cd $HOME/.dotfiles && home-manager build switch --flake";
      };

      packages = lib.optionals config.my.programs.nixpkgs-update.enable [
        inputs.nixpkgs-update.packages.${my.system}.nixpkgs-update
        pkgs.tree
      ];
    };

    programs.nixvim.plugins = {
      treesitter.grammars = [ "nix" ];

      conform-nvim = {
        formatter.nixfmt = pkgs.nixfmt-rfc-style;
        settings.formatters_by_ft.nix = [ "nixfmt" ];
      };

      lsp.servers.nil_ls = {
        enable = true;
        settings.nix.flake.autoArchive = true;
      };
    };
  };
}
