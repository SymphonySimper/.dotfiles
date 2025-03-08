{ pkgs, lib, ... }:
{
  packages = with pkgs; [
    python3Full
    uv
  ];

  env = {
    LD_LIBRARY_PATH = lib.makeLibraryPath (
      with pkgs;
      [
        stdenv.cc.cc
        zlib
      ]
    );
  };

  shellHook = # sh
    ''
      # init uv
      eval "$(${lib.getExe' pkgs.uv "uv"} generate-shell-completion bash)"
      eval "$(${lib.getExe' pkgs.uv "uvx"} --generate-shell-completion bash)"

      venv_dir=".venv"
      if [ -d "$venv_dir" ]; then
        source "./$venv_dir/bin/activate"
      fi

      alias py="python"
      alias pvc="uv venv $venv_dir"
      alias pva="source $venv_dir/bin/activate"
    '';
}
