local options = {
  encoding = 'utf-8',

  clipboard = 'unnamedplus', -- TODO: 삭제할거다.
  number = true,
  relativenumber = true,

  tabstop = 2,
  shiftwidth = 2,
  expandtab = true,
  softtabstop = 2,

  hlsearch = true,
  incsearch = true,
  ignorecase = true,
  smartcase = true,

  autoread = true,

  hidden = true,

  scrolloff = 8,

  showcmd = true,
  wildmenu = true,
  showmode = true,
  background = 'dark',

  history = 9999,
  backup = false,
  swapfile = false,
  undodir = '~/.cache/nvim/undo//',
  undofile = true,

  listchars = { tab = '→\\' , trail = '-', eol = '↲', extends = '»', precedes = '«', nbsp = '%', space = '·' },
  showbreak = '↪',
  list = true,

  updatetime = 100
}

for k, v in pairs(options) do
  vim.opt[k] = v
end

local gs = {
  netrw_banner = false,
  vim_json_conceal = false
}

for k, v in pairs(gs) do
  vim.g[k] = v
end

