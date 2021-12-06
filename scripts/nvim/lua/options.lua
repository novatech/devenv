local util = require "util"

-- leader key=<space>
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.did_load_filetypes = true -- do not source the default filetype.vim
vim.g.shell = "/bin/bash" -- default shell

-- themes
vim.o.background = "dark"
vim.cmd "silent! colorscheme dracula"
vim.opt.termguicolors = true -- enable true color support
vim.cmd "syntax on"

-- general config
vim.opt.compatible = false
vim.opt.encoding = "utf-8"
vim.opt.fileformats = "unix,mac,dos"
vim.opt.fileencoding = "utf-8"
vim.opt.fileencodings = "ucs-bom,utf-8,cp936,gb18030,big5,euc-jp,euc-kr,latin1"
vim.opt.cursorline = true -- show current line where the cursor is
vim.opt.mouse = "anic" -- enable mouse
vim.opt.clipboard = "unnamedplus" -- enable universal clipboard
vim.opt.lazyredraw = true -- usefull for regexes with large files
vim.opt.numberwidth = 2 -- two wide number column
vim.opt.shortmess:append "casI" -- disable intro
vim.opt.whichwrap:append "<>hl" -- clean aligned wraps
vim.opt.shortmess:append "S" -- do not show match count
vim.opt.backspace = "indent,eol,start" -- backspace over everything in insert mode

-- disable all unnecessarily files
vim.opt.backup = false
vim.opt.swapfile = false
vim.opt.writebackup = false
vim.opt.undofile = false

vim.opt.fillchars = {
   vert = "│",
   fold = " ",
   eob = " ",
   diff = "╱",
   msgsep = " ",
   foldopen = "▾",
   foldsep = "│",
   foldclose = "▸",
}

-- use list mode and customized listchars
vim.opt.list = true
vim.opt.listchars = { tab = "▸\\ ", extends = "❯", precedes = "❮", trail = "~", nbsp = "␣" }

vim.opt.pastetoggle = "<f2>" -- paste mode toggle
vim.opt.splitbelow = true
vim.opt.splitright = true -- split window below/right when creating horizontal/vertical windows
vim.opt.timeout = true -- enable timeout of key codes and mappings
vim.opt.timeoutlen = 500 -- timeout for key sequences
vim.opt.ttimeoutlen = 10 -- timeout for key sequences
vim.opt.updatetime = 500 -- for cursorhold events

-- general tab settings
vim.opt.expandtab = true -- expand tab to spaces
vim.opt.tabstop = 2 -- display tabs with width space
vim.opt.softtabstop = 2 -- number of spaces used
vim.opt.shiftwidth = 2 -- number of spaces for autoindent
vim.opt.ignorecase = true -- ignore case when searching
vim.opt.smartcase = true -- disable 'ignorecase' if search pattern has uppercase chars

-- set matching pairs of characters and highlight matching brackets
vim.opt.matchpairs = { "<:>", "「:」", "『:』", "【:】", "“:”", "‘:’", "《:》" }
vim.opt.number = true
vim.opt.relativenumber = true -- show line number and relative line number
vim.opt.linebreak = true -- break line at predefined characters
vim.opt.showbreak = "↪" -- character to show before the lines that have been soft-wrapped
vim.opt.scrolloff = 3 -- minimum lines to keep above and below cursor when scrolling
vim.opt.mousemodel = "popup" -- set the behaviour of mouse
vim.opt.showmode = false -- do not show mode on command line since vim-airline can show it
vim.opt.inccommand = "nosplit" -- show the result of substitution in real time for preview
vim.opt.confirm = true -- ask for confirmation when handling unsaved or read-only files
vim.opt.visualbell = true
vim.opt.errorbells = false -- do not use visual and errorbells
vim.opt.history = 500 -- the number of command and search history to keep
vim.opt.equalalways = false -- do not resize windows
vim.opt.autowrite = true -- auto-write the file based on some condition
vim.opt.undofile = false -- do not persistent undo even after you close a file and re-open it
vim.opt.completeopt = { "menuone", "noselect", "longest" } -- completion behaviour
vim.opt.complete = ".,w,b,u,t" -- h: 'complete'
vim.opt.pumheight = 0 -- maximum number of items to show in popup menu
vim.opt.pumblend = 0 -- pseudo transparency for completion menu
vim.opt.winblend = 5 -- pseudo transparency for floating window
vim.opt.spell = false -- do not enable spell check by default
vim.opt.spelllang = "en" -- spell languages
vim.opt.shiftround = true -- align indent to next multiple value of shiftwidth
vim.opt.virtualedit = "block" -- virtual edit is useful for visual block edit
vim.opt.formatoptions = "mMjcql"
vim.opt.tildeop = true -- tilde (~) is an operator, thus must be followed by motions like e or w
vim.opt.joinspaces = false -- do not add two spaces after a period when joining lines or formatting texts,
vim.opt.synmaxcol = 500 -- text after this column number is not highlighted
vim.opt.startofline = false
vim.opt.hidden = true
vim.opt.signcolumn = "auto:2"
vim.opt.isfname:remove "="
vim.opt.isfname:remove ","
vim.opt.diffopt = "vertical,filler,closeoff,context:3,internal,indent-heuristic,algorithm:histogram"
vim.opt.ruler = true -- add the column number
vim.opt.colorcolumn = { "80", "120" } -- add a bar on the side which delimits 80 and 120 characters
vim.opt.incsearch = true -- highlight matches while typing search pattern
vim.opt.hlsearch = true -- highlight previous search matches
vim.opt.showmatch = true -- briefly jump to the matching bracket on insert
vim.opt.matchtime = 2 -- time in decisecons to jump back from matching bracket
vim.opt.foldlevelstart = 99 -- fold start as open instead of closed
vim.opt.foldmethod = "marker" -- enable fold placed in comments
vim.opt.foldenable = false -- don't fold by default
vim.opt.foldnestmax = 0 -- maximum fold depth
vim.opt.fixendofline = false -- let the linter / formatter take care of additional line breaks and the end of the file

