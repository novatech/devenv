local util = require "util"

-- disable builtin plugins
local disabled_built_ins = {
   "2html_plugin",
   "getscript",
   "getscriptPlugin",
   "gzip",
   "logipat",
   "netrw",
   "netrwPlugin",
   "netrwSettings",
   "netrwFileHandlers",
   "matchit",
   "tar",
   "tarPlugin",
   "rrhelper",
   "spellfile_plugin",
   "vimball",
   "vimballPlugin",
   "zip",
   "zipPlugin",
}

for _, plugin in pairs(disabled_built_ins) do
   vim.g["loaded_" .. plugin] = 1
end

-- web devicons
local web_devicons = util.try_require "nvim-web-devicons"
if web_devicons then
   web_devicons.setup()
end

-- lsp_signature
local lspsignature = util.try_require "lsp_signature"
if lspsignature then
   lspsignature.setup {
      bind = true,
      doc_lines = 2,
      floating_window = true,
      fix_pos = true,
      hint_enable = true,
      hint_prefix = " ",
      hint_scheme = "String",
      hi_parameter = "Search",
      max_height = 22,
      max_width = 120, -- max_width of signature floating_window, line will be wrapped if exceed max_width
      handler_opts = {
         border = "single", -- double, single, shadow, none
      },
      zindex = 200, -- by default it will be on top of all floating windows, set to 50 send it to bottom
      padding = "", -- character to pad on left and right of signature can be ' ', or '|'  etc
   }
end

-- nvim tree file browser
local nvim_tree = util.try_require "nvim-tree"
if nvim_tree then
   vim.o.termguicolors = true
   vim.g.nvim_tree_add_trailing = 0 -- append a trailing slash to folder names
   vim.g.nvim_tree_highlight_opened_files = 0
   vim.g.nvim_tree_indent_markers = 1
   vim.g.nvim_tree_quit_on_open = 0 -- closes tree when file's opened
   vim.g.nvim_tree_root_folder_modifier = table.concat { ":t:gs?$?/..", string.rep(" ", 1000), "?:gs?^??" }

   vim.g.nvim_tree_show_icons = {
      folders = 1,
      files = 1,
   }

   vim.g.nvim_tree_icons = {
      default = "",
      symlink = "",
      git = {
         deleted = "",
         ignored = "◌",
         renamed = "➜",
         staged = "✓",
         unmered = "",
         unstaged = "✗",
         untracked = "★",
      },
      folder = {
         default = "",
         empty = "", -- 
         empty_open = "",
         open = "",
         symlink = "",
         symlink_open = "",
      },
   }

   vim.cmd [[nnoremap <f12> :NvimTreeToggle<cr>]]

   nvim_tree.setup {
      filters = {
         dotfiles = false,
         custom = { "*.tmp", ".git", "node_modules", ".cache" },
      },
      disable_netrw = true,
      hijack_netrw = true,
      open_on_setup = true,
      ignore_ft_on_setup = { "dashboard" },
      auto_close = true,
      open_on_tab = false,
      hijack_cursor = true,
      update_cwd = true,
      update_focused_file = {
         enable = true,
         update_cwd = true,
         ignore_list = {},
      },
      view = {
         side = "left",
         width = 25,
         allow_resize = true,
         mappings = { custom_only = false, list = {} },
      },
   }
end

-- neoscroll --
local neoscroll = util.try_require "neoscroll"
if neoscroll then
   local neoscroll_settings = util.try_require "neoscroll.config"
   if neoscroll_settings then
      neoscroll_settings.set_mappings {
         -- use the "sine" easing function
         ["<C-u>"] = { "scroll", { "-vim.wo.scroll", "true", "350", [['sine']] } },
         ["<C-d>"] = { "scroll", { "vim.wo.scroll", "true", "350", [['sine']] } },
         -- use the "circular" easing function
         ["<C-b>"] = { "scroll", { "-vim.api.nvim_win_get_height(0)", "true", "500", [['circular']] } },
         ["<C-f>"] = { "scroll", { "vim.api.nvim_win_get_height(0)", "true", "500", [['circular']] } },
         -- pass "nil" to disable the easing animation (constant scrolling speed)
         ["<C-y>"] = { "scroll", { "-0.10", "false", "100", nil } },
         ["<C-e>"] = { "scroll", { "0.10", "false", "100", nil } },
         -- when no easing function is provided the default easing function (in this case "quadratic") will be used
         ["zt"] = { "zt", { "300" } },
         ["zz"] = { "zz", { "300" } },
         ["zb"] = { "zb", { "300" } },
      }
   end
   neoscroll.setup {
      easing_function = "quadratic",
      hide_cursor = true, -- Hide cursor while scrolling
      stop_eof = true, -- Stop at <EOF> when scrolling downwards
      use_local_scrolloff = false, -- Use the local scope of scrolloff instead of the global scope
      respect_scrolloff = false, -- Stop scrolling when the cursor reaches the scrolloff margin of the file
      cursor_scrolls_alone = true, -- The cursor will keep on scrolling even if the window cannot scroll further
      pre_hook = nil, -- Function to run before the scrolling animation starts
      post_hook = nil, -- Function to run after the scrolling animation ends
   }
