{ config, pkgs, helix-flake, ... }:
{
  home.packages = with pkgs; [
    helix-flake.packages.${pkgs.system}.default
    # Lsp
    ## svelte
    nodePackages_latest.svelte-language-server
    ## tailwind
    tailwindcss-language-server
    ## ts
    typescript
    nodePackages_latest.typescript-language-server
    ## python
    ruff-lsp
    nodePackages_latest.pyright
  ];
}
