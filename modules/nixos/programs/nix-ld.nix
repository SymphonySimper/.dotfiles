{ pkgs, lib, ... }: {
  programs.nix-ld = {
    enable = lib.mkDefault true;

    libraries = [
      pkgs.stdenv.cc.cc
      pkgs.zlib
    ];
  };
}
