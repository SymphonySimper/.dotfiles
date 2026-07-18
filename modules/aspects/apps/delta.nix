{ lib, ... }: {
  den.aspects.apps.delta = {
    homeManager =
      { config, ... }:
      (lib.mkMerge [
        {
          programs.delta = {
            enable = true;

            options = {
              navigate = true;
              side-by-side = true;
              line-numbers = true;
            };
          };
        }

        (lib.mkIf config.programs.git.enable {
          programs.delta.enableGitIntegration = true;
          programs.git.settings.merge.conflictStyle = "zdiff3";
        })
      ]);
  };
}
