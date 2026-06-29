{ lib, den, ... }:
{
  den = {
    default = {
      includes = [ den.batteries.inputs' ];

      nixos.system.stateVersion = "25.11";
      homeManager.home.stateVersion = "25.11";
    };

    # enable hm by default
    schema.user.classes = lib.mkDefault [ "homeManager" ];
  };
}
