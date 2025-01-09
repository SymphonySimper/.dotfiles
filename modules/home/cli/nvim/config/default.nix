{ ... }:
{
  imports = [
    ./autocmds.nix
    ./colorscheme.nix
    ./commands.nix
    ./diagnostics.nix
    ./filetype.nix
    ./keymaps.nix
    ./options.nix

    ./plugins
    ./snippets
  ];
}
