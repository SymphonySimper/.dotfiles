{ pkgs, ... }:
pkgs.mkShell {
  shellHook = # sh
    ''
      export LD_LIBRARY_PATH="$NIX_LD_LIBRARY_PATH"

      for dir in "venv" ".venv"; do
        if [ -d "$dir" ]; then
          venv_dir="$dir"
          break;
        fi
      done

      if [ -n "$venv_dir" ]; then
        source "./$venv_dir/bin/activate"
      fi
    '';
}