-- ignore certain files and folders when globing
vim.opt.wildmenu = true
vim.opt.wildmode = "longest:list:full"
vim.opt.wildignore:append "*.o,*.obj,*.dylib,*.bin,*.dll,*.exe"
vim.opt.wildignore:append "*/.git/*,*/.svn/*,*/__pycache__/*,*/build/**"
vim.opt.wildignore:append "*.jpg,*.png,*.jpeg,*.bmp,*.gif,*.tiff,*.svg,*.ico"
vim.opt.wildignore:append "*.pyc,*.pkl"
vim.opt.wildignore:append "*.DS_Store"
vim.opt.wildignore:append "*.aux,*.bbl,*.blg,*.brf,*.fls,*.fdb_latexmk,*.synctex.gz,*.xdv"
vim.opt.wildignorecase = true -- ignore file and dir name cases in cmd-completion

-- external program to use for grep command
if vim.fn.executable "rg" == 1 then
   vim.opt.grepprg = "rg --vimgrep --no-heading --smart-case"
   vim.opt.grepformat = "%f:%l:%c:%m"
end

-- neoformat
vim.g.neoformat_basic_format_align = true -- enable alignment
vim.g.neoformat_basic_format_retab = true -- enable tab to spaces conversion
vim.g.neoformat_basic_format_trim = true -- enable trimmming of trailing whitespace
vim.g.neoformat_only_msg_on_error = true -- only msg when there is an error
vim.g.shfmt_o = "-ci" -- switch case will be indent

-- airline
vim.g.airline_powerline_fonts = false -- do not enable the powerline fonts by default
vim.g.airline_skip_empty_sections = true -- no empty sections
vim.g["airline#extensions#tabline#enabled"] = true -- show the buffers at the top
vim.g["airline#extensions#tabline#buffer_nr_show"] = true -- show the buffer numbers
vim.g["airline#extensions#tabline#fnamemod"] = ":t" -- just filename and strip out other info
vim.g.airline_theme = "dracula"

-- vim-markdown
vim.g.vim_markdown_folding_disabled = true -- disable header folding
vim.g.vim_markdown_conceal = true -- whether to use conceal feature in markdown
vim.g.tex_conceal = "" -- disable math tex conceal and syntax highlight
vim.g.vim_markdown_math = false

-- support front matter of various format
vim.g.vim_markdown_frontmatter = true -- for YAML format
vim.g.vim_markdown_toml_frontmatter = true -- for TOML format
vim.g.vim_markdown_json_frontmatter = true -- for JSON format
vim.g.vim_markdown_toc_autofit = true -- let the toc window autofit so that it doesn't take too much space

-- markdown-preview
vim.g.mkdp_auto_close = false -- do not close the preview tab when switching to other buffers

-- editorconfig
vim.g.EditorConfig_exclude_patterns = { "fugitive://.*", "scp://.*" } -- skip certain file types
vim.g.EditorConfig_exec_path = "editorconfig" -- point to c implementation of editorconfig

-- UltiSnips
vim.g.UltiSnipsExpandTrigger = "<c-s>" -- trigger for UltiSnips
vim.g.UltiSnipsJumpForwardTrigger = "<c-b>" -- shortcut to go to next position
vim.g.UltiSnipsJumpBackwardTrigger = "<c-z>" -- shortcut to go to previous position
vim.g.UltiSnipsEditSplit = "vertical" -- use split windows for :UltiSnipsEdit

-- vimwiki
vim.g.vimwiki_list = { { path = "~/wiki/", syntax = "markdown", ext = ".md" } }

-- this will close the current buffer without closing the window
vim.cmd "command Bd bp|bd #"

-- keybindings
-- reselect visual block after indent/outdent
util.vmap("<", "<gv")
util.vmap(">", ">gv")

-- fzf
util.nmap("<c-p>", "<cmd>FZF<cr>")
vim.g.fzf_layout = { down = "~45%" }

-- vim-fugitive
util.nmap("<leader>gs", "<cmd>Git<cr>")
util.nmap("<leader>gw", "<cmd>Gwrite<cr>")
util.nmap("<leader>gc", "<cmd>Git commit<cr>")
util.nmap("<leader>gpl", "<cmd>Git pull<cr>")
util.nmap("<leader>gpu", "<cmd>15split | term git push<cr>")

util.au {
   group = "on_filetype",
   { "Filetype", "gitcommit", "setl colorcolumn=72" },
   { "Filetype", "markdown,html", "setl spell" },
}

util.au {
   group = "highlight_yank",
   { "TextYankPost", "*", 'silent! lua vim.highlight.on_yank{higroup="IncSearch", timeout=700}' },
}
