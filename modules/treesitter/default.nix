{ pkgs, config, lib, ...}:
with lib;
with builtins;

let
  cfg = config.vim.treesitter;
in {
  options.vim.treesitter = {
    enable = mkOption {
      type = types.bool;
      description = "enable tree-sitter [nvim-treesitter]";
    };
  };

  config = mkIf cfg.enable (
    let
      writeIf = cond: msg:
      if cond
      then msg
      else "";
    in {  
      vim.startPlugins = with pkgs.neovimPlugins; [
        (nvim-treesitter.withPlugins (
          plugins: with plugins; [
            tree-sitter-nix
            tree-sitter-python
          ]
        ))
      ];
      
      vim.luaConfigRC = let
        tree-sitter-hare = builtins.fetchGit {
          url = "https://git.sr.ht/~ecmma/tree-sitter-hare";
          ref = "master";
          rev = "bc26a6a949f2e0d98b7bfc437d459b250900a165";
        };
      
      in ''
        require'nvim-treesitter.configs'.setup({

          highlight = {
            enable = true,
            use_languagetree = true,
            disable = {},
          },
          autotag = {
            enable = true,
          }
        })
      '';
    }
  );
}
