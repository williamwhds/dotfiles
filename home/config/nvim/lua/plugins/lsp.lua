return {
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    config = function()
      require("mason-lspconfig").setup({
        -- autoinstall these
        ensure_installed = { "lua_ls" },
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = { "williamboman/mason-lspconfig.nvim" },
    config = function()
      local servers = { "lua_ls", "nil_ls" }

      for _, server in ipairs(servers) do
        vim.lsp.config[server] = {}
        vim.lsp.enable(server)
      end

      -- Keybindings
      vim.keymap.set('n', 'K', vim.lsp.buf.hover, { desc = "LSP Hover" })
      vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = "LSP Go to Definition" })
      vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { desc = "LSP Code Action" })
      vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, { desc = "LSP Rename" })

      vim.keymap.set('n', '<leader>d', vim.diagnostic.open_float, { desc = "Line Diagnostics" })
      -- Go to next/previous diagnostic
      vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = "Previous Diagnostic" })
      vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = "Next Diagnostic" })

    end,
  },
}
