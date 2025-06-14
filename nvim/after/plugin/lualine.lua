-- Check if lualine is available
local ok, lualine = pcall(require, 'lualine')
if not ok then
    return
end

-- Custom function to get current mode from our tri-mode system
local function get_nvim_mode()
    local modes = require('d00ksky.modes')
    local current_mode = modes.get_current_mode()
    return current_mode.mode_name
end

-- Custom function to get mode color
local function get_mode_color()
    local modes = require('d00ksky.modes')
    local current_mode = modes.get_current_mode()
    return current_mode.mode_color
end

-- Custom git branch with icon
local function git_branch()
    local branch = vim.fn.system("git branch --show-current 2>/dev/null | tr -d '\n'")
    if branch ~= "" then
        return " " .. branch
    else
        return ""
    end
end

-- Custom function to show relative line position
local function line_info()
    local current_line = vim.fn.line('.')
    local total_lines = vim.fn.line('$')
    return string.format('%3d/%-3d', current_line, total_lines)
end

-- Custom function to show column position
local function column_info()
    return string.format('Col %-3d', vim.fn.col('.'))
end

-- LSP diagnostics count
local function lsp_diagnostics()
    local count = {}
    local levels = {
        errors = vim.diagnostic.severity.ERROR,
        warnings = vim.diagnostic.severity.WARN,
        info = vim.diagnostic.severity.INFO,
        hints = vim.diagnostic.severity.HINT,
    }
    
    for k, level in pairs(levels) do
        count[k] = vim.tbl_count(vim.diagnostic.get(0, { severity = level }))
    end
    
    local errors = count["errors"] or 0
    local warnings = count["warnings"] or 0
    
    if errors > 0 then
        return string.format(" %d", errors)
    elseif warnings > 0 then
        return string.format(" %d", warnings)
    else
        return ""
    end
end

lualine.setup {
    options = {
        icons_enabled = true,
        theme = 'auto',
        component_separators = { left = '', right = ''},
        section_separators = { left = '', right = ''},
        disabled_filetypes = {
            statusline = {},
            winbar = {},
        },
        ignore_focus = {},
        always_divide_middle = true,
        globalstatus = true,
        refresh = {
            statusline = 1000,
            tabline = 1000,
            winbar = 1000,
        }
    },
    sections = {
        lualine_a = {
            {
                get_nvim_mode,
                color = function()
                    return { fg = '#000000', bg = get_mode_color(), gui = 'bold' }
                end,
            }
        },
        lualine_b = {
            {
                git_branch,
                icon = '',
                color = { fg = '#ff9e64', gui = 'bold' }
            },
            {
                'diff',
                symbols = {added = ' ', modified = ' ', removed = ' '},
                diff_color = {
                    added = { fg = '#9ece6a' },
                    modified = { fg = '#e0af68' },
                    removed = { fg = '#f7768e' }
                },
            }
        },
        lualine_c = {
            {
                'filename',
                file_status = true,
                newfile_status = false,
                path = 1, -- Show relative path
                shorting_target = 40,
                symbols = {
                    modified = '[+]',
                    readonly = '[RO]',
                    unnamed = '[No Name]',
                    newfile = '[New]',
                }
            }
        },
        lualine_x = {
            {
                lsp_diagnostics,
                color = { fg = '#f7768e' }
            },
            {
                'encoding',
                fmt = string.upper,
            },
            {
                'fileformat',
                symbols = {
                    unix = 'LF',
                    dos = 'CRLF',
                    mac = 'CR',
                }
            },
            'filetype'
        },
        lualine_y = {
            {
                line_info,
                icon = '',
            },
            {
                column_info,
            }
        },
        lualine_z = {
            {
                'progress',
                color = { fg = '#7aa2f7', gui = 'bold' }
            }
        }
    },
    inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {'filename'},
        lualine_x = {'location'},
        lualine_y = {},
        lualine_z = {}
    },
    tabline = {},
    winbar = {},
    inactive_winbar = {},
    extensions = {
        'neo-tree',
        'trouble',
        'fugitive',
        'toggleterm'
    }
}