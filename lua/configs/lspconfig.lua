local on_attach = require("nvchad.configs.lspconfig").on_attach
local on_init = require("nvchad.configs.lspconfig").on_init
local capabilities = require("nvchad.configs.lspconfig").capabilities

local default_servers = {
  "clangd",
  "cssls",
  "html",
  "marksman",
  "ts_ls",
}

for _, server in ipairs(default_servers) do
  vim.lsp.config(server, {
    on_attach = on_attach,
    on_init = on_init,
    capabilities = capabilities,
  })
  vim.lsp.enable(server)
end

vim.lsp.config("pyright", {
  on_attach = on_attach,
  on_init = on_init,
  capabilities = capabilities,
  settings = {
    python = {
      analysis = {
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        typeCheckingMode = "basic",
      },
    },
  },
})
vim.lsp.enable("pyright")

vim.lsp.config("lua_ls", {
  on_attach = on_attach,
  on_init = on_init,
  capabilities = capabilities,
  settings = {
    Lua = {
      diagnostics = {
        enable = false,
      },
      workspace = {
        library = {
          vim.fn.expand("$VIMRUNTIME/lua"),
          vim.fn.expand("$VIMRUNTIME/lua/vim/lsp"),
          vim.fn.stdpath("data") .. "/lazy/ui/nvchad_types",
          vim.fn.stdpath("data") .. "/lazy/lazy.nvim/lua/lazy",
          "${3rd}/love2d/library",
        },
        maxPreload = 100000,
        preloadFileSize = 10000,
      },
    },
  },
})
vim.lsp.enable("lua_ls")
