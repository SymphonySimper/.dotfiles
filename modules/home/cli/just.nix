{ pkgs, lib, ... }:
{
  home.packages = with pkgs; [
    gnumake
    just
  ];

  programs.helix.language.just.formatter = {
    command = "${lib.getExe pkgs.just}";
    args = [ "--dump" ];
  };
}
