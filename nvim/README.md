# Troubleshooting Notes

- Check generate health of Neovim setup. `:checkhealth`

- Update Treesitter. `:TSUpdate`

- Check LSP installation. `:Mason`

- Fix broken icons
  - Download [nerdfix](https://github.com/loichyan/nerdfix) binary and unpack in home directory.
  - Run `nerdfix check <path/to/file>` to check broken icons in a file
  - Run `nerdfix fix <path/to/file>` to fix broken icons in a file

# Search and Replace

## Notes

- In Vim regex, you need to escape special characters like `.` and `*` with a backslash `\`.

## 1. Basic search and replace

- Step 1: Type `/article` and press Enter to jump to the first occurrence.

- Step 2: Press `cgn` to change the current match.

- Step 3: Press `.` (dot) to repeat the change for the next match.

- Step 4: Repeat Step 3 until all matches are changed.

## 2.Using substitute command

- General syntax: `:[range]s/<search>/<replace>/[options]`
  - Options:
    - `g`: Replace all occurrences in the line.
    - `c`: Confirm each replacement.
    - `i`: Ignore case.

- Replace on the current line: `:s/article/Article/g`

- Replace in the entire file: `:%s/article/Article/g`

- Case-insensitive replace in the entire file: `:%s/article/Article/gi`

- Confirm each replacement in the entire file: `:%s/article/Article/gc`

- Limit replacement to a specific range:
  - Replace in lines 10 to 20: `:10,20 s/article/Article/gi`
  - By a count from current line: `:s/old/new/g 2`
  - From current line to end of file: `:.,$s/old/new/g`

- Mathching whole words only:
  - Use `\<` and `\>` to match the start and end of a word: `:s/\<article\>/Article/gi`

## 3. Using telescope and Quickfix list

- Basic Workflow
  - Step 1: Search for the term using Telescope
  - Step 2: Add the results to the Quickfix list
  - Step 3: Replace the term in the Quickfix list by use `:cfdo %s/old_text/new_text/g | update`

- Exclude file path: use `--glob '!pattern'`
  - Example: `textSearch --glob '!**/node_modules/**' --glob '!**/dist/**'`

- Include file path: use `--glob 'pattern'`
  - Example: `textSearch --glob '**/*.js'`

- Other options:
  - `--cwd <path>`: Set the current working directory for the search.
  - `--hidden`: Include hidden files in the search.
  - `--no-ignore`: Ignore `.gitignore` and other ignore files.
  - `--type <type>`: Filter by file type (e.g., `js`, `html`).
  - `--fixed-strings`: Use fixed strings instead of regex for searching.
  - `--ignore-case`: Perform a case-insensitive search.
  - `--case-sensitive`: Perform a case-sensitive search.

# Codecompanion AI

- Auth first
  - Copilot token: :Copilot auth (copilot.lua) or :Copilot setup (copilot.vim).
  - GitHub Models (optional): gh auth login → gh extension install github/gh-models → gh models list.

- Chat & switch models
  - Open chat: <leader>ac.
  - Switch adapter/model in chat: ga (we keep show_settings=false so this works). Or jump directly: <leader>a1 (Copilot), <leader>a2 (GitHub Models).

- Context (VSCode-style)
  - Slash: type /# → choose /buffer, /file, /symbols, /quickfix, /fetch, /image, /workspace.
  - Variables: type # → choose #{buffer} (pinned by default), #{lsp}, #{viewport}.

- Prompts (slash or keymaps)
  - /fix <leader>af: minimal inline refactor/fix.
  - /explain <leader>ae: explain code + pitfalls + example.
  - /tests <leader>at: unit tests (uses selection as context).
  - /commit <leader>am: conventional commits from changes.
  - /doc <leader>ad: docstrings.
  - /regex <leader>ar: regex + tests + CLI (rg/sed).
  - /sr <leader>as: Search & Replace across files:
    - Uses ripgrep with default excludes,
    - Summarizes matches,
    - Proposes a diff patch,
    - On approval, applies edits via insert_edit_into_file.

- Inline
  - Select code → <leader>ai → enter instruction → accept (ga) or reject (gr) the patch.

# [OPENCODE](https://opencode.ai/)

# Shortcut

- [Lazyvim](https://www.lazyvim.org/keymaps)

- [Vim cheat sheet](https://vim.rtorr.com/)

- [Neovim document](https://neovim.io/doc/)

- Relative line number: `number + j | k`
