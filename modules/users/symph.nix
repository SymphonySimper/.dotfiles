{ den, lib, ... }:
{
  den.schema.user = { user, ... }: {
    config = lib.mkIf (user.name == "symph") {
      displayName = "SymphonySimper";
    };
  };

  den.aspects.symph = { user, ... }: {
    includes = [
      den.batteries.define-user
      den.batteries.primary-user
    ];

    user = {
      initialPassword = "nix-is-cool";
      description = user.displayName;
    };

    homeManager = {
      nix.settings.trusted-users = [ user.userName ];

      desktop.gnome.wallpaper = ../../assets/images/wallpaper.png;

      programs.git.user = {
        name = lib.mkDefault user.displayName;
        email = lib.mkDefault "50240805+SymphonySimper@users.noreply.github.com";
      };
    };
  };
}
