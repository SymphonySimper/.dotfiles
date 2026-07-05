{ pkgs, lib }: {
  mkPrettier = name: {
    command = lib.getExe pkgs.prettier;
    args = [
      "--parser"
      name
    ];
  };

  mkVscodeLsp = lang: rec {
    name = "vscode-${lang}-language-server";
    command = lib.getExe' pkgs.vscode-langservers-extracted name;
  };
}
