{ ... }:
{
  imports = [
    ./chromium.nix
    ./desktop/de.nix
    ./desktop/wm.nix
    ./kanata.nix
    ./steam.nix

    ./vm
  ];
}
