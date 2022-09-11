local lspconfig = require("lspconfig")

local capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities())

lspconfig.bashls.setup({
    capabilities = capabilities,
})

lspconfig.ccls.setup({
    capabilities = capabilities,
    init_options = {
        cache = {
            directory = "/tmp/ccls-cache",
        },
    },
})

lspconfig.cssls.setup({
    capabilities = capabilities,
    cmd = {"css-languageserver", "--stdio"},
})

lspconfig.dockerls.setup({
    capabilities = capabilities,
})

lspconfig.gopls.setup({
    capabilities = capabilities,
})

lspconfig.html.setup({
    capabilities = capabilities,
    cmd = {"html-languageserver", "--stdio"},
})

lspconfig.intelephense.setup({
    capabilities = capabilities,
})

lspconfig.jdtls.setup({
    capabilities = capabilities,
    cmd = {
        "jdt-language-server",
        "-configuration", vim.env.HOME .. "/.cache/jdtls/config",
        "-data", vim.env.HOME .. "/.cache/jdtls/workspace",
    },
})

lspconfig.jsonls.setup({
    capabilities = capabilities,
    cmd = {"json-languageserver", "--stdio"},
})

lspconfig.pyright.setup({
    capabilities = capabilities,
})

lspconfig.rnix.setup({
    capabilities = capabilities,
})

lspconfig.sumneko_lua.setup({
    capabilities = capabilities,
    settings = {
        Lua = {
            diagnostics = {
                globals = {"vim"},
            },
        },
    },
})

lspconfig.yamlls.setup({
    capabilities = capabilities,
})

require("lsp_signature").setup({
    hint_enable = false,
    toggle_key = "<C-k>",
})

vim.fn.sign_define("DiagnosticSignError", {text = "", texthl = "DiagnosticSignError"})
vim.fn.sign_define("DiagnosticSignWarn",  {text = "", texthl = "DiagnosticSignWarn"})
vim.fn.sign_define("DiagnosticSignInfo",  {text = "", texthl = "DiagnosticSignInfo"})
vim.fn.sign_define("DiagnosticSignHint",  {text = "", texthl = "DiagnosticSignHint"})

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
    vim.lsp.handlers.hover, {
        border = {"╭", "─", "╮", "│", "╯", "─", "╰", "│"},
    }
)

vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
    vim.lsp.handlers.signature_help, {
        border = {"╭", "─", "╮", "│", "╯", "─", "╰", "│"},
    }
)
