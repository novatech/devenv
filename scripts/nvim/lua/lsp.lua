local util = require "util"

local cmp = util.try_require "cmp"
local lspkind = util.try_require "lspkind"

if cmp == nil or lspkind == nil then
   return
end

vim.opt.completeopt = "menu,menuone,noselect"

cmp.setup {
   snippet = {
      expand = function(args)
         vim.fn["UltiSnips#Anon"](args.body)
      end,
   },
   mapping = {
      ["<tab>"] = cmp.mapping(function(fallback)
         if cmp.visible() then
            local entry = cmp.get_selected_entry()
            if not entry then
               cmp.select_next_item { behavior = cmp.SelectBehavior.Select }
            end
            cmp.confirm()
         else
            fallback()
         end
      end, { "i" }),
      ["<esc>"] = cmp.mapping.close(),
      ["<cr>"] = cmp.mapping.confirm { select = true },
   },
   sources = cmp.config.sources {
      { name = "nvim_lsp" },
      { name = "ultisnip" },
      { name = "nvim_lua" },
      { name = "path" },
      { name = "buffer", keyword_length = 4 },
      { name = "emoji", insert = true },
      { name = "cmdline" },
      { name = "treesitter" },
      {
         name = "buffer",
         get_bufnrs = function()
            local buf_map = {}
            for _, winid in ipairs(vim.api.nvim_list_wins()) do
               buf_map[vim.api.nvim_win_get_buf(winid)] = true
            end
            return vim.tbl_keys(buf_map)
         end,
      },
   },
   completion = { keyword_length = 1, completeopt = "menu,noselect" },
   experimental = { ghost_text = false },
   formatting = {
      format = lspkind.cmp_format {
         with_text = true,
         menu = {
            nvim_lsp = "[LSP]",
            ultisnip = "[US]",
            nvim_lua = "[Lua]",
            path = "[Path]",
            buffer = "[Buffer]",
            emoji = "[Emoji]",
            treesitter = "[TS]",
         },
      },
   },
}
-- use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline("/", { sources = { { name = "buffer" } } })

-- use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(":", { sources = cmp.config.sources({ { name = "path" } }, { { name = "cmdline" } }) })

local nvim_autopairs = util.try_require "nvim-autopairs"
if nvim_autopairs then
   nvim_autopairs.setup {
      disable_filetype = { "" },
      break_line_filetype = nil,
      check_ts = true,
      html_break_line_filetype = { "html", "typescriptreact", "javascriptreact" },
      ignored_next_char = "[%w%%%'%[%\"%.]",
      enable_check_bracket_line = true,
   }
   local cmp_autopairs = require "nvim-autopairs.completion.cmp"
   cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
end

-- setup lspconfig
-- keymaps
local on_attach = function(client, bufnr)
   local function buf_set_keymap(...)
      vim.api.nvim_buf_set_keymap(bufnr, ...)
   end
   local function buf_set_option(...)
      vim.api.nvim_buf_set_option(bufnr, ...)
   end

   buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")

   -- Mappings.
   local opts = { noremap = true, silent = true }
   buf_set_keymap("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", opts)
   buf_set_keymap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", opts)
   buf_set_keymap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>", opts)
   buf_set_keymap("n", "gr", "<cmd>lua vim.lsp.buf.references()<cr>", opts)
   buf_set_keymap("n", "<c-k>", "<cmd>lua vim.lsp.buf.signature_help()<cr>", opts)
   buf_set_keymap("n", "[d", "<cmd>lua vim.lsp.diagnostic.goto_prev()<cr>", opts)
   buf_set_keymap("n", "]d", "<cmd>lua vim.lsp.diagnostic.goto_next()<cr>", opts)
   buf_set_keymap("n", "<leader>a", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)
   buf_set_keymap("n", "<leader>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<cr>", opts)
   buf_set_keymap("n", "<leader>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<cr>", opts)
   buf_set_keymap("n", "<leader>wl", "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<cr>", opts)
   buf_set_keymap("n", "<leader>D", "<cmd>lua vim.lsp.buf.type_definition()<cr>", opts)
   buf_set_keymap("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<cr>", opts)
   buf_set_keymap("n", "<leader>e", "<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<cr>", opts)
   buf_set_keymap("n", "<leader>q", "<cmd>lua vim.lsp.diagnostic.set_loclist()<cr>", opts)
   buf_set_keymap("n", "<leader>P", "<cmd>lua vim.lsp.buf.formatting()<cr>", opts)
   buf_set_keymap("v", "<leader>p", "<cmd>lua vim.lsp.buf.range_formatting()<cr>", opts)
   buf_set_keymap("n", "<leader>l", "<cmd>lua vim.lsp.codelens.run()<cr>", opts)

   -- vim already has builtin docs
   if vim.bo.ft ~= "vim" then
      buf_set_keymap("n", "k", "<cmd>lua vim.lsp.buf.hover()<cr>", opts)
   end

   if client.resolved_capabilities.document_formatting then
      buf_set_keymap("n", "<leader>f", "<cmd>lua vim.lsp.buf.formatting()<cr>", opts)
   end
   if client.resolved_capabilities.document_range_formatting then
      buf_set_keymap("x", "<leader>fr", "<cmd>lua vim.lsp.buf.range_formatting()<cr><esc>", opts)
   end
   -- Set autocommands conditional on server_capabilities
   if client.resolved_capabilities.document_highlight then
      vim.cmd [[
      hi link LspReferenceRead Visual
      hi link LspReferenceText Visual
      hi link LspReferenceWrite Visual
      augroup lsp_document_highlight
        autocmd! * <buffer>
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      augroup END
    ]]
   end

   if client.resolved_capabilities.code_lens then
      vim.cmd [[
      augroup lsp_codelens
        autocmd! * <buffer>
        autocmd BufEnter,CursorHold,InsertLeave <buffer> lua vim.lsp.codelens.refresh()
      augroup END
    ]]
   end

   if client.server_capabilities.colorProvider then
      require("lsp-documentcolors").buf_attach(bufnr, { single_column = true })
   end
