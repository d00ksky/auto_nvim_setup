-- Check if harpoon is available
local ok, harpoon = pcall(require, "harpoon")
if not ok then
    return
end

-- Setup harpoon
harpoon.setup({
    global_settings = {
        save_on_toggle = false,
        save_on_change = true,
        enter_on_sendcmd = false,
        tmux_autoclose_windows = false,
        excluded_filetypes = { "harpoon" },
        mark_branch = false,
    },
    projects = {
        -- Example project-specific config
        -- ["/path/to/project"] = {
        --     term = {
        --         cmds = {
        --             "npm run dev",
        --             "python manage.py runserver"
        --         }
        --     }
        -- }
    }
})

-- Quick access to harpoon mark operations
local mark = require("harpoon.mark")
local ui = require("harpoon.ui")

-- Custom function to show current harpoon marks in a nicer format
local function show_harpoon_marks()
    local marks = mark.get_all_marks()
    if #marks == 0 then
        vim.notify("No harpoon marks set", vim.log.levels.INFO)
        return
    end
    
    local mark_list = {}
    for i, mark_item in ipairs(marks) do
        table.insert(mark_list, string.format("%d: %s", i, mark_item.filename))
    end
    
    vim.notify("Harpoon marks:\n" .. table.concat(mark_list, "\n"), vim.log.levels.INFO)
end

-- Additional keymaps for enhanced harpoon usage
vim.keymap.set("n", "<leader>hh", show_harpoon_marks, { desc = "Show harpoon marks" })
vim.keymap.set("n", "<leader>hc", mark.clear_all, { desc = "Clear all harpoon marks" })
vim.keymap.set("n", "<leader>hr", mark.rm_file, { desc = "Remove current file from harpoon" })

-- Quick navigation to first 4 marks (already defined in remap.lua but ensuring they're here)
-- Note: These are also defined in remap.lua, but keeping them here for harpoon-specific organization