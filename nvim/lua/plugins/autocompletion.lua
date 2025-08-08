return { -- Autocompletion
  {
    'zbirenbaum/copilot.lua',
    cmd = 'Copilot',
    event = 'InsertEnter',
    opts = {
      panel = { enabled = false }, -- use nvim-cmp to show => turn off panel
      suggestion = { enabled = false }, -- turn off ghost text
      filetypes = {
        markdown = true,
        yaml = true,
        gitcommit = true,
        gitrebase = true,
        help = false,
        TelescopePrompt = false,
        ['*'] = true,
      },
    },
    config = function(_, opts)
      require('copilot').setup(opts)
    end,
    keys = {
      -- open/close Copilot quickly (global)
      {
        '<leader>uC',
        function()
          local enabled = require('copilot.client').is_disabled()
          vim.cmd(enabled and 'Copilot enable' or 'Copilot disable')
          vim.notify('Copilot ' .. (enabled and 'enabled' or 'disabled'))
        end,
        desc = 'Toggle Copilot',
      },
    },
  },
  {
    'zbirenbaum/copilot-cmp',
    config = function()
      require('copilot_cmp').setup()
    end,
  },
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      -- Snippet Engine & its associated nvim-cmp source
      {
        'L3MON4D3/LuaSnip',
        build = (function()
          -- Build Step is needed for regex support in snippets
          -- This step is not supported in many windows environments
          -- Remove the below condition to re-enable on windows
          if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
            return
          end
          return 'make install_jsregexp'
        end)(),
      },
      'saadparwaiz1/cmp_luasnip',

      -- Other nvim-cmp sources
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',

      -- Adds a number of user-friendly snippets
      'rafamadriz/friendly-snippets',

      -- Copilot cmp source
      'zbirenbaum/copilot-cmp',
    },
    config = function()
      local cmp = require 'cmp'
      require('luasnip.loaders.from_vscode').lazy_load()
      local luasnip = require 'luasnip'
      luasnip.config.setup {}

      local kind_icons = {
        Text = '󰉿',
        Method = 'm',
        Function = '󰊕',
        Constructor = '',
        Field = '',
        Variable = '󰆧',
        Class = '󰌗',
        Interface = '',
        Module = '',
        Property = '',
        Unit = '',
        Value = '󰎠',
        Enum = '',
        Keyword = '󰌋',
        Snippet = '',
        Color = '󰏘',
        File = '󰈙',
        Reference = '',
        Folder = '󰉋',
        EnumMember = '',
        Constant = '󰇽',
        Struct = '',
        Event = '',
        Operator = '󰆕',
        TypeParameter = '󰊄',
      }

      -- Compare Copilot priority with nvim-cmp
      local default_comparators = {
        cmp.config.compare.offset,
        cmp.config.compare.exact,
        cmp.config.compare.score,
        cmp.config.compare.recently_used,
        cmp.config.compare.kind,
        cmp.config.compare.sort_text,
        cmp.config.compare.length,
        cmp.config.compare.order,
      }

      local comparators = default_comparators
      local ok_cop, copilot_cmp = pcall(require, 'copilot_cmp.comparators')
      if ok_cop then
        comparators = vim.list_extend({
          copilot_cmp.prioritize,
          copilot_cmp.score,
        }, default_comparators)
      end

      cmp.setup {
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        completion = { completeopt = 'menu,menuone,noinsert' },
        -- window = {
        --     completion = cmp.config.window.bordered(),
        --     documentation = cmp.config.window.bordered(),
        -- },
        mapping = cmp.mapping.preset.insert {
          ['<C-j>'] = cmp.mapping.select_next_item(), -- Select the [n]ext item
          ['<C-k>'] = cmp.mapping.select_prev_item(), -- Select the [p]revious item
          ['<CR>'] = cmp.mapping.confirm { select = true }, -- Accept the completion with Enter.
          ['<C-c>'] = cmp.mapping.complete {}, -- Manually trigger a completion from nvim-cmp.

          -- Think of <c-l> as moving to the right of your snippet expansion.
          --  So if you have a snippet that's like:
          --  function $name($args)
          --    $body
          --  end
          --
          -- <c-l> will move you to the right of each of the expansion locations.
          -- <c-h> is similar, except moving you backwards.
          ['<C-l>'] = cmp.mapping(function()
            if luasnip.expand_or_locally_jumpable() then
              luasnip.expand_or_jump()
            end
          end, { 'i', 's' }),
          ['<C-h>'] = cmp.mapping(function()
            if luasnip.locally_jumpable(-1) then
              luasnip.jump(-1)
            end
          end, { 'i', 's' }),

          -- Select next/previous item with Tab / Shift + Tab
          ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_locally_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { 'i', 's' }),
          ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.locally_jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { 'i', 's' }),
        },
        sources = {
          { name = 'copilot', group_index = 1 },
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'buffer' },
          { name = 'path' },
        },
        sorting = { comparators = comparators },
        formatting = {
          fields = { 'kind', 'abbr', 'menu' },
          format = function(entry, vim_item)
            -- Kind icons
            vim_item.kind = string.format('%s', kind_icons[vim_item.kind])
            -- vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind) -- This concatonates the icons with the name of the item kind
            vim_item.menu = ({
              copilot = '[Copilot]',
              nvim_lsp = '[LSP]',
              luasnip = '[Snippet]',
              buffer = '[Buffer]',
              path = '[Path]',
            })[entry.source.name]
            return vim_item
          end,
        },
      }
    end,
  },
}
