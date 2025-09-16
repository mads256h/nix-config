{ config, pkgs, lib, inputs, stylix, ... }:
{
  programs.nixvim = {
    enable = true;

    viAlias = true;
    vimAlias = true;

    withPython3 = false;
    withRuby = false;

    opts = {
      number = true;
      relativenumber = true;

      autoindent = true;
      copyindent = true;
      expandtab = true;
      shiftround = true;
      shiftwidth = 2;
      smartindent = true;
      smarttab = true;
      softtabstop = 2;
      tabstop = 2;
    };

    colorschemes.onedark.enable = true;
    colorschemes.onedark.settings.transparent = true;

    colorscheme = "onedark";

    keymaps = [
      {
        mode = "n";
        key = "<c-c>";
        action = ''"+yy'';
        options = { noremap = true; silent = true; };
      }
      {
        mode = "v";
        key = "<c-c>";
        action = ''"+y'';
        options = { noremap = true; silent = true; };
      }
      {
        mode = "n";
        key = "<c-v>";
        action = ''"+p'';
        options = { noremap = true; silent = true; };
      }
    ];

    plugins.lualine.enable = true;

    plugins.treesitter = {
      enable = true;
      settings = {
        highlight.enable = true;
        indent.enable = true;
      };
    };
    plugins.treesitter-context.enable = true;
    plugins.treesitter-textobjects.enable = true;
    plugins.lspconfig.enable = true;
    plugins.cmp = {
      enable = true;
      settings = {
        sources = [
          { name = "nvim_lsp"; }
          { name = "luasnip"; }
          { name = "path"; }
        ];

        snippet = {
          expand = ''
            function(args)
              require('luasnip').lsp_expand(args.body)
            end
            '';
        };

        mapping = {
          "<C-p>" = "cmp.mapping.select_prev_item()";
          "<C-n>" = "cmp.mapping.select_next_item()";
          "<C-d>" = "cmp.mapping.scroll_docs(-4)";
          "<C-f>" = "cmp.mapping.scroll_docs(4)";
          "<C-Space>" = "cmp.mapping.complete()";
          "<C-e>" = "cmp.mapping.close()";
          "<CR>" = ''
            cmp.mapping.confirm {
              behavior = cmp.ConfirmBehavior.Replace,
              select = true,
            }
            '';
          "<Tab>" = ''
            function(fallback)
              if cmp.visible() then
                cmp.select_next_item()
              elseif require("luasnip").expand_or_jumpable() then
                require("luasnip").expand_or_jump()
              else
                fallback()
              end
            end
            '';
          "<S-Tab>" = ''
            function(fallback)
              if cmp.visible() then
                cmp.select_prev_item()
              elseif require("luasnip").jumpable(-1) then
                require("luasnip").jump(-1)
              else
                fallback()
              end
            end
            '';
        };
      };
    };
    lsp.servers.nixd = {
      enable = true;
      settings.settings = {
        nixpkgs = {
          # For flake.
          # This expression will be interpreted as "nixpkgs" toplevel
          # Nixd provides package, lib completion/information from it.
          # Resource Usage: Entries are lazily evaluated, entire nixpkgs takes 200~300MB for just "names".
          # Package documentation, versions, are evaluated by-need.
          expr = "import (builtins.getFlake(toString ./.)).inputs.nixpkgs { }";
        };
        # formatting = {
        #     command = { "alejandra" }, -- or nixfmt or nixpkgs-fmt
        # },
        options = {
          nixos = {
            expr = ''let flake = builtins.getFlake(toString ./.); in flake.nixosConfigurations."laptop-mads".options'';
          };
          home_manager = {
            expr = ''let flake = builtins.getFlake(toString ./.); in flake.nixosConfigurations."laptop-mads".options.home-manager.users.type.getSubOptions []'';
          };
        };
      };
    };
    lsp.servers.bashls.enable = true;
    lsp.servers.systemd_ls.enable = true;
    lsp.servers.jsonls.enable = true;
    lsp.servers.clangd.enable = true;
    lsp.servers.cmake.enable = true;
    lsp.servers.rust_analyzer.enable = true;
    lsp.servers.pyright.enable = true;
    lsp.servers.ts_ls.enable = true;
    lsp.servers.cssls.enable = true;
    lsp.servers.eslint.enable = true;
    lsp.servers.html.enable = true;
    lsp.servers.omnisharp.enable = true;
    plugins.lspkind.enable = true;
    plugins.luasnip.enable = true;
    plugins.lsp-signature.enable = true;
    plugins.cmp-nvim-lsp.enable = true;
    plugins.gitsigns.enable = true;
    plugins.gitsigns.settings.signs = {
      add = { text = "+"; };
      change = { text = "~"; };
      delete = { text = "_"; };
      topdelete = { text = "‾"; };
      changedelete = { text = "~"; };
    };
  };

  stylix.targets.nixvim.enable = false;
}
