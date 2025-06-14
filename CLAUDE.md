# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Structure

This is a Neovim configuration repository with a modular Lua-based setup:

- `nvim/init.lua`: Entry point that loads the main d00ksky module
- `nvim/lua/d00ksky/`: Core configuration modules
  - `init.lua`: Loads remaps and settings
  - `packer.lua`: Plugin management using Packer
  - `remap.lua`: Custom key bindings with space as leader
  - `set.lua`: Neovim options and settings
- `nvim/after/plugin/`: Plugin-specific configurations that load after plugins
- `nvim/plugin/packer_compiled.lua`: Auto-generated Packer compilation file

## Plugin Architecture

The configuration uses Packer for plugin management with a two-stage loading system:
1. Plugins are declared in `lua/d00ksky/packer.lua`
2. Plugin configurations are in `after/plugin/` files (loaded after plugin installation)

Key plugin categories:
- **LSP Stack**: lsp-zero + mason + nvim-cmp for language server integration
- **Navigation**: Telescope (fuzzy finder) + Harpoon (quick file switching)
- **Code Intelligence**: TreeSitter (syntax) + Neogen (docs) + LuaSnip (snippets)
- **Development Tools**: Fugitive (git), Trouble (diagnostics), UndoTree (history)
- **Themes**: Rose Pine (default) + Tokyo Night with transparency support

## Development Commands

### Plugin Management
```lua
-- In Neovim command mode:
:PackerSync    -- Install/update plugins
:PackerCompile -- Recompile plugin configuration
```

### Language Server Management
```lua
-- Mason LSP installer:
:Mason         -- Open Mason interface
:MasonInstall  -- Install specific language servers
```

The configuration includes language servers for TypeScript, Rust, and Lua with auto-completion and diagnostics.

## Configuration Conventions

- Leader key is set to space (`" "`)
- Uses 4-space indentation with `expandtab`
- Plugin configurations follow the pattern: declare in `packer.lua`, configure in `after/plugin/`
- Key bindings use leader prefix for custom commands (e.g., `<leader>ff` for file finding)
- LSP bindings follow standard conventions (gd for go-to-definition, K for hover)

## Security Features

The Cloak plugin is configured to hide sensitive information in:
- `.env` files (environment variables)
- `wrangler.toml` (Cloudflare Workers secrets)
- Other files containing passwords or API keys