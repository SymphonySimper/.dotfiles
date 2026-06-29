{ den, ... }: {
  den.hosts.x86_64-linux.gui.users.symph = { };

  # host aspect
  den.aspects.gui = {
    # host NixOS configuration
    nixos =
      { pkgs, ... }:
      {
        environment.systemPackages = [ pkgs.hello ];
      };

    # host provides default home environment for its users
    provides.to-users.homeManager =
      { pkgs, ... }:
      {
        home.packages = [ pkgs.vim ];
      };

    includes = [ den.aspects.shell ];
  };
}
