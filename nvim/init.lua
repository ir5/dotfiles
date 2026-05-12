local fn = vim.fn
local opt = vim.opt

local lazypath = fn.stdpath("data") .. "/lazy/lazy.nvim"
local lazy_available = true
if not vim.uv.fs_stat(lazypath) then
  local clone_output = fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
  if vim.v.shell_error ~= 0 then
    lazy_available = false
    vim.notify("Failed to install lazy.nvim:\n" .. clone_output, vim.log.levels.WARN)
  end
end

if lazy_available then
  opt.rtp:prepend(lazypath)
  local lazy_ok, lazy = pcall(require, "lazy")
  if lazy_ok then
    lazy.setup({
      {
        "sainnhe/everforest",
        lazy = false,
        priority = 1000,
        init = function()
          opt.termguicolors = true
          opt.background = "dark"
          vim.g.everforest_background = "soft"
          vim.g.everforest_better_performance = 1
        end,
      },
      {
        "nvim-telescope/telescope.nvim",
        dependencies = {
          "nvim-lua/plenary.nvim",
          "nvim-telescope/telescope-file-browser.nvim",
        },
        cmd = "Telescope",
        keys = {
          { ",f", function() require("telescope").extensions.file_browser.file_browser({ path = fn.expand("%:p:h"), cwd = fn.expand("%:p:h") }) end, desc = "Browse files from current buffer dir" },
          { ",b", function() require("telescope.builtin").buffers() end, desc = "Find buffers" },
        },
        config = function()
          local fb_actions = require("telescope").extensions.file_browser.actions
          local action_state = require("telescope.actions.state")
          local action_set = require("telescope.actions.set")

          local function select_or_goto_home(prompt_bufnr)
            local prompt = action_state.get_current_line()
            if prompt == "~" or prompt == "~/" then
              fb_actions.goto_home_dir(prompt_bufnr)
              return
            end
            action_set.select(prompt_bufnr, "default")
          end

          require("telescope").setup({
            defaults = {
              sorting_strategy = "ascending",
              selection_strategy = "reset",
            },
            extensions = {
              file_browser = {
                grouped = true,
                hijack_netrw = true,
                hide_parent_dir = false,
                hidden = { file_browser = false, folder_browser = false },
                mappings = {
                  i = {
                    ["<CR>"] = select_or_goto_home,
                  },
                  n = {
                    ["<CR>"] = select_or_goto_home,
                  },
                },
              },
            },
          })
          require("telescope").load_extension("file_browser")
        end,
      },
      {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons", optional = true },
        event = "VeryLazy",
        config = function()
          require("lualine").setup({
            options = {
              theme = "everforest",
              globalstatus = false,
            },
            tabline = {
              lualine_a = {
                {
                  "tabs",
                  mode = 1,
                  max_length = vim.o.columns,
                  show_modified_status = false,
                  tabs_color = {
                    active = "TabLineSel",
                    inactive = "TabLine",
                  },
                  fmt = function(_, context)
                    local buflist = fn.tabpagebuflist(context.tabnr)
                    local winnr = fn.tabpagewinnr(context.tabnr)
                    local bufname = fn.fnamemodify(fn.bufname(buflist[winnr]), ":t")
                    return context.tabnr .. ": " .. (bufname == "" and "No name" or bufname)
                  end,
                },
              },
              lualine_b = {},
              lualine_c = {},
              lualine_x = {},
              lualine_y = {},
              lualine_z = {},
            },
          })
        end,
      },
    }, {
      checker = { enabled = false },
      lockfile = fn.stdpath("state") .. "/lazy-lock.json",
    })
  else
    vim.notify("lazy.nvim is not available", vim.log.levels.WARN)
  end
end

local function apply_colorscheme()
  if pcall(vim.cmd.colorscheme, "everforest") then
    return
  end
  if pcall(vim.cmd.colorscheme, "retrobox") then
    return
  end
  vim.cmd.colorscheme("default")
end

apply_colorscheme()

vim.diagnostic.config({
  float = {
    border = "rounded",
    source = true,
  },
  signs = true,
  underline = true,
  update_in_insert = false,
  virtual_lines = false,
  virtual_text = { source = "if_many", prefix = ">" },
})

if vim.lsp and vim.lsp.config then
  vim.lsp.config.ruff = {
    cmd = { "ruff", "server" },
    filetypes = { "python" },
    root_markers = { "pyproject.toml", "ruff.toml", ".ruff.toml", ".git" },
  }

  vim.lsp.config.clangd = {
    cmd = {
      "clangd",
      "--fallback-style=none",
      "--query-driver=/usr/bin/g++,/usr/bin/clang++",
    },
    init_options = {
      fallbackFlags = {
        "-std=c++20",
        "-Wall",
        "-Wextra",
        "-pedantic",
        "-Wno-unused-variable",
        "-I/home/mkusumoto/ac-library",
      },
    },
    filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
    root_markers = { ".clangd", "compile_commands.json", "compile_flags.txt", ".git" },
  }

  if vim.lsp.enable then
    vim.lsp.enable("ruff")
    vim.lsp.enable("clangd")
  end
