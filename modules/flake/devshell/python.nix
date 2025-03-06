{ pkgs, lib, ... }:
{
  packages = with pkgs; [
    python3
    poetry
  ];

  env = {
    LD_LIBRARY_PATH = lib.makeLibraryPath (
      with pkgs;
      [
        stdenv.cc.cc
        zlib
      ]
    );

    # Poetry settings
    POETRY_VIRTUALENVS_CREATE = true;
    POETRY_VIRTUALENVS_IN_PROJECT = true;
  };

  shellHook = # sh
    ''
      for dir in "venv" ".venv"; do
        if [ -d "$dir" ]; then
          venv_dir="$dir"
          break;
        fi
      done

      if [ -n "$venv_dir" ]; then
        source "./$venv_dir/bin/activate"
      fi

      alias py="python"
      alias pvc="python -m venv .venv"
      alias pva="source .venv/bin/activate"
      alias pfrd="flask run --debug"
    '';
}
