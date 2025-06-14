-- Check if lsp-zero is available
local ok, lsp_zero = pcall(require, 'lsp-zero')
if not ok then
    vim.notify("lsp-zero not found - please run :PackerSync", vim.log.levels.WARN)
    return
end

-- Setup lsp-zero with recommended presets
lsp_zero.on_attach(function(client, bufnr)
    local opts = {buffer = bufnr, remap = false}

    -- LSP Keybindings (only active when LSP is enabled based on mode)
    vim.keymap.set("n", "gd", function() 
        if _G.nvim_mode == "learning" then
            vim.notify("LSP navigation disabled in Learning mode", vim.log.levels.WARN)
            return
        end
        vim.lsp.buf.definition()
    end, vim.tbl_extend("force", opts, { desc = "Go to definition" }))
    
    vim.keymap.set("n", "K", function()
        if _G.nvim_mode == "learning" then
            vim.notify("LSP hover disabled in Learning mode", vim.log.levels.WARN)
            return
        end
        vim.lsp.buf.hover()
    end, vim.tbl_extend("force", opts, { desc = "Hover documentation" }))
    
    vim.keymap.set("n", "<leader>vws", function()
        if _G.nvim_mode == "learning" then
            vim.notify("LSP workspace symbols disabled in Learning mode", vim.log.levels.WARN)
            return
        end
        vim.lsp.buf.workspace_symbol()
    end, vim.tbl_extend("force", opts, { desc = "Workspace symbols" }))
    
    vim.keymap.set("n", "<leader>vd", function()
        if _G.nvim_mode == "learning" then
            vim.notify("Diagnostics disabled in Learning mode", vim.log.levels.WARN)
            return
        end
        vim.diagnostic.open_float()
    end, vim.tbl_extend("force", opts, { desc = "Show diagnostic" }))
    
    vim.keymap.set("n", "[d", function()
        if _G.nvim_mode == "learning" then return end
        vim.diagnostic.goto_next()
    end, vim.tbl_extend("force", opts, { desc = "Next diagnostic" }))
    
    vim.keymap.set("n", "]d", function()
        if _G.nvim_mode == "learning" then return end
        vim.diagnostic.goto_prev()
    end, vim.tbl_extend("force", opts, { desc = "Previous diagnostic" }))
    
    vim.keymap.set("n", "<leader>vca", function()
        if _G.nvim_mode == "learning" then
            vim.notify("Code actions disabled in Learning mode", vim.log.levels.WARN)
            return
        end
        vim.lsp.buf.code_action()
    end, vim.tbl_extend("force", opts, { desc = "Code actions" }))
    
    vim.keymap.set("n", "<leader>vrr", function()
        if _G.nvim_mode == "learning" then
            vim.notify("References disabled in Learning mode", vim.log.levels.WARN)
            return
        end
        vim.lsp.buf.references()
    end, vim.tbl_extend("force", opts, { desc = "References" }))
    
    vim.keymap.set("n", "<leader>vrn", function()
        if _G.nvim_mode == "learning" then
            vim.notify("Rename disabled in Learning mode", vim.log.levels.WARN)
            return
        end
        vim.lsp.buf.rename()
    end, vim.tbl_extend("force", opts, { desc = "Rename symbol" }))
    
    vim.keymap.set("i", "<C-h>", function()
        if _G.nvim_mode == "learning" then return end
        vim.lsp.buf.signature_help()
    end, vim.tbl_extend("force", opts, { desc = "Signature help" }))
end)

-- Setup Mason (with protection)
local mason_ok, mason = pcall(require, 'mason')
local mason_lspconfig_ok, mason_lspconfig = pcall(require, 'mason-lspconfig')

if not mason_ok or not mason_lspconfig_ok then
    vim.notify("Mason not available - please run :PackerSync", vim.log.levels.WARN)
    return
end

mason.setup({})
mason_lspconfig.setup({
    ensure_installed = {
        'pyright',      -- Python
        'gopls',        -- Go
        'tsserver',     -- TypeScript/JavaScript
        'lua_ls',       -- Lua
        'rust_analyzer' -- Rust (bonus)
    },
    handlers = {
        lsp_zero.default_setup,
        
        -- Python - Pyright
        pyright = function()
            require('lspconfig').pyright.setup({
                settings = {
                    python = {
                        analysis = {
                            typeCheckingMode = "basic",
                            autoSearchPaths = true,
                            useLibraryCodeForTypes = true,
                        }
                    }
                }
            })
        end,
        
        -- Go - gopls
        gopls = function()
            require('lspconfig').gopls.setup({
                settings = {
                    gopls = {
                        analyses = {
                            unusedparams = true,
                        },
                        staticcheck = true,
                        gofumpt = true,
                    },
                },
            })
        end,
        
        -- TypeScript/JavaScript
        tsserver = function()
            require('lspconfig').tsserver.setup({
                settings = {
                    typescript = {
                        preferences = {
                            disableSuggestions = false,
                        }
                    },
                    javascript = {
                        preferences = {
                            disableSuggestions = false,
                        }
                    }
                }
            })
        end,
        
        -- Lua
        lua_ls = function()
            require('lspconfig').lua_ls.setup({
                settings = {
                    Lua = {
                        runtime = {
                            version = 'LuaJIT'
                        },
                        diagnostics = {
                            globals = {'vim'},
                        },
                        workspace = {
                            library = {
                                [vim.fn.expand('$VIMRUNTIME/lua')] = true,
                                [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true,
                            }
                        }
                    }
                }
            })
        end,
    }
})

-- Setup autocompletion
local cmp = require('cmp')
local cmp_select = {behavior = cmp.SelectBehavior.Select}

cmp.setup({
    sources = {
        {name = 'path'},
        {name = 'nvim_lsp'},
        {name = 'nvim_lua'},
        {name = 'buffer', keyword_length = 3},
        {name = 'luasnip', keyword_length = 2},
    },
    formatting = lsp_zero.cmp_format(),
    mapping = cmp.mapping.preset.insert({
        ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
        ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
        ['<C-y>'] = cmp.mapping.confirm({ select = true }),
        ['<C-Space>'] = cmp.mapping.complete(),
    }),
    enabled = function()
        -- Disable completion in Learning mode, but allow in Claude mode with reduced functionality
        if _G.nvim_mode == "learning" then
            return false
        elseif _G.nvim_mode == "claude" then
            return false -- Less intrusive for Claude interaction
        end
        return true
    end,
})

-- Setup LuaSnip
require('luasnip.loaders.from_vscode').lazy_load()

-- Diagnostic configuration
vim.diagnostic.config({
    virtual_text = function()
        return _G.nvim_mode ~= "learning"
    end,
    signs = function()
        return _G.nvim_mode ~= "learning"
    end,
    underline = function()
        return _G.nvim_mode ~= "learning"
    end,
    update_in_insert = false,
    severity_sort = true,
})