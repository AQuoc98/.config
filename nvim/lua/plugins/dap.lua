return {
  {
    "mfussenegger/nvim-dap",
    recommended = true,
    desc = "Debugging support. Requires language specific adapters to be configured. (see lang extras)",

    dependencies = {
      "rcarriga/nvim-dap-ui",
      -- virtual text for the debugger
      {
        "theHamsta/nvim-dap-virtual-text",
        opts = {},
      },
    },

    config = function()
      local dap = require("dap")

      -- load mason-nvim-dap here, after all adapters have been setup
      if LazyVim.has("mason-nvim-dap.nvim") then
        require("mason-nvim-dap").setup(LazyVim.opts("mason-nvim-dap.nvim"))
      end

      vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })

      for name, sign in pairs(LazyVim.config.icons.dap) do
        sign = type(sign) == "table" and sign or { sign }
        vim.fn.sign_define(
          "Dap" .. name,
          { text = sign[1], texthl = sign[2] or "DiagnosticInfo", linehl = sign[3], numhl = sign[3] }
        )
      end

      -- Configure the DAP settings for Dart/Flutter
      dap.configurations.dart = {
        {
          type = "dart",
          request = "launch",
          name = "Launch dart",
          program = "${file}", -- ensure this is correct
          cwd = "${workspaceFolder}",
        },
        {
          type = "flutter",
          request = "launch",
          name = "Launch flutter",
          program = "${workspaceFolder}/lib/main.dart", -- ensure this is correct
          cwd = "${workspaceFolder}",
        },
      }

      dap.adapters.dart = {
        type = "executable",
        command = "dart",
        args = { "debug_adapter" },
      }

      dap.adapters.flutter = {
        type = "executable",
        command = "flutter", -- if you're using fvm, you'll need to provide the full path to flutter (flutter.bat for windows users), or you could prepend the fvm command
        args = { "debug_adapter" },
        toolArgs = { "--device-id", "FC1891B0-A121-4CA0-B1CB-70BF92DCD271" },
        -- windows users will need to set 'detached' to false
        options = {
          detached = false,
        },
      }
    end,
  },
}
