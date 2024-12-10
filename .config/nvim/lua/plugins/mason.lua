return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      pyright = {
        enabled = true,
        -- enabled = vim.g.lazyvim_python_lsp ~= "basedpyright",
      },
      basedpyright = {
        enabled = false,
        -- enabled = vim.g.lazyvim_python_lsp == "basedpyright",
      },
      clangd = {
        filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "hpp" },
      },

      ruff_lsp = {
        keys = {
          {
            "<leader>co",
            function()
              vim.lsp.buf.code_action({
                apply = true,
                context = {
                  only = { "source.organizeImports" },
                  diagnostics = {},
                },
              })
            end,
            desc = "Organize Imports",
          },
        },
      },
    },
    setup = {
      ruff_lsp = function()
        LazyVim.lsp.on_attach(function(client, _)
          if client.name == "ruff_lsp" then
            -- Disable hover in favor of Pyright
            client.server_capabilities.hoverProvider = true
          end
        end)
      end,
    },
  },
}
