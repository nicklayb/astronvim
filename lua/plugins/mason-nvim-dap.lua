return {
  "jay-babu/mason-nvim-dap.nvim",
  opts = {
    handlers = {
      elixir = function(source_name)
        local dap = require('dap')
        local elixir_ls_debugger = vim.fn.exepath "elixir-ls-debugger"
        dap.adapters.mix_task = {
          type = "executable",
          command = elixir_ls_debugger,
        }

        dap.configurations.elixir = {
          {
            type = "mix_task",
            name = "phoenix server",
            task = "phx.server",
            request = "launch",
            projectDir = "${workspaceFolder}",
            exitAfterTaskReturns = false,
            debugAutoInterpretAllModules = false,
          }
        }
      end
    }
  }
}
