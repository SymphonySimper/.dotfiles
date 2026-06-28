{ den, ... }:
{
  # user aspect
  den.aspects.symph = {
    includes = [
      den.batteries.define-user
      den.batteries.primary-user
    ];

    homeManager =
      { pkgs, ... }:
      {
        home.packages = [ pkgs.htop ];
      };

    # user can provide NixOS configurations
    # to any host it is included on
    provides.to-hosts.nixos = { pkgs, ... }: { };
  };
}
