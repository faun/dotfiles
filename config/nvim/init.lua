local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
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

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

require("config.lazy")
require("config.defaults")

local init_lua_path = vim.fn.stdpath("config") .. "/local.lua"
if vim.fn.filereadable(init_lua_path) == 1 then
  dofile(init_lua_path)
end
