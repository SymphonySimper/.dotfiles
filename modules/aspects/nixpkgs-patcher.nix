{ den, ... }: {
  den.quirks.nixpkgs-patches = {
    description = "Patches for nixpkgs to construct patchedPkgs";
  };

  den.default.includes = [ den.aspects.nixpkgs-patcher ];

  den.aspects.nixpkgs-patcher =
    let
      mkPatchedPkgs = patches: pkgs: {
        _module.args.patchedPkgs =
          if patches == [ ] then
            pkgs
          else
            let
              patchedNixpkgs = pkgs.applyPatches {
                src = pkgs.path;
                patches = map (
                  patch:
                  pkgs.fetchpatch2 {
                    url = "https://github.com/NixOS/nixpkgs/commit/${patch.rev}.diff?full_index=1";
                    inherit (patch) hash;
                  }
                ) patches;
              };
            in
            import patchedNixpkgs {
              inherit (pkgs) config overlays;
              localSystem = pkgs.stdenv.buildPlatform;
              crossSystem = pkgs.stdenv.hostPlatform;
            };
      };
    in
    {
      nixos = { nixpkgs-patches, pkgs, ... }: mkPatchedPkgs nixpkgs-patches pkgs;
      homeManager = { nixpkgs-patches, pkgs, ... }: mkPatchedPkgs nixpkgs-patches pkgs;
    };
}
