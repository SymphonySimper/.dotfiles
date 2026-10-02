{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.programs.fzf;

  mkIntegration =
    shell:
    pkgs.runCommand "fzf-integration-${shell}" { } ''
      ${lib.getExe' cfg.package "fzf"} --${shell} > $out
    '';
in
{
  programs.fzf = {
    enable = lib.mkDefault true;
    defaultOptions = [ "--reverse" ];

    enableBashIntegration = false;
    enableFishIntegration = false;
  };

  programs.bash.initExtra = lib.mkIf cfg.enable "source ${mkIntegration "bash"}";
  programs.fish.interactiveShellInit = lib.mkIf cfg.enable "source ${mkIntegration "fish"}";
}
