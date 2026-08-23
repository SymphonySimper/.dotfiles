{
  inputs,
  config,
  pkgs,
  lib,
  ...
}:
{
  imports = [
    ./languages.nix
  ];

  home.sessionVariables = rec {
    EDITOR = lib.getExe config.programs.helix.package;
    VISUAL = EDITOR;
  };

  programs.helix = {
    enable = true;
    package = inputs.helix.packages.${pkgs.stdenv.hostPlatform.system}.default;
    ignores = import ./_ignores.nix;

    settings = {
      keys = import ./_keys.nix { inherit config lib; };
      editor = import ./_editor.nix;
    };
  };
}
