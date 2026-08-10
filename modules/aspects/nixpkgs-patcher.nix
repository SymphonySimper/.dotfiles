{
  den,
  inputs,
  config,
  lib,
  ...
}:
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
            inherit patches;
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
  options.nixpkgs-patches = lib.mkOption {
    type = lib.types.attrsOf (
      lib.types.oneOf [
        lib.types.int
        lib.types.str
      ]
    );

    default = { };

    description = ''
      Nixpkgs patches.

      PR -> Int
      Commit rev -> String
    '';
  };

  config = {
    flake-file.inputs = lib.mapAttrs' (
      name: source:
      let
        path = if builtins.isInt source then "pull/${toString source}" else "commit/${source}";
      in
      lib.nameValuePair "nixpkgs-patch-${name}" {
        url = "file+https://github.com/NixOS/nixpkgs/${path}.diff?full_index=1";
        flake = false;
      }
    ) config.nixpkgs-patches;

    den.default.includes = [ den.aspects.nixpkgs-patcher ];
    den.aspects.nixpkgs-patcher = {
      nixos = { pkgs, ... }: mkPatchedPkgs pkgs;
      homeManager = { pkgs, ... }: mkPatchedPkgs pkgs;
    };
  };
}
