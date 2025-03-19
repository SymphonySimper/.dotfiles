{ pkgs, lib, ... }:
let
  prettierCmd = "${lib.getExe pkgs.nodePackages.prettier}";
in
{
  programs.helix = {
    lsp = {
      svelteserver.command = "${lib.getExe pkgs.svelte-language-server}";
      tailwindcss-ls = {
        command = "${lib.getExe pkgs.tailwindcss-language-server}";
        args = [ "--stdio" ];
      };
      typescript-language-server.command = lib.getExe pkgs.typescript-language-server;

      vscode-html-language-server.command = lib.getExe' pkgs.vscode-langservers-extracted "vscode-html-language-server";
      vscode-css-language-server.command = lib.getExe' pkgs.vscode-langservers-extracted "vscode-css-language-server";
    };

    language = [
      {
        name = "html";
        language-servers = [
          "vscode-html-language-server"
          "tailwindcss-ls"
        ];
        formatter = {
          command = prettierCmd;
          args = [
            "--parser"
            "html"
          ];
        };
      }
      {
        name = "css";
        language-servers = [
          "vscode-css-language-server"
          "tailwindcss-ls"
        ];
        formatter = {
          command = prettierCmd;
          args = [
            "--parser"
            "css"
          ];
        };
      }
      {
        name = "javascript";
        formatter = {
          command = prettierCmd;
          args = [
            "--parser"
            "typescript"
          ];
        };
      }
      {
        name = "typescript";
        formatter = {
          command = prettierCmd;
          args = [
            "--parser"
            "typescript"
          ];
        };
      }
      {
        name = "svelte";
        language-servers = [
          "svelteserver"
          "tailwindcss-ls"
        ];
        formatter = {
          command = prettierCmd;
          args = [
            "--parser"
            "svelte"
          ];
        };
      }
    ];
  };
}
