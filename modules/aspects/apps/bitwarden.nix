{
  den.aspects.apps.bitwarden = {
    homeManager = { pkgs, ... }: {
      home.packages = [ pkgs.bitwarden-desktop ];

      programs.chromium.extensions = [
        "nngceckbapebfimnlniiiahkandclblb" # Bitwarden
      ];
    };
  };
}
