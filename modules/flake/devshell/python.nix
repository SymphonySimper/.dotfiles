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

    # disable python downloads
    # refer: https://docs.astral.sh/uv/configuration/environment/#uv_python_downloads
    UV_PYTHON_DOWNLOADS = "never";
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
    '';
}
