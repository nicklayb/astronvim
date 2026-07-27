return {
  "zbirenbaum/copilot.lua",
  cmd = "Copilot",
  build = ":Copilot auth",
  event = "BufReadPost",
  enabled = require("utils.features").enabled "copilot",
  opts = {
    copilot_node_command = vim.env.NODEJS_24 .. "/bin/node",
    suggestion = {
      auto_trigger = true,
      keymap = {
        accept = false, -- handled by completion engine
      },
    },
    status = {
      level = vim.log.levels.OFF,
    },
  },
  specs = {
    {
      "AstroNvim/astrocore",
      opts = {
        options = {
          g = {
            -- set the ai_accept function
            ai_accept = function()
              if require("copilot.suggestion").is_visible() then
                require("copilot.suggestion").accept()
                return true
              end
            end,
          },
        },
      },
    },
  },
}
