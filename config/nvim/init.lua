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

-- expand tilde in a file path
local function expand_tilde(path)
    if path:sub(1, 1) == '~' then
        return os.getenv('HOME') .. path:sub(2)
    else
        return path
    end
end

-- Function to check if a file exists
local function file_exists(path)
    local f = io.open(path, "r")
    if f then
        f:close()
        return true
    else
        return false
    end
end

-- Path to the local machine-specific configuration file
local vimrc_local_path = expand_tilde("~/.local.lua")

-- Check if the file exists
if file_exists(vimrc_local_path) then
  dofile(vimrc_local_path)
end
