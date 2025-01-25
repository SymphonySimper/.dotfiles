{ ... }:
{
  imports = [
    ./chromium.nix
    ./desktop/de.nix
    ./desktop/wm.nix
    ./gaming.nix
    ./kanata.nix

    ./vm
  ];
}
