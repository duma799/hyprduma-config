-- Path for lazy.nvim plugin manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)
vim.cmd("set number")
require("vim-options")
-- Load pywal colors early
pcall(function() vim.cmd("source ~/.cache/wal/colors-wal.vim") end)
require("lazy").setup("plugins")
vim.opt.termguicolors = true
