{ ... }:
{
  # refer: https://github.com/helix-editor/helix/blob/5b0563419eeeaf0595c848865c46be4abad246a7/helix-view/src/clipboard.rs#L401-L402
  my.programs.editor.clipboardProvider =
    let
      command = "/mnt/c/Program Files/Neovim/bin/win32yank.exe";
    in
    {
      yank = {
        inherit command;
        args = [
          "-o"
          "--lf"
        ];
      };
      paste = {
        inherit command;
        args = [
          "-i"
          "--crlf"
        ];
      };
    };
}
