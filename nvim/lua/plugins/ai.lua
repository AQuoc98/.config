return {
  {
    'olimorris/codecompanion.nvim',
    enabled = false,
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
      { 'stevearc/dressing.nvim', opts = {} },
      'nvim-telescope/telescope.nvim',
    },

    -- Global keymaps
    keys = function()
      local map = function(mode, lhs, rhs, desc)
        return { lhs, rhs, mode = mode, desc = 'AI: ' .. desc, silent = true }
      end
      return {
        -- Main
        map('n', '<leader>aa', '<cmd>CodeCompanionActions<CR>', 'Action Palette'),
        map('n', '<leader>ac', '<cmd>CodeCompanionChat Toggle<CR>', 'Chat toggle'),
        map({ 'n', 'v' }, '<leader>ai', '<cmd>CodeCompanion<CR>', 'Inline (selection/buffer)'),

        -- Open chat on a specific adapter (skips `ga`)
        map('n', '<leader>a1', '<cmd>CodeCompanionChat copilot<CR>', 'Chat (Copilot)'),
        map('n', '<leader>a2', '<cmd>CodeCompanionChat githubmodels<CR>', 'Chat (GitHub Models)'),

        -- Prompt shortcuts (from Prompt Library)
        map({ 'n', 'v' }, '<leader>af', function()
          require('codecompanion').prompt 'fix'
        end, 'Prompt: /fix'),
        map({ 'n', 'v' }, '<leader>ae', function()
          require('codecompanion').prompt 'explain'
        end, 'Prompt: /explain'),
        map({ 'n', 'v' }, '<leader>at', function()
          require('codecompanion').prompt 'tests'
        end, 'Prompt: /tests'),
        map('n', '<leader>am', function()
          require('codecompanion').prompt 'commit'
        end, 'Prompt: /commit'),
        map({ 'n', 'v' }, '<leader>ad', function()
          require('codecompanion').prompt 'doc'
        end, 'Prompt: /doc'),
        map({ 'n', 'v' }, '<leader>ar', function()
          require('codecompanion').prompt 'regex'
        end, 'Prompt: /regex'),
        map('n', '<leader>as', function()
          require('codecompanion').prompt 'sr'
        end, 'Prompt: /sr (Search & Replace)'),
      }
    end,

    opts = function()
      local adapters = require 'codecompanion.adapters'

      -- ---------- Default excludes for search (ripgrep)
      -- These are used by the grep_search tool (and by /sr flow).
      local DEFAULT_EXCLUDES = {
        '!.git/**',
        '!node_modules/**',
        '!.next/**',
        '!dist/**',
        '!build/**',
        '!coverage/**',
        '!vendor/**',
        '!.cache/**',
        '!target/**',
        '!out/**',
        '!tmp/**',
        '!logs/**',
        '!.venv/**',
        '!venv/**',
        '!.idea/**',
        '!.vscode/**',
        '!.expo/**',
        '!Pods/**',
        '!Carthage/**',
      }

      -- ---------- Adapters (Copilot default + GitHub Models)
      local copilot = function()
        return adapters.extend('copilot', {
          schema = { model = { default = 'gpt-4.1' } },
          opts = { stream = true },
        })
      end

      local ghmodels = function()
        return adapters.extend('githubmodels', {
          schema = { model = { default = 'openai/gpt-4.1' } },
          opts = { stream = true },
        })
      end

      -- helper: get selected code (inline/chat prompts)
      local function get_selected_code(context)
        local a = require 'codecompanion.helpers.actions'
        return a.get_code(context.start_line, context.end_line)
      end

      return {
        adapters = {
          copilot = copilot,
          githubmodels = ghmodels,
          opts = {
            show_defaults = true,
            show_model_choices = true,
          },
        },

        -- ---------- Strategies
        strategies = {
          chat = {
            adapter = { name = 'copilot', model = 'gpt-4.1' },
            roles = {
              llm = function(adapter)
                local name = adapter.formatted_name
                if adapter.model and adapter.model.name then
                  name = name .. ' (' .. adapter.model.name .. ')'
                end
                return 'CodeCompanion ' .. name
              end,
              user = 'Me',
            },
            opts = {
              completion_provider = 'cmp',
              -- Optional: separate user's message from context blocks
              prompt_decorator = function(message)
                return string.format('<prompt>%s</prompt>', message)
              end,
            },

            -- VSCode-like context via Slash Commands
            slash_commands = {
              buffer = {
                callback = 'strategies.chat.slash_commands.buffer',
                description = 'Insert open buffers',
                opts = { provider = 'telescope', contains_code = true },
                keymaps = { modes = { i = '<C-b>', n = { '<C-b>', 'gb' } } },
              },
              file = {
                callback = 'strategies.chat.slash_commands.file',
                description = 'Select file(s) from cwd',
                opts = { provider = 'telescope', contains_code = true },
                keymaps = { modes = { i = '<C-f>', n = 'gf' } },
              },
              symbols = {
                callback = 'strategies.chat.slash_commands.symbols',
                description = 'Insert symbols outline',
                opts = { provider = 'telescope' },
              },
              quickfix = {
                callback = 'strategies.chat.slash_commands.quickfix',
                description = 'Insert quickfix entries',
              },
              fetch = {
                callback = 'strategies.chat.slash_commands.fetch',
                description = 'Fetch URL content (cached)',
              },
              image = {
                callback = 'strategies.chat.slash_commands.image',
                description = 'Insert image(s) from path or URL',
              },
              workspace = {
                callback = 'strategies.chat.slash_commands.workspace',
                description = 'Insert workspace-defined context',
              },
            },

            -- Variables (VSCode-like)
            variables = {
              buffer = { opts = { default_params = 'pin' } }, -- auto-pin current buffer
              -- #{lsp}, #{viewport} are available by default
            },

            -- Tools / Agents
            tools = {
              opts = {
                default_tools = { 'files', 'grep_search', 'insert_edit_into_file', 'get_changed_files' },
                auto_submit_errors = true,
                auto_submit_success = true,
              },

              -- Default exclude behavior for grep_search (ripgrep)
              ['grep_search'] = {
                opts = {
                  ripgrep = {
                    -- Pass --glob patterns to rg
                    extra_args = (function()
                      local args = {}
                      for _, g in ipairs(DEFAULT_EXCLUDES) do
                        table.insert(args, '--glob')
                        table.insert(args, g)
                      end
                      return args
                    end)(),
                    -- uncomment if you want to search dotfiles that aren't excluded:
                    -- include_hidden = true,
                  },
                },
              },

              -- Safe file edits (confirm file writes, but not buffer edits)
              ['insert_edit_into_file'] = {
                opts = { requires_approval = { buffer = false, file = true }, user_confirmation = true },
              },

              -- Confirm before running shell commands
              ['cmd_runner'] = { opts = { requires_approval = true } },

              -- Optional groups you can reference like @{full_stack_dev}
              groups = {
                ['full_stack_dev'] = {
                  description = 'Run shell, edit files and search code',
                  tools = { 'cmd_runner', 'files', 'insert_edit_into_file', 'grep_search' },
                  opts = { collapse_tools = true },
                },
              },
            },

            -- Chat buffer keymaps
            keymaps = {
              send = { modes = { n = '<CR>', i = '<C-s>' } },
              close = { modes = { n = '<C-c>', i = '<C-c>' } },
            },
          },

          -- Inline
          inline = {
            adapter = { name = 'copilot', model = 'gpt-4.1' },
            keymaps = {
              accept_change = { modes = { n = 'ga' }, description = 'Accept inline change' },
              reject_change = { modes = { n = 'gr' }, opts = { nowait = true }, description = 'Reject inline change' },
            },
          },

          -- Agent
          agent = {
            adapter = { name = 'copilot', model = 'gpt-4.1' },
          },
        },

        -- ---------- Prompt Library
        prompt_library = {
          -- /fix
          ['Fix Code (selection/buffer)'] = {
            strategy = 'inline',
            description = 'Refactor/fix selected code with minimal diffs',
            opts = {
              short_name = 'fix',
              is_slash_cmd = true,
              user_prompt = true,
              auto_submit = true,
              stop_context_insertion = true,
              modes = { 'n', 'v' },
            },
            prompts = {
              { role = 'system', content = 'You are a senior engineer. Keep behavior identical and minimize edits.' },
              {
                role = 'user',
                content = function(context)
                  local code = get_selected_code(context)
                  return string.format('Please fix/refactor the following code. Keep changes minimal.\n\n```%s\n%s\n```', context.filetype, code)
                end,
                opts = { contains_code = true },
              },
            },
          },

          -- /explain
          ['Explain (selection/buffer)'] = {
            strategy = 'chat',
            description = 'Explain code with pitfalls & examples',
            opts = { short_name = 'explain', is_slash_cmd = true, user_prompt = false, auto_submit = true, modes = { 'n', 'v' } },
            prompts = {
              { role = 'system', content = 'Explain step-by-step, mention pitfalls and edge-cases. Include a short example.' },
              {
                role = 'user',
                content = function(context)
                  local code = get_selected_code(context)
                  return string.format('Explain this code:\n\n```%s\n%s\n```', context.filetype, code)
                end,
                opts = { contains_code = true },
              },
            },
          },

          -- /tests
          ['Generate Tests'] = {
            strategy = 'chat',
            description = 'Generate high-value unit tests with edge-cases',
            opts = { short_name = 'tests', is_slash_cmd = true, user_prompt = true, auto_submit = true, modes = { 'n', 'v' } },
            prompts = {
              { role = 'system', content = "Write concise tests. Prefer the project's existing framework (jest/vitest, etc.)." },
              {
                role = 'user',
                content = function(context)
                  local code = get_selected_code(context)
                  return string.format('Create unit tests for:\n\n```%s\n%s\n```', context.filetype, code)
                end,
                opts = { contains_code = true },
              },
            },
          },

          -- /commit
          ['Conventional Commit'] = {
            strategy = 'chat',
            description = 'Generate a conventional commit message from git changes',
            opts = { short_name = 'commit', is_slash_cmd = true, user_prompt = false, auto_submit = true },
            prompts = {
              { role = 'system', content = 'Return a conventional commits message (type(scope): subject) + short body.' },
              { role = 'user', content = 'Use the @{get_changed_files} tool to inspect staged & unstaged changes and propose a message.' },
            },
          },

          -- /doc
          ['Docstring This'] = {
            strategy = 'inline',
            description = 'Generate docstrings for selection with project style',
            opts = { short_name = 'doc', is_slash_cmd = true, user_prompt = false, auto_submit = true, modes = { 'n', 'v' } },
            prompts = {
              { role = 'system', content = 'Generate clear, concise docstrings following common conventions for the language.' },
              {
                role = 'user',
                content = function(context)
                  local code = get_selected_code(context)
                  return string.format('Add docstrings for the following:\n\n```%s\n%s\n```', context.filetype, code)
                end,
                opts = { contains_code = true },
              },
            },
          },

          -- /regex (Regex Wizard)
          ['Regex Wizard'] = {
            strategy = 'chat',
            description = 'Design a regex with tests and CLI usage (rg/sed)',
            opts = { short_name = 'regex', is_slash_cmd = true, user_prompt = true, auto_submit = true, modes = { 'n', 'v' } },
            prompts = {
              {
                role = 'system',
                content = table.concat({
                  'You help craft robust regex. Return:',
                  '1) The regex (PCRE/JS style).',
                  '2) Positive/negative test cases.',
                  '3) CLI usage: ripgrep (rg) and sed, quoted safely for bash.',
                  '4) Brief explanation of groups and anchors.',
                }, '\n'),
              },
              {
                role = 'user',
                content = function(context)
                  local code = get_selected_code(context) or ''
                  return ('Design a regex for this task. If selection provided, use it as sample:\n\n%s\n'):format(code)
                end,
              },
            },
          },

          -- /sr — Search & Replace (uses grep_search + insert_edit_into_file)
          ['Search & Replace (QF + Grep)'] = {
            strategy = 'chat',
            description = 'Plan/preview S&R via @{grep_search} then apply with @{insert_edit_into_file}',
            opts = { short_name = 'sr', is_slash_cmd = true, user_prompt = true, auto_submit = false, modes = { 'n' } },
            prompts = {
              {
                role = 'system',
                content = table.concat({
                  'Goal: safe multi-file search & replace.',
                  'Plan:',
                  '- Use @{grep_search} (ripgrep) to list matches (respects default exclude globs).',
                  '- Summarize impacted files & counts.',
                  '- Propose a unified diff patch with minimal edits.',
                  '- WAIT for user approval.',
                  '- If approved, apply changes per-file with @{insert_edit_into_file}.',
                  'Edge cases: binary files, generated code, vendor directories; ask to exclude if detected.',
                }, '\n'),
              },
              { role = 'user', content = 'Describe your S&R goal (pattern, replacement). Optionally add include/exclude globs.' },
            },
          },
        },

        -- ---------- UI
        display = {
          action_palette = {
            provider = 'telescope',
            opts = { show_default_actions = true, show_default_prompt_library = true },
          },
          chat = {
            show_settings = false, -- keep false so `ga` (switch adapter/model) works
            show_token_count = true,
            separator = '─',
            window = { layout = 'vertical', border = 'single', width = 0.45, relative = 'editor' },
          },
          diff = {
            enabled = true,
            layout = 'vertical',
            provider = 'default',
            opts = { 'internal', 'filler', 'closeoff', 'algorithm:patience', 'linematch:120' },
          },
        },
      }
    end,

    config = function(_, opts)
      require('codecompanion').setup(opts)
    end,
  },
}
