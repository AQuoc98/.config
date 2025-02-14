return {
  -- tools
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "stylua",
        "selene",
        "luacheck",
        "shellcheck",
        "shfmt",
        "tailwindcss-language-server",
        "typescript-language-server",
        "css-lsp",
        "ast-grep",
      })
    end,
  },

  -- lsp servers
  {
    "neovim/nvim-lspconfig",
    opts = {
      inlay_hints = { enabled = false },
      ---@type lspconfig.options
      servers = {
        cssls = {},
        dartls = {},
        tailwindcss = {
          root_dir = function(...)
            return require("lspconfig.util").root_pattern(".git")(...)
          end,
        },
        tsserver = {
          root_dir = function(...)
            return require("lspconfig.util").root_pattern(".git")(...)
          end,
          single_file_support = false,
          settings = {
            typescript = {
              inlayHints = {
                includeInlayParameterNameHints = "literal",
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = false,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
              },
            },
            javascript = {
              inlayHints = {
                includeInlayParameterNameHints = "all",
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = true,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
              },
            },
          },
        },
        html = {},
        yamlls = {
          settings = {
            yaml = {
              keyOrdering = false,
            },
          },
        },
        lua_ls = {
          -- enabled = false,
          single_file_support = true,
          settings = {
            Lua = {
              workspace = {
                checkThirdParty = false,
              },
              completion = {
                workspaceWord = true,
                callSnippet = "Both",
              },
              misc = {
                parameters = {
                  -- "--log-level=trace",
                },
              },
              hint = {
                enable = true,
                setType = false,
                paramType = true,
                paramName = "Disable",
                semicolon = "Disable",
                arrayIndex = "Disable",
              },
              doc = {
                privateName = { "^_" },
              },
              type = {
                castNumberToInteger = true,
              },
              diagnostics = {
                disable = { "incomplete-signature-doc", "trailing-space" },
                -- enable = false,
                groupSeverity = {
                  strong = "Warning",
                  strict = "Warning",
                },
                groupFileStatus = {
                  ["ambiguity"] = "Opened",
                  ["await"] = "Opened",
                  ["codestyle"] = "None",
                  ["duplicate"] = "Opened",
                  ["global"] = "Opened",
                  ["luadoc"] = "Opened",
                  ["redefined"] = "Opened",
                  ["strict"] = "Opened",
                  ["strong"] = "Opened",
                  ["type-check"] = "Opened",
                  ["unbalanced"] = "Opened",
                  ["unused"] = "Opened",
                },
                unusedLocalExclude = { "_*" },
              },
              format = {
                enable = false,
                defaultConfig = {
                  indent_style = "space",
                  indent_size = "2",
                  continuation_indent_size = "2",
                },
              },
            },
          },
        },
      },
      setup = {},
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = function()
      local keys = require("lazyvim.plugins.lsp.keymaps").get()

      local function go_to_location(method)
        local params = vim.lsp.util.make_position_params()
        vim.lsp.buf_request(0, method, params, function(err, result)
          if err then
            vim.notify("LSP Error: " .. err.message, vim.log.levels.ERROR)
            return
          end

          if not result or vim.tbl_isempty(result) then
            vim.notify("No results found", vim.log.levels.WARN)
            return
          end

          -- Ensure result is alway list
          if not vim.tbl_islist(result) then
            result = { result }
          end

          if #result > 1 then
            require("telescope.builtin").lsp_definitions()
            return
          end

          local location = result[1]
          local uri = location.uri or location.targetUri
          if not uri then
            vim.notify("Invalid location result", vim.log.levels.ERROR)
            return
          end

          local target_path = vim.uri_to_fname(uri)
          local current_path = vim.api.nvim_buf_get_name(0)

          -- Nếu file khác, mở tab mới
          if target_path ~= current_path then
            vim.cmd("tabnew " .. vim.fn.fnameescape(target_path))
          end

          -- Nhảy đến vị trí cụ thể trong file
          local range = location.range or location.targetSelectionRange
          local row = range.start.line + 1
          local col = range.start.character + 1
          vim.api.nvim_win_set_cursor(0, { row, col })
        end)
      end

      vim.list_extend(keys, {
        {
          "gd",
          function()
            go_to_location("textDocument/definition")
          end,
          desc = "Go to definition",
          has = "definition",
        },
        {
          "gD",
          function()
            go_to_location("textDocument/declaration")
          end,
          desc = "Go to declaration",
          has = "declaration",
        },
        {
          "gI",
          function()
            go_to_location("textDocument/implementation")
          end,
          desc = "Go to implementation",
          has = "implementation",
        },
        {
          "gy",
          function()
            go_to_location("textDocument/typeDefinition")
          end,
          desc = "Goto type definition",
          has = "typeDefinition",
        },
      })
    end,
  },
}
