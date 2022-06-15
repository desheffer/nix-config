local servers = {
    bashls = {},
    cssls = {},
    dockerls = {},
    gopls = {},
    html = {},
    jdtls = {
        settings = {
            -- Some features will silently fail if this table is missing.
            java = {},
        },
    },
    jsonls = {},
    omnisharp = {},
    phpactor = {},
    pyright = {},
    sumneko_lua = {
        settings = {
            Lua = {
                diagnostics = {
                    globals = {"vim"},
                },
            },
        },
    },
    yamlls = {},
}

require("nvim-lsp-installer").on_server_ready(function(server)
    local opts = {}
    if servers[server.name] then
        opts = servers[server.name]
    end

    server:setup(opts)
    vim.cmd([[do User LspAttachBuffers]])
end)

local lsp_installer_servers = require("nvim-lsp-installer.servers")

for server_name, _ in pairs(servers) do
    local ok, server = lsp_installer_servers.get_server(server_name)
    if ok and not server:is_installed() then
        server:install()
    end
end
