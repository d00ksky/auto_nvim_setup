-- Development Modes System
-- Tri-mode system: Learning, Development, Claude modes

local M = {}

-- Global variable to track current mode
_G.nvim_mode = "development" -- default mode

-- Mode configurations
local modes = {
    learning = {
        lsp_enabled = false,
        diagnostics_enabled = false,
        autocomplete_enabled = false,
        format_on_save = false,
        git_signs = false,
        treesitter_highlights = true, -- keep syntax highlighting
        mode_name = "🎓 Learning",
        mode_color = "#ff9e64" -- orange
    },
    development = {
        lsp_enabled = true,
        diagnostics_enabled = true,
        autocomplete_enabled = true,
        format_on_save = true,
        git_signs = true,
        treesitter_highlights = true,
        mode_name = "⚡ Development",
        mode_color = "#9ece6a" -- green
    },
    claude = {
        lsp_enabled = true,
        diagnostics_enabled = true,
        autocomplete_enabled = false, -- less intrusive for Claude interaction
        format_on_save = false,
        git_signs = true,
        treesitter_highlights = true,
        mode_name = "🤖 Claude",
        mode_color = "#7aa2f7" -- blue
    }
}

-- Function to switch modes
function M.switch_mode(mode_name)
    if not modes[mode_name] then
        vim.notify("Invalid mode: " .. mode_name, vim.log.levels.ERROR)
        return
    end
    
    _G.nvim_mode = mode_name
    local config = modes[mode_name]
    
    -- Apply LSP settings
    M.toggle_lsp(config.lsp_enabled)
    
    -- Apply diagnostics
    M.toggle_diagnostics(config.diagnostics_enabled)
    
    -- Apply autocomplete
    M.toggle_autocomplete(config.autocomplete_enabled)
    
    -- Apply git signs
    M.toggle_git_signs(config.git_signs)
    
    -- Notify user
    vim.notify("Switched to " .. config.mode_name .. " mode", vim.log.levels.INFO)
    
    -- Refresh statusline
    vim.cmd("redrawstatus")
end

-- Toggle functions for different features
function M.toggle_lsp(enabled)
    if enabled then
        -- Enable LSP features
        vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {})
        vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {})
    else
        -- Disable LSP hover and signature help
        vim.lsp.handlers["textDocument/hover"] = function() end
        vim.lsp.handlers["textDocument/signatureHelp"] = function() end
    end
end

function M.toggle_diagnostics(enabled)
    if enabled then
        vim.diagnostic.enable()
    else
        vim.diagnostic.disable()
    end
end

function M.toggle_autocomplete(enabled)
    -- This will be handled in the cmp configuration
    _G.cmp_enabled = enabled
end

function M.toggle_git_signs(enabled)
    if package.loaded['gitsigns'] then
        if enabled then
            require('gitsigns').toggle_signs(true)
        else
            require('gitsigns').toggle_signs(false)
        end
    end
end

-- Get current mode info
function M.get_current_mode()
    return modes[_G.nvim_mode] or modes.development
end

-- Initialize mode system
function M.setup()
    -- Set initial mode
    M.switch_mode("development")
    
    -- Create user commands
    vim.api.nvim_create_user_command('LearningMode', function()
        M.switch_mode('learning')
    end, {})
    
    vim.api.nvim_create_user_command('DevelopmentMode', function()
        M.switch_mode('development')
    end, {})
    
    vim.api.nvim_create_user_command('ClaudeMode', function()
        M.switch_mode('claude')
    end, {})
end

return M