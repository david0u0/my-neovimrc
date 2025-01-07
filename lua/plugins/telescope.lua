return {
  { "pbogut/fzf-mru.vim" },
  { 'nvim-telescope/telescope-fzf-native.nvim', build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release' },
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.8',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      telescope = require('telescope')
      telescope.setup()
      telescope.load_extension('fzf_mru')
      telescope.load_extension('fzf')
      vim.keymap.set('n', '<Leader>f', '<cmd>Telescope fzf_mru current_path<cr>')
      vim.keymap.set('n', '<Leader>j', '<cmd>Telescope marks<cr>')
      vim.keymap.set('n', '<Leader>b', '<cmd>Telescope buffers<cr>')
      vim.keymap.set('n', '<C-P>', '<cmd>Telescope find_files<cr>')
    end
  }
}
