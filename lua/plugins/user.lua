-- You can also add or configure plugins by creating files in this `plugins/` folder
-- PLEASE REMOVE THE EXAMPLES YOU HAVE NO INTEREST IN BEFORE ENABLING THIS FILE
-- Here are some examples:

---@type LazySpec
return {
  {
    "windwp/nvim-autopairs",
    config = function(plugin, opts)
      require "astronvim.plugins.configs.nvim-autopairs"(plugin, opts) -- include the default astronvim config that calls the setup call
      -- add more custom autopairs configuration such as custom rules
      local npairs = require "nvim-autopairs"
      local Rule = require "nvim-autopairs.rule"
      local cond = require "nvim-autopairs.conds"
      npairs.add_rules(
        {
          Rule("$", "$", { "tex", "latex" })
            -- don't add a pair if the next character is %
            :with_pair(cond.not_after_regex "%%")
            -- don't add a pair if  the previous character is xxx
            :with_pair(
              cond.not_before_regex("xxx", 3)
            )
            -- don't move right when repeat character
            :with_move(cond.none())
            -- don't delete if the next character is xx
            :with_del(cond.not_after_regex "xx")
            -- disable adding a newline when you press <cr>
            :with_cr(cond.none()),
        },
        -- disable for .vim files, but it work for another filetypes
        Rule("a", "a", "-vim")
      )
    end,
  },
  {
    -- Requires `bun` js software to be installed
    "wallpants/github-preview.nvim",
    cmd = { "GithubPreviewToggle" },
    keys = { "<leader>mpt" },
    opts = {
      -- config goes here
    },
    config = function(_, opts)
      local gpreview = require "github-preview"
      gpreview.setup(opts)

      local fns = gpreview.fns
      vim.keymap.set("n", "<leader>mpt", fns.toggle)
      vim.keymap.set("n", "<leader>mps", fns.single_file_toggle)
      vim.keymap.set("n", "<leader>mpd", fns.details_tags_toggle)
    end,
  },
}
