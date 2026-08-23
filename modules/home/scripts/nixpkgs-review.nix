{
  config,
  pkgs,
  lib,
  ...
}:
{
  options.scripts.nixpkgsReview = {
    enable = lib.mkEnableOption "Nixpkgs review";
  };

  config = lib.mkIf config.scripts.nixpkgsReview.enable {
    home.packages = [
      (pkgs.writeShellScriptBin "mynixpkgs-review" ''
        pr_id="$1"

        if [ -z "$1" ]; then
          echo "Requires PR ID (ex: 481226)."
          exit 1
        fi

        ${lib.getExe' pkgs.nixpkgs-review "nixpkgs-review"} pr --post-result "$pr_id"
      '')
    ];
  };
}