end

-- indent blankline
local indent_blankline = util.try_require "indent_blankline"
if indent_blankline then
   vim.opt.termguicolors = true
   indent_blankline.setup {
      show_trailing_blankline_indent = false,
      show_first_indent_level = false,
      show_current_context = true,
      show_current_context_start = true,
      context_patterns = {
         "class",
         "return",
         "function",
         "method",
         "^if",
         "^while",
         "jsx_element",
         "^for",
         "^object",
         "^table",
         "block",
         "arguments",
         "if_statement",
         "else_clause",
         "jsx_element",
         "jsx_self_closing_element",
         "try_statement",
         "catch_clause",
         "import_statement",
         "operation_type",
      },
      buftype_exclude = { "terminal" },
      filetype_exclude = {
         "help",
         "terminal",
         "dashboard",
         "NvimTree",
         "lspinfo",
         "git",
         "gitconfig",
         "markdown",
         "snippets",
         "text",
      },
   }
end

-- treesitter --
local treesitter = util.try_require "nvim-treesitter"
if treesitter then
   local treesitter_configs = util.try_require "nvim-treesitter.configs"
   if treesitter_configs then
      treesitter_configs.setup {
         sync_install = true,
         ensure_installed = {},
         ignore_install = {},
         highlight = {
            enable = true,
            disable = { "org" },
            additional_vim_regex_hightlighting = { "org" },
         },
         rainbow = {
            enable = true,
            -- disable = { "jsx", "cpp" }, list of languages you want to disable the plugin for
            extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
            max_file_lines = nil, -- Do not enable for files with more than n lines, int
            -- colors = {}, -- table of hex strings
            -- termcolors = {} -- table of colour name strings
         },
         autotag = {
            enable = true,
            filetypes = { "html", "xml" },
         },
         playground = {
            enable = true,
            disable = {},
            updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
            persist_queries = false, -- Whether the query persists across vim sessions
            keybindings = {
               toggle_query_editor = "o",
               toggle_hl_groups = "i",
               toggle_injected_languages = "t",
               toggle_anonymous_nodes = "a",
               toggle_language_display = "I",
               focus_language = "f",
               unfocus_language = "F",
               update = "R",
               goto_node = "<cr>",
               show_help = "?",
            },
         },
      }
   end
end

-- bufferline
local bufferline = util.try_require "bufferline"
if bufferline then
   local colors = {
      bg = "NONE",
      black = "#242730",
      black2 = "#2a2e38",
      white = "#bbc2cf",
      fg = "#bbc2cf",
      yellow = "#FCCE7B",
      cyan = "#4db5bd",
      darkblue = "#51afef",
      green = "#7bc275",
      orange = "#e69055",
      purple = "#C57BDB",
      magenta = "#C57BDB",
      gray = "#62686E",
      blue = "#51afef",
      red = "#ff665c",
   }

   bufferline.setup {
      options = {
         offsets = {
            {
               filetype = "NvimTree",
               text = "File Explorer",
               highlight = "Directory",
               text_align = "center",
               padding = 1,
            },
         },
         buffer_close_icon = "",
         modified_icon = "",
         close_icon = "λ",
         show_close_icon = true,
         left_trunc_marker = "",
         right_trunc_marker = "",
         max_name_length = 14,
         max_prefix_length = 13,
         tab_size = 20,
         show_tab_indicators = true,
         enforce_regular_tabs = false,
         view = "multiwindow",
         show_buffer_close_icons = true,
         separator_style = "thin",
         always_show_bufferline = false,
         diagnostics = false, -- "or nvim_lsp"
         custom_filter = function(buf_number)
            -- Func to filter out our managed/persistent split terms
            local present_type, type = pcall(function()
               return vim.api.nvim_buf_get_var(buf_number, "term_type")
            end)

            if present_type then
               if type == "vert" then
                  return false
               elseif type == "hori" then
                  return false
               else
                  return true
               end
            else
               return true
            end
         end,
      },

      highlights = {
         background = {
            guifg = colors.fg,
            guibg = colors.black2,
         },

         -- buffers
         buffer_selected = {
            guifg = colors.white,
            guibg = colors.black,
            gui = "bold",
         },
         buffer_visible = {
            guifg = colors.gray,
            guibg = colors.black2,
         },

         -- for diagnostics = "nvim_lsp"
         error = {
            guifg = colors.gray,
            guibg = colors.black2,
         },
         error_diagnostic = {
            guifg = colors.gray,
            guibg = colors.black2,
         },

         -- close buttons
         close_button = {
            guifg = colors.gray,
            guibg = colors.black2,
         },
         close_button_visible = {
            guifg = colors.gray,
            guibg = colors.black2,
         },
         close_button_selected = {
            guifg = colors.red,
            guibg = colors.black,
         },
         fill = {
            guifg = colors.fg,
            guibg = colors.black2,
         },
         indicator_selected = {
            guifg = colors.black,
            guibg = colors.black,
         },

         -- modified
         modified = {
            guifg = colors.red,
            guibg = colors.black2,
         },
         modified_visible = {
            guifg = colors.red,
            guibg = colors.black2,
         },
         modified_selected = {
            guifg = colors.green,
            guibg = colors.black,
         },

         -- separators
         separator = {
            guifg = colors.black2,
            guibg = colors.black2,
         },
         separator_visible = {
            guifg = colors.black2,
            guibg = colors.black2,
         },
         separator_selected = {
            guifg = colors.black2,
            guibg = colors.black2,
         },
         -- tabs
         tab = {
            guifg = colors.gray,
            guibg = colors.black2,
         },
         tab_selected = {
            guifg = colors.black2,
            guibg = colors.darkblue,
         },
         tab_close = {
            guifg = colors.red,
            guibg = colors.black,
         },
      },
   }
