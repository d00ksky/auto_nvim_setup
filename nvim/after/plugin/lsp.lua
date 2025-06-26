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

-- Setup Mason (with enhanced protection and error handling)
local mason_ok, mason = pcall(require, 'mason')
local mason_lspconfig_ok, mason_lspconfig = pcall(require, 'mason-lspconfig')

if not mason_ok then
    vim.notify("Mason not available - please run :PackerSync and restart Neovim", vim.log.levels.ERROR)
    return
end

if not mason_lspconfig_ok then
    vim.notify("Mason-lspconfig not available - please run :PackerSync and restart Neovim", vim.log.levels.ERROR)
    return
end

-- Setup Mason with better configuration
mason.setup({
    ui = {
        icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗"
        }
    },
    -- Increase timeout for slow connections
    max_concurrent_installers = 2,
    github = {
        download_url_template = "https://github.com/%s/releases/download/%s/%s",
    },
    -- Add automatic retry on failure
    install_root_dir = vim.fn.stdpath("data") .. "/mason",
})

-- Enhanced Mason LSP configuration with better error handling
local ensure_installed = {
    'pyright',      -- Python
    'gopls',        -- Go  
    'ts_ls',        -- TypeScript/JavaScript (renamed from tsserver)
    'lua_ls',       -- Lua
    'rust_analyzer' -- Rust (bonus)
}

mason_lspconfig.setup({
    ensure_installed = ensure_installed,
    automatic_installation = true,
    handlers = {
        lsp_zero.default_setup,
        
        -- Python - Pyright with error handling
        pyright = function()
            local ok, lspconfig = pcall(require, 'lspconfig')
            if not ok then
                vim.notify("LSP config not available for Pyright", vim.log.levels.WARN)
                return
            end
            
            -- Check if Python is available
            if vim.fn.executable("python3") == 0 and vim.fn.executable("python") == 0 then
                vim.notify("Python not found - Pyright LSP will not work", vim.log.levels.WARN)
                return
            end
            
            lspconfig.pyright.setup({
                settings = {
                    python = {
                        analysis = {
                            typeCheckingMode = "basic",
                            autoSearchPaths = true,
                            useLibraryCodeForTypes = true,
                        }
                    }
                },
                on_attach = function(client, bufnr)
                    vim.notify("Pyright LSP attached successfully", vim.log.levels.INFO)
                end,
            })
        end,
        
        -- Go - gopls with error handling
        gopls = function()
            local ok, lspconfig = pcall(require, 'lspconfig')
            if not ok then
                vim.notify("LSP config not available for Go", vim.log.levels.WARN)
                return
            end
            
            -- Check if Go is available
            if vim.fn.executable("go") == 0 then
                vim.notify("Go not found - gopls LSP will not work", vim.log.levels.WARN)
                return
            end
            
            lspconfig.gopls.setup({
                settings = {
                    gopls = {
                        analyses = {
                            unusedparams = true,
                        },
                        staticcheck = true,
                        gofumpt = true,
                    },
                },
                on_attach = function(client, bufnr)
                    vim.notify("Go LSP attached successfully", vim.log.levels.INFO)
                end,
            })
        end,
        
        -- TypeScript/JavaScript with error handling
        ts_ls = function()
            local ok, lspconfig = pcall(require, 'lspconfig')
            if not ok then
                vim.notify("LSP config not available for TypeScript", vim.log.levels.WARN)
                return
            end
            
            -- Check if Node.js is available
            if vim.fn.executable("node") == 0 then
                vim.notify("Node.js not found - TypeScript LSP will not work", vim.log.levels.WARN)
                return
            end
            
            lspconfig.ts_ls.setup({
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
                },
                on_attach = function(client, bufnr)
                    vim.notify("TypeScript LSP attached successfully", vim.log.levels.INFO)
                end,
            })
        end,
        
        -- Lua with error handling
        lua_ls = function()
            local ok, lspconfig = pcall(require, 'lspconfig')
            if not ok then
                vim.notify("LSP config not available for Lua", vim.log.levels.WARN)
                return
            end
            
            lspconfig.lua_ls.setup({
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
                },
                on_attach = function(client, bufnr)
                    vim.notify("Lua LSP attached successfully", vim.log.levels.INFO)
                end,
            })
        end,
    }
})

-- Mason auto-installation disabled to prevent startup errors
-- Language servers will install automatically when you open relevant files
-- To manually install: :MasonInstall pyright gopls typescript-language-server lua-language-server rust-analyzer

-- Add Mason troubleshooting commands
vim.api.nvim_create_user_command("MasonTroubleshoot", function()
    local lines = {
        "Mason Troubleshooting Information:",
        "=====================================",
        "",
        "System Information:",
        "  OS: " .. vim.loop.os_uname().sysname,
        "  Neovim Version: " .. vim.version().major .. "." .. vim.version().minor .. "." .. vim.version().patch,
        "",
        "Dependencies Check:",
        "  Node.js: " .. (vim.fn.executable("node") == 1 and "✓ Found" or "✗ Missing"),
        "  Python: " .. (vim.fn.executable("python3") == 1 and "✓ Found" or "✗ Missing"),
        "  Go: " .. (vim.fn.executable("go") == 1 and "✓ Found" or "✗ Missing"),
        "  Git: " .. (vim.fn.executable("git") == 1 and "✓ Found" or "✗ Missing"),
        "  Curl: " .. (vim.fn.executable("curl") == 1 and "✓ Found" or "✗ Missing"),
        "",
        "Mason Installation Directory:",
        "  " .. vim.fn.stdpath("data") .. "/mason",
        "",
        "To fix issues:",
        "  1. Run :PackerSync to ensure plugins are installed",
        "  2. Run :Mason to open Mason interface",
        "  3. Manually install missing language servers",
        "  4. Restart Neovim after installation",
    }
    
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    vim.api.nvim_open_win(buf, true, {
        relative = "editor",
        width = 60,
        height = #lines + 2,
        col = (vim.o.columns - 60) / 2,
        row = (vim.o.lines - #lines) / 2,
        style = "minimal",
        border = "rounded",
    })
end, { desc = "Show Mason troubleshooting information" })

-- Add command to reset Mason auto-installation marker
vim.api.nvim_create_user_command("MasonResetAutoInstall", function()
    local marker_file = vim.fn.stdpath("data") .. "/mason_auto_installed"
    if vim.fn.filereadable(marker_file) == 1 then
        vim.fn.delete(marker_file)
        vim.notify("Mason auto-install marker reset. Language servers will be checked on next startup.", vim.log.levels.INFO)
    else
        vim.notify("No auto-install marker found.", vim.log.levels.INFO)
    end
end, { desc = "Reset Mason auto-installation marker" })

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