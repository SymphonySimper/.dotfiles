{ pkgs, lib, ... }:
let
  mkPrettier = name: {
    command = "${lib.getExe pkgs.nodePackages.prettier}";
    args = [
      "--parser"
      name
    ];
  };
in
{
  programs.helix = lib.mkMerge [
    {
      # Just
      language.just.formatter = {
        command = "${lib.getExe pkgs.just}";
        args = [ "--dump" ];
      };
    }

    {
      # Docker
      lsp.docker-langserver.command = "${lib.getExe pkgs.dockerfile-language-server-nodejs}";
    }

    {
      # markup
      language = {
        yaml.formatter = mkPrettier "yaml";

        toml.formatter = {
          command = "${lib.getExe pkgs.taplo}";
          args = [
            "format"
            "-"
          ];
        };
      };
    }

    {
      # JSON
      language.json.formatter = mkPrettier "json";
      language.jsonc.formatter = mkPrettier "jsonc";
    }

    {
      # Rust
      lsp.rust-analyzer.config.check = "clippy";
    }

    {
      # Python
      lsp = {
        pyright = {
          command = lib.getExe' pkgs.pyright "pyright-langserver";
          config.python.analysis.typeCheckingMode = "basic";
        };

        ruff = {
          command = lib.getExe' pkgs.ruff "ruff";
          args = [ "server" ];
        };
      };

      language.python = {
        language-servers = [
          "pyright"
          "ruff"
        ];

        formatter = {
          command = "${lib.getExe pkgs.ruff}";
          args = [
            "format"
            "--line-length"
            "88"
            "-"
          ];
        };
      };
    }

    {
      # Markdown
      lsp.markdown-oxide.command = "${lib.getExe pkgs.markdown-oxide}";
      language.markdown.formatter = mkPrettier "markdown";
    }

    {
      # Web
      lsp.tailwindcss-ls = {
        command = "${lib.getExe pkgs.tailwindcss-language-server}";
        args = [ "--stdio" ];
      };

      ## HTML
      lsp.vscode-html-language-server.command = lib.getExe' pkgs.vscode-langservers-extracted "vscode-html-language-server";
      language.html = {
        language-servers = [
          "vscode-html-language-server"
          "tailwindcss-ls"
        ];
        formatter = mkPrettier "html";
      };

      ## CSS
      lsp.vscode-css-language-server.command = lib.getExe' pkgs.vscode-langservers-extracted "vscode-css-language-server";
      language.css = {
        language-servers = [
          "vscode-css-language-server"
          "tailwindcss-ls"
        ];
        formatter = mkPrettier "css";
      };

      # JS / TS
      lsp.typescript-language-server.command = lib.getExe pkgs.typescript-language-server;
      language.javascript.formatter = mkPrettier "typescript";
      language.typescript.formatter = mkPrettier "typescript";

      # Svelte
      lsp.svelteserver.command = "${lib.getExe pkgs.svelte-language-server}";
      language.svelte = {
        language-servers = [
          "svelteserver"
          "tailwindcss-ls"
        ];
        formatter = mkPrettier "svelte";
      };
    }
  ];
}