end

local gitsigns = util.try_require "gitsigns"
if gitsigns then
   gitsigns.setup {
      debug_mode = false,
      signs = {
         add = { hl = "GitSignsAdd", text = "┃", numhl = "GitSignsAddNr", linehl = "GitSignsAddLn" },
         change = { hl = "GitSignsChange", text = "┃", numhl = "GitSignsChangeNr", linehl = "GitSignsChangeLn" },
         delete = { hl = "GitSignsDelete", text = "▁", numhl = "GitSignsDeleteNr", linehl = "GitSignsDeleteLn" },
         topdelete = { hl = "GitSignsDelete", text = "▔", numhl = "GitSignsDeleteNr", linehl = "GitSignsDeleteLn" },
         changedelete = { hl = "GitSignsChange", text = "~", numhl = "GitSignsChangeNr", linehl = "GitSignsChangeLn" },
      },
      signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
      numhl = false, -- Toggle with `:Gitsigns toggle_numhl`
      linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
      word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
      keymaps = {
         -- Default keymap options
         noremap = true,
         ["n ]c"] = { expr = true, "&diff ? ']c' : '<cmd>lua require\"gitsigns.actions\".next_hunk()<CR>'" },
         ["n [c"] = { expr = true, "&diff ? '[c' : '<cmd>lua require\"gitsigns.actions\".prev_hunk()<CR>'" },
         ["n <leader>hs"] = '<cmd>lua require"gitsigns".stage_hunk()<CR>',
         ["v <leader>hs"] = '<cmd>lua require"gitsigns".stage_hunk({vim.fn.line("."), vim.fn.line("v")})<CR>',
         ["n <leader>hu"] = '<cmd>lua require"gitsigns".undo_stage_hunk()<CR>',
         ["n <leader>hr"] = '<cmd>lua require"gitsigns".reset_hunk()<CR>',
         ["v <leader>hr"] = '<cmd>lua require"gitsigns".reset_hunk({vim.fn.line("."), vim.fn.line("v")})<CR>',
         ["n <leader>hR"] = '<cmd>lua require"gitsigns".reset_buffer()<CR>',
         ["n <leader>hp"] = '<cmd>lua require"gitsigns".preview_hunk()<CR>',
         ["n <leader>hb"] = '<cmd>lua require"gitsigns".blame_line(true)<CR>',
         ["n <leader>hS"] = '<cmd>lua require"gitsigns".stage_buffer()<CR>',
         ["n <leader>hU"] = '<cmd>lua require"gitsigns".reset_buffer_index()<CR>',

         -- Text objects
         ["o ih"] = ':<C-U>lua require"gitsigns.actions".select_hunk()<CR>',
         ["x ih"] = ':<C-U>lua require"gitsigns.actions".select_hunk()<CR>',
      },
      watch_gitdir = { interval = 1000 },
      sign_priority = 6,
      update_debounce = 200,
      status_formatter = nil,
   }
end

local which_key = util.try_require "which-key"
if which_key then
   which_key.setup {}
end

local trouble = util.try_require "trouble"
if trouble then
   trouble.setup {}
end

local lsp_colors = util.try_require "lsp-colors"
if lsp_colors then
   lsp_colors.setup {
      Error = "#db4b4b",
      Warning = "#e0af68",
      Information = "#0db9d7",
      Hint = "#10B981",
   }
end

local nvim_comment = util.try_require "nvim_comment"
if nvim_comment then
   nvim_comment.setup { comment_empty = false }
end