end

opt.encoding = "utf-8"

opt.ignorecase = true
opt.smartcase = true

opt.shiftwidth = 2
opt.expandtab = true
opt.smarttab = true
opt.autoindent = true
opt.cindent = true
opt.backspace = { "indent", "eol", "start" }
opt.wrapscan = true
opt.showmatch = true
opt.wildmenu = true
opt.formatoptions:append({ m = true, M = true })
opt.formatoptions:remove({ "r", "o" })

vim.cmd("syntax on")
opt.number = true
opt.ruler = true
opt.list = false
opt.wrap = true
opt.laststatus = 2
opt.cmdheight = 1
opt.showcmd = true
opt.title = false
opt.scrolloff = 5
opt.guicursor = "n-v-c-sm:block,i-ci-ve:block,r-cr-o:block"
opt.mouse = ""

local backupdir = fn.expand("~/.vimbackup")
if fn.isdirectory(backupdir) == 0 then
  pcall(fn.mkdir, backupdir, "p")
end
opt.backup = false
opt.writebackup = false
opt.backupdir = backupdir .. "//"
opt.directory = backupdir .. "//"

opt.hidden = true
opt.hlsearch = true
opt.ttyfast = true
opt.showtabline = 2

vim.g.python_highlight_all = 1
vim.g.airline_powerline_fonts = 1

local map = vim.keymap.set
local silent = { silent = true }

map("n", "<C-h>", "h", silent)
map("n", "<C-l>", "l", silent)
map("n", ",vp", ":r! cat -\r", silent)

map("n", "j", "gj", silent)
map("n", "k", "gk", silent)
map("v", "j", "gj", silent)
map("v", "k", "gk", silent)

map("n", "<Tab>n", "<Cmd>tabnext<CR>", silent)
map("n", "<Tab>p", "<Cmd>tabprevious<CR>", silent)
map("n", "<Tab>c", "<Cmd>tabnew<CR><Cmd>tabmove<CR>", silent)
map("n", "<Tab>K", "<Cmd>tabclose<CR>", silent)
map("n", "<Tab>0", "<Cmd>tabfirst<CR>", silent)
map("n", "<Tab>$", "<Cmd>tablast<CR>", silent)
for i = 0, 9 do
  map("n", "<Tab>m" .. i, "<Cmd>tabmove " .. i .. "<CR>", silent)
end
for i = 1, 9 do
  map("n", "<Tab>" .. i, i .. "gt", silent)
end
map("n", "<Tab>0", "10gt", silent)
map("n", ",eeuc", "<Cmd>edit ++enc=eucJP<CR>", silent)
map("n", ",eutf", "<Cmd>edit ++enc=utf-8<CR>", silent)
map("n", "B", "<Cmd>cd %:h<CR>", silent)

local augroup = vim.api.nvim_create_augroup("dotfiles_nvim", { clear = true })

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  group = augroup,
  pattern = { "*.py", "*.pyx" },
  callback = function()
    vim.fn.matchadd("BadWhitespace", [[\s\+$]])
  end,
})

vim.api.nvim_create_autocmd({ "BufEnter" }, {
  group = augroup,
  pattern = { "*.py", "*.pyx" },
  callback = function()
    local opt_local = vim.opt_local
    opt_local.smartindent = false
    opt_local.cindent = false
    opt_local.shiftwidth = 4
    opt_local.indentkeys:append("0#")
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = augroup,
  pattern = { "c", "cc", "cpp" },
  callback = function()
    vim.opt_local.formatoptions:remove({ "r", "o" })
  end,
})

vim.api.nvim_set_hl(0, "BadWhitespace", { ctermbg = "red", bg = "darkred" })

vim.api.nvim_create_user_command("CC", function(opts)
  local name = opts.args
  local filename = name .. ".cc"

  if fn.filereadable(filename) == 1 then
    vim.api.nvim_err_writeln("File " .. filename .. " already exists!")
    return
  end

  vim.cmd.edit(fn.fnameescape(filename))
  vim.cmd("0read " .. fn.fnameescape(fn.expand("~/alglib/template.h")))

  if fn.getline("$") == "" then
    vim.cmd("$delete")
  end

  vim.cmd.write()
  vim.cmd.normal({ "gg", bang = true })
end, {
  nargs = 1,
})
