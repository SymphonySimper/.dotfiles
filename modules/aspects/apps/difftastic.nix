{ lib, ... }: {
  den.aspects.apps.difftastic = {
    homeManager =
      { config, ... }:
      let
        exe = lib.getExe config.programs.difftastic.package;
      in
      {
        programs.difftastic = {
          enable = true;
          git.enable = false;
        };

        # refer: https://difftastic.wilfred.me.uk/git.html#regular-usage
        programs.git.settings.alias =
          let
            mkAlias =
              display: nameSuffix:
              let
                valuePrefix = "-c diff.external='${exe} --display=${display}'";
              in
              {
                "dl${nameSuffix}" = "${valuePrefix} log -p --ext-diff";
                "ds${nameSuffix}" = "${valuePrefix} show --ext-diff";
                "df${nameSuffix}" = "${valuePrefix} diff";
              };
          in
          lib.attrsets.mergeAttrsList [
            (mkAlias "side-by-side" "")
            (mkAlias "inline" "i")
          ];
      };
  };
}
