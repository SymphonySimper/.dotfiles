{ config, ... }: {
  nix.settings = {
    trusted-users = config.users.groups.wheel.members;
  };
}
