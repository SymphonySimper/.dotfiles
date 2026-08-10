{
  den,
  inputs,
  lib,
  ...
}:
{
  den.default.includes = [ den.aspects.nixpkgs-patcher ];

  den.aspects.nixpkgs-patcher =
    let
      patches = map (input: input.outPath) (
        lib.attrValues (lib.filterAttrs (name: _: lib.hasPrefix "nixpkgs-patch-" name) inputs)
      );

      mkPatchedPkgs = pkgs: {
        _module.args.patchedPkgs =
          if patches == [ ] then
            pkgs
          else
            let
              patchedNixpkgs = pkgs.applyPatches {
                src = pkgs.path;
                patches = patches;
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
      nixos = { pkgs, ... }: mkPatchedPkgs pkgs;
      homeManager = { pkgs, ... }: mkPatchedPkgs pkgs;
    };
}
