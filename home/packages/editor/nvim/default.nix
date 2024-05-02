{ pkgs, ... }:
{
  # programs.neovim = {
  #   enable = true;
  #   defaultEditor = true;
  #   viAlias = true;
  #   vimAlias = true;
  #   vimdiffAlias = true;
  # };

  # xdg.configFile."nvim" = {
  #   source = ./config;
  #   recursive = true;
  # };

  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    colorscheme = "catppuccin";
    colorschemes.catppuccin = {
      enable = true;
      settings = {
        flavour = "mocha";
      };
    };

    globals = {
      mapleader = " ";
    };

    opts = {
      number = true;
      relativenumber = true;
      colorcolumn = "80";
      # Vertical scroll
      scrolloff = 8;
      # Horizontal scroll
      sidescrolloff = 8;
      # Turn off undofile
      undofile = false;
      # Create folds with visual selection
      foldmethod = "manual";
      # Hide Command line
      cmdheight = 0;
      clipboard = "";
    };

    keymaps = [
      {
        action = "\"+y<CR";
        key = "<leader>y";
        mode = [ "n" "v" ];
        options = {
          desc = "Copy to system clipboard";
        };
      }
      {
        action = "\"+p<CR";
        key = "<leader>p";
        mode = [ "n" "v" ];
        options = {
          desc = "Copy to system clipboard";
        };
      }
    ];
    extraPackages = with pkgs; [
      fd
      gcc
      ripgrep
    ];
    plugins = {
      telescope = {
        enable = true;
        keymaps = {
          "<leader>f" = {
            action = "find_files";
            options.desc = "Telescope find_files";
            mode = [ "n" "v" ];
          };
        };
      };
      treesitter = {
        enable = true;
        indent = true;
        nixvimInjections = true;
        ensureInstalled = [
          "astro"
          "bash"
          "c"
          "css"
          "devicetree"
          "gitcommit"
          "gitignore"
          "html"
          "javascript"
          "jsdoc"
          "json"
          "lua"
          "luadoc"
          "luap"
          "markdown"
          "markdown_inline"
          "python"
          "query"
          "regex"
          "scss"
          "svelte"
          "tsx"
          "typescript"
          "vim"
          "vimdoc"
          "vue"
          "yaml"
        ];
      };

      lsp = {
        enable = true;
        servers = {
          nixd = {
            enable = true;
            settings.formatting.command = "nixpkgs-fmt";
          };
        };
      };
      lsp-format = { enable = true; };
    };

  };

  home.packages = with pkgs; [
    fd
    ripgrep
  ];
}
