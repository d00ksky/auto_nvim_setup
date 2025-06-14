-- Theme setup
function ColorMyPencils(color)
    color = color or "rose-pine"
    vim.cmd.colorscheme(color)

    -- Make background transparent
    vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
    
    -- Ensure sign column is transparent
    vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })
    vim.api.nvim_set_hl(0, "GitSignsAdd", { bg = "none" })
    vim.api.nvim_set_hl(0, "GitSignsChange", { bg = "none" })
    vim.api.nvim_set_hl(0, "GitSignsDelete", { bg = "none" })
end

-- Setup Rose Pine theme
local rosepine_ok, rosepine = pcall(require, 'rose-pine')
if rosepine_ok then
    rosepine.setup({
    variant = 'auto',
    dark_variant = 'main',
    bold_vert_split = false,
    dim_nc_background = false,
    disable_background = true, -- Make background transparent
    disable_float_background = true,
    
    groups = {
        background = 'none',
        background_nc = 'none',
        panel = 'surface',
        panel_nc = 'base',
        border = 'highlight_med',
        comment = 'muted',
        link = 'iris',
        punctuation = 'subtle',
        
        error = 'love',
        hint = 'iris',
        info = 'foam',
        warn = 'gold',
        
        headings = {
            h1 = 'iris',
            h2 = 'foam',
            h3 = 'rose',
            h4 = 'gold',
            h5 = 'pine',
            h6 = 'foam',
        }
    },
    
    highlight_groups = {
        ColorColumn = { bg = 'rose' },
        CursorLine = { bg = 'foam', blend = 10 },
        StatusLine = { fg = 'love', bg = 'love', blend = 10 },
        Search = { bg = 'gold', inherit = false },
        DiagnosticVirtualTextError = { fg = 'love' },
        DiagnosticVirtualTextWarn = { fg = 'gold' },
        DiagnosticVirtualTextInfo = { fg = 'foam' },
        DiagnosticVirtualTextHint = { fg = 'iris' },
    }
})
end

-- Setup Tokyo Night as alternative
local tokyonight_ok, tokyonight = pcall(require, "tokyonight")
if tokyonight_ok then
    tokyonight.setup({
    style = "storm",
    light_style = "day",
    transparent = true,
    terminal_colors = true,
    styles = {
        comments = { italic = true },
        keywords = { italic = true },
        functions = {},
        variables = {},
        sidebars = "transparent",
        floats = "transparent",
    },
    sidebars = { "qf", "help", "terminal", "packer" },
    day_brightness = 0.3,
    hide_inactive_statusline = false,
    dim_inactive = false,
    lualine_bold = false,
    
    on_colors = function(colors)
        colors.hint = colors.orange
        colors.error = "#ff0000"
    end,
    
    on_highlights = function(highlights, colors)
        highlights.DiagnosticVirtualTextError = { fg = colors.error }
        highlights.DiagnosticVirtualTextWarn = { fg = colors.warning }
        highlights.DiagnosticVirtualTextInfo = { fg = colors.info }
        highlights.DiagnosticVirtualTextHint = { fg = colors.hint }
    end,
})
end

-- Set default theme (only if themes are available)
if rosepine_ok then
    ColorMyPencils("rose-pine")
elseif tokyonight_ok then
    ColorMyPencils("tokyonight")
else
    -- Fallback to built-in themes
    vim.cmd.colorscheme("habamax")
end

-- Create command to switch themes
vim.api.nvim_create_user_command('ThemeRosePine', function()
    ColorMyPencils("rose-pine")
end, {})

vim.api.nvim_create_user_command('ThemeTokyoNight', function()
    ColorMyPencils("tokyonight")
end, {})

-- Theme switching keybinds (only if themes are available)
if rosepine_ok then
    vim.keymap.set("n", "<leader>tr", "<cmd>ThemeRosePine<CR>", { desc = "Switch to Rose Pine theme" })
end
if tokyonight_ok then
    vim.keymap.set("n", "<leader>tt", "<cmd>ThemeTokyoNight<CR>", { desc = "Switch to Tokyo Night theme" })
end