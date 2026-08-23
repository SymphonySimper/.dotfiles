{
  config,
  pkgs,
  lib,
  ...
}:
{
  options.programs.bitwarden = {
    enable = lib.mkEnableOption "Bitwarden";
  };

  config = lib.mkIf config.programs.bitwarden.enable {
    home.packages = [ pkgs.bitwarden-desktop ];

    programs.chromium.extensions = [
      "nngceckbapebfimnlniiiahkandclblb" # Bitwarden
    ];
  };
}
