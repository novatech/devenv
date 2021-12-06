local M = {}

M.try_require = function(name)
   local ok, ret = pcall(require, name)
   if not ok then
      return nil
   end
   return ret
end

M.au = function(x)
   vim.cmd("augroup " .. x.group)
   for _, au in ipairs(x) do
      vim.cmd("au " .. au[1] .. " " .. au[2] .. " " .. au[3])
   end
   vim.cmd "augroup END"
end

M.map = function(mode, bind, action, opts)
   vim.api.nvim_set_keymap(mode, bind, action, opts or { noremap = true, silent = true })
end

M.nmap = function(bind, action, opts)
   M.map("n", bind, action, opts)
end

M.imap = function(bind, action, opts)
   M.map("i", bind, action, opts)
end

M.vmap = function(bind, action, opts)
   M.map("v", bind, action, opts)
end

M.cmap = function(bind, action, opts)
   M.map("c", bind, action, opts)
end

M.tmap = function(bind, action, opts)
   M.map("t", bind, action, opts)
end

function M.get(a, b)
   if not a == nil then
      return a
   else
      return b
   end
end
function M.setkeys(mode, mappings, buffer)
   local default_opts = { silent = true, noremap = true }

   buffer = buffer or false
   if buffer == true then
      buffer = 0
   end -- 0 is current buffer

   -- global mappings
   if buffer == false then
      local setkey = vim.api.nvim_set_keymap

      for _, mapping in ipairs(mappings) do
         local keys = mapping[1]
         local command = mapping[2]
         local opts = M.get(mapping[3], default_opts)
         setkey(mode, keys, command, opts)
      end

      -- buffer mappings
   else
      local setkey = vim.api.nvim_buf_set_keymap

      for _, mapping in ipairs(mappings) do
         local keys = mapping[1]
         local command = mapping[2]
         local opts = M.get(mapping[3], default_opts)
         setkey(buffer, mode, keys, command, opts)
      end
   end
end

return M
