{
  pkgs,
  lib,
  sites,
  mkGetSiteNameAndURL,
  ...
}:
{
  programs.firefox = {
    enable = true;
    package = (
      pkgs.wrapFirefox (pkgs.firefox-unwrapped.override {
        drmSupport = true;
        pipewireSupport = true;
        waylandSupport = true;
        webrtcSupport = true;
      }) { }
    );

    policies = import ./policies.nix { inherit lib; };

    profiles.default = {
      id = 0;
      isDefault = true;

      containersForce = true;
      containers.work = {
        id = 1;
        color = "blue";
        icon = "briefcase";
      };

      settings = import ./settings.nix { inherit lib; };
      search = import ./search.nix { inherit pkgs lib; };

      bookmarks = {
        force = true;
        settings = builtins.mapAttrs (name: value: {
          inherit name;
          bookmarks = builtins.map mkGetSiteNameAndURL value;
        }) sites;
      };
    };
  };
}
