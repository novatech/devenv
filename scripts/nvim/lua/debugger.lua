local util = require "util"

local values = function(dict)
   local gen, state, k, v = pairs(dict)
   return function()
      k, v = gen(state, k, v)
      if v ~= nil then
         return v
      end
   end
end

local dap = util.try_require "dap"
local dapui = util.try_require "dapui"
if dap and dapui then
   dap.set_log_level "DEBUG"
   local setups = {
      python = function()
         local dap_python = require "dap-python"
         dap_python.setup("/usr/bin/python", { include_configs = false })
         dap_python.test_runner = "pytest"

         dap.configurations.python = dap.configurations.python or {}
         table.insert(dap.configurations.python, {
            type = "python",
            request = "launch",
            name = "Launch file",
            justMyCode = false,
            program = "${file}",
            console = "internalConsole",
         })
         table.insert(dap.configurations.python, {
            type = "python",
            request = "attach",
            name = "Attach remote",
            justMyCode = false,
            host = function()
               local value = vim.fn.input "Host [127.0.0.1]: "
               if value ~= "" then
                  return value
               end
               return "127.0.0.1"
            end,
            port = function()
               return tonumber(vim.fn.input "Port [5678]: ") or 5678
            end,
         })
      end,
   }

   dapui.setup()
   for setup in values(setups) do
      setup()
   end

   local _config = {
      mappings = {
         { "<F5>", "<cmd>lua require('dap').continue()<cr>" },
         { "<F8>", "<cmd>lua require'dap'.step_out()<cr>" },
         { "<F9>", "<cmd>lua require'dap'.step_back()<cr>" },
         { "<F10>", "<cmd>lua require'dap'.step_into()<cr>" },
         { "<F11>", "<cmd>lua require'dap'.step_over()<cr>" },
         { "<leader>dv", "<cmd>lua require('dapui').toggle()<cr>" },
         { "<leader>db", "<cmd>lua require('dap').toggle_breakpoint()<cr>" },
         { "<leader>dc", "<cmd>lua require('dap').continue()<cr>" },
         { "<leader>de", "<cmd>lua require('dap.ui.widgets').hover()<cr>" },
      },
      sidebar = {
         winopts = { width = 100 },
      },
   }

   if _config.mappings then
      util.setkeys("n", _config.mappings)
   end
end