end

-- config that activates keymaps and enables snippet support
local lspconfig_util = require "lspconfig/util"
local function get_lsp_config(server)
   local capabilities = vim.lsp.protocol.make_client_capabilities()
   capabilities.textDocument.colorProvider = { dynamicRegistration = false }
   capabilities.textDocument.completion.completionItem.snippetSupport = true
   capabilities.textDocument.completion.completionItem.documentationFormat = { "markdown", "plaintext" }
   capabilities.textDocument.completion.completionItem.preselectSupport = true
   capabilities.textDocument.completion.completionItem.insertReplaceSupport = true
   capabilities.textDocument.completion.completionItem.labelDetailsSupport = true
   capabilities.textDocument.completion.completionItem.deprecatedSupport = true
   capabilities.textDocument.completion.completionItem.commitCharactersSupport = true
   capabilities.textDocument.completion.completionItem.tagSupport = { valueSet = { 1 } }
   capabilities.textDocument.completion.completionItem.resolveSupport = {
      properties = {
         "documentation",
         "detail",
         "additionalTextEdits",
      },
   }
   capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)

   local config = {
      capabilities = capabilities,
      on_attach = on_attach,
      root_dir = function(_)
         return vim.loop.cwd()
      end,
      flags = { debounce_text_changes = 200 },
   }
   if server.name == "clangd" then
      config.root_dir = function(fname)
         return lspconfig_util.root_pattern("compile_commands.json", "compile_flags.txt", ".git")(fname)
            or lspconfig_util.path.dirname(fname)
      end
   end
   if server.name == "sumneko_lua" then
      config.settings = {
         Lua = {
            runtime = {
               version = "LuaJIT",
               path = vim.split(package.path, ";"),
            },
            completion = { enable = true, callSnippet = "Both" },
            diagnostics = {
               enable = true,
               globals = { "vim" },
            },
            workspace = {
               library = {
                  [vim.fn.expand "$VIMRUNTIME/lua"] = true,
                  [vim.fn.expand "$VIMRUNTIME/lua/vim/lsp"] = true,
               },
               maxPreload = 4000,
               preloadFileSize = 4000,
               checkThirdParty = false,
            },
         },
      }
      config.root_dir = function()
         return vim.loop.cwd()
      end
   end
   if server.name == "vim" then
      config.init_options = { isNeovim = true }
   end
   if server.name == "jsonls" then
      config.commands = {
         Format = {
            function()
               vim.lsp.buf.range_formatting({}, { 0, 0 }, { vim.fn.line "$", 0 })
            end,
         },
      }
   end
   if server.name == "pylsp" then
      config.settings = {
         pylsp = {
            configurationSources = { "flake8" },
            plugins = {
               flake8 = { enabled = true },
               pylint = { enabled = true },
               pyflakes = { enabled = false },
               pycodestyle = { enabled = false },
               --jedi_completion = { fuzzy = true },
               --pyls_isort = { enabled = true },
               --pylsp_mypy = { enabled = true },
            },
         },
      }
   end
   return config
end

-- setup servers installed with nvim-lsp-installer
require("nvim-lsp-installer").on_server_ready(function(server)
   server:setup(get_lsp_config(server))
end)

-- replace the default lsp diagnostic symbols
local signs = { Error = " ", Warning = " ", Hint = " ", Information = " " }
for type, icon in pairs(signs) do
   local hl = "LspDiagnosticsSign" .. type
   vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

-- show diagnostics
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
   signs = true,
   underline = false,
   update_in_insert = false,
   virtual_text = { prefix = "●", spacing = 0 },
})
-- alternative to virtual_text is to have diagnostic in hover windows
-- when focus on error line. uncomment below and set virtual_text = false
-- else just disable both and use <leader>e shortcut
-- vim.cmd [[autocmd CursorHold,CursorHoldI * lua vim.lsp.diagnostic.show_line_diagnostics({focusable=false})]]

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "single" })
vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "single" })
vim.api.nvim_command "highlight default link LspCodeLens Comment"

-- suppress error messages from lang servers
vim.notify = function(msg, log_level)
   if msg:match "exit code" then
      return
   end
   if log_level == vim.log.levels.ERROR then
      vim.api.nvim_err_writeln(msg)
   else
      vim.api.nvim_echo({ { msg } }, true, {})
   end
end
