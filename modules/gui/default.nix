{
  config,
  lib,
  ...
}:
with lib;
with builtins; let
  cfg = config.vim.gui;
in {
  options.vim.gui = {
    enable = mkEnableOption "Neovide gui";
  };

  config = mkIf (cfg.enable) {
    vim.luaConfigRC.gui = nvim.dag.entryAnywhere ''
       -- Neovide
      if vim.g.neovide then
        -- Neovide options
        vim.g.neovide_fullscreen = false
        vim.g.neovide_hide_mouse_when_typing = false
        vim.g.neovide_refresh_rate = 165
        vim.g.neovide_cursor_vfx_mode = "ripple"
        vim.g.neovide_cursor_animate_command_line = true
        vim.g.neovide_cursor_animate_in_insert_mode = true
        vim.g.neovide_cursor_vfx_particle_lifetime = 5.0
        vim.g.neovide_cursor_vfx_particle_density = 14.0
        vim.g.neovide_cursor_vfx_particle_speed = 12.0
        vim.g.neovide_transparency = 0.46

        -- Neovide Font
        vim.o.guifont = "JetBrainsMono Nerd Font:h10:Medium:i"
      end
      vim.keymap.set("t", "<ESC><ESC>", "<C-\\><C-n>", {desc = "Exit terminal mode"})
      vim.keymap.set("n", "<leader>tv", ":vsplit | terminal<CR>", {desc = "Open vertical split terminal"})
      vim.keymap.set("n", "<leader>th", ":split | terminal<CR>", {desc = "Open horizontal split terminal"})
    '';
  };
}
