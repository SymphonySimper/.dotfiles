{ lib, ... }: {
  den.aspects.apps.yazi = {
    homeManager =
      { config, pkgs, ... }:
      let
        cfg = config.programs.yazi;
      in
      {
        options.programs.yazi = {
          preview = lib.mkEnableOption "Preview";
        };

        config = {
          programs = {
            yazi = {
              enable = true;
              shellWrapperName = "y";
              package = pkgs.yazi.override {
                optionalDeps = builtins.concatLists [
                  [
                    pkgs._7zz # archive extraction
                    pkgs.fd # file searching
                  ]
                  (lib.optionals cfg.preview [
                    pkgs.ffmpeg # video thumbnails
                    pkgs.imagemagick # font, HEIC, JPEG XL preview
                    pkgs.poppler-utils # PDF preview
                    pkgs.resvg # SVG preview
                  ])
                ];
              };

              settings = {
                mgr.linemode = "mtime";
                preview.max_width = 1920;

                opener.edit = [
                  {
                    run = "$EDITOR %s";
                    block = true;
                  }
                ];

                open.prepend_rules = [
                  {
                    mime = "{audio,video}/*";
                    use = [
                      "open"
                      "reveal"
                    ];
                  }
                ];
              };
            };

            tmux.extraConfig = ''
              bind y new-window -c "#{pane_current_path}" ${lib.getExe config.programs.yazi.package}
            '';
          };
        };
      };
  };
}
