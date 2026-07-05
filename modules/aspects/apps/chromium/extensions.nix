{
  den.aspects.apps.chromium = {
    nixos = {
      programs.chromium.extensions = [
        "ddkjiahejlhfcafbddmgiahcphecmpfh" # ublock origin lite
        "lodbfhdipoipcjmlebjbgmmgekckhpfb" # harper
        # "dbepggeogbaibhgnhhndojpepiihcmeb" # vimium
      ];
    };

    homeManager = {
      programs.chromium.extensions = [
        "nngceckbapebfimnlniiiahkandclblb" # Bitwarden
      ];
    };
  };
}
