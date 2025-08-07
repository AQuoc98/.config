-- Easily comment visual regions/lines
return {
  {
    'numToStr/Comment.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      'JoosepAlviste/nvim-ts-context-commentstring',
    },
    opts = function(_, opts)
      local ts_context_commentstring = require 'ts_context_commentstring.integrations.comment_nvim'

      opts.pre_hook = ts_context_commentstring.create_pre_hook()
    end,
  },
}
