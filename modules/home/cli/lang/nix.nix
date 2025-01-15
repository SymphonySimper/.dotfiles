{ ... }:
{
  home.shellAliases = {
    snrs = "cd $HOME/.dotfiles && sudo nixos-rebuild switch --flake";
    nix_flake_update = "nix flake update --commit-lock-file";
    hmbs = "cd $HOME/.dotfiles && home-manager build switch --flake";
  };

  programs.nixvim.plugins = {
    treesitter.grammars = [ "nix" ];

    lsp.servers.nil_ls = {
      enable = true;
      settings.nix.flake.autoArchive = true;
    };

    formatter = {
      packages = [
        "nixfmt-rfc-style"
      ];
      ft.nix = "nixfmt";
    };
  };
}
