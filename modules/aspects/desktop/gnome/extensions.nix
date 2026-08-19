{
  flake-file.inputs = {
    gnome-shell-extensions = {
      url = "git+https://github.com/SymphonySimper/gnome-shell-extensions";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  den.aspects.desktop.gnome.extensions = {
    homeManager = { inputs', ... }: {
      programs.gnome-shell = {
        enable = true;

        extensions = [
          { package = inputs'.gnome-shell-extensions.packages.my; }
          { package = inputs'.gnome-shell-extensions.packages.panel-free; }
        ];
      };
    };
  };
}
