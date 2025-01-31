{ pkgs, ... }:
{
  packages = with pkgs; [
    python3
    poetry
  ];

  shellHook = # sh
    ''
      export LD_LIBRARY_PATH="$NIX_LD_LIBRARY_PATH"

      # Poetry settings
      export POETRY_VIRTUALENVS_CREATE="true"
      export POETRY_VIRTUALENVS_IN_PROJECT="true"

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
