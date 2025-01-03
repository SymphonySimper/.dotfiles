{ pkgs, lib, ... }:
{
  python = pkgs.mkShell {
    packages = with pkgs; [ cowsay ];
    shellHook = # sh
      ''
        cowsay "Happy Python!"
      '';
  };
}
