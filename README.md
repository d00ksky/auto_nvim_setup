# Perfect Neovim Setup!

Your one-script solution for the perfect Neovim development environment with intelligent tri-mode system and Claude Code integration.

## 🚀 Quick Start

1. **Clone and run:**
   ```bash
   git clone <your-repo-url>
   cd auto_nvim_setup
   ./setup.sh
   ```

2. **Go make coffee ☕**

3. **Come back to a perfectly configured Neovim!**

## ✨ Features

### 🎓 Tri-Mode System

Switch between three intelligent modes based on your workflow:

- **🎓 Learning Mode** (`<Space>ml`): Minimal LSP, no autocomplete, forces you to think
- **⚡ Development Mode** (`<Space>md`): Full LSP intelligence, autocomplete, diagnostics
- **🤖 Claude Mode** (`<Space>mc`): Optimized for Claude Code integration

### 🛠️ Language Support

- **Python** (Pyright LSP)
- **Go** (gopls LSP)  
- **JavaScript/TypeScript** (TypeScript Language Server)
- **Lua** (lua_ls LSP)
- **Rust** (rust_analyzer LSP)

### 🧭 File Navigation

- **Telescope** - Fuzzy finder for everything
- **Neo-tree** - Visual file explorer with git status
- **Harpoon** - Quick file bookmarking and switching

### 🎨 UI & Themes

- **Dark minimalistic** design
- **Rose Pine** (default) and **Tokyo Night** themes
- **Transparent backgrounds**
- **Informative status line** with git branch, mode, and diagnostics

## 📖 Keybinding Reference

### Mode Switching
| Key | Action |
|-----|--------|
| `<Space>ml` | Switch to Learning mode |
| `<Space>md` | Switch to Development mode |
| `<Space>mc` | Switch to Claude mode |

### File Navigation
| Key | Action |
|-----|--------|
| `<Space>ff` | Find files (git-aware) |
| `<Space>fg` | Live grep search |
| `<Space>fb` | Find buffers |
| `<Space>fr` | Recent files |
| `<Space>fc` | Find string under cursor |
| `<Space>e` | Toggle file explorer |
| `<Space>o` | Focus file explorer |

### Harpoon (Quick File Switching)
| Key | Action |
|-----|--------|
| `<Space>a` | Add file to harpoon |
| `<Ctrl>e` | Toggle harpoon menu |
| `<Ctrl>u` | Navigate to harpoon file 1 |
| `<Ctrl>i` | Navigate to harpoon file 2 |
| `<Ctrl>o` | Navigate to harpoon file 3 |
| `<Ctrl>p` | Navigate to harpoon file 4 |
| `<Space>hh` | Show harpoon marks |
| `<Space>hc` | Clear all harpoon marks |

### LSP (when enabled)
| Key | Action |
|-----|--------|
| `gd` | Go to definition |
| `K` | Hover documentation |
| `<Space>vd` | Show diagnostic |
| `]d` | Next diagnostic |
| `[d` | Previous diagnostic |
| `<Space>vca` | Code actions |
| `<Space>vrr` | Find references |
| `<Space>vrn` | Rename symbol |
| `<Ctrl>h` | Signature help (insert mode) |

### Git Integration
| Key | Action |
|-----|--------|
| `<Space>gs` | Git status |
| `<Space>gd` | Git diff |
| `<Space>gb` | Git blame |
| `<Space>gl` | Git log |
| `<Space>gp` | Git push |
| `<Space>gP` | Git pull |
| `<Space>gc` | Git commit |
| `<Space>ga` | Git add all |
| `<Space>gA` | Git add current file |

### Git Hunks (GitSigns)
| Key | Action |
|-----|--------|
| `]c` | Next hunk |
| `[c` | Previous hunk |
| `<Space>hs` | Stage hunk |
| `<Space>hr` | Reset hunk |
| `<Space>hp` | Preview hunk |
| `<Space>hb` | Blame line |
| `<Space>tb` | Toggle line blame |

### Claude Code Integration
| Key | Action |
|-----|--------|
| `<Space>cc` | Activate Claude Code mode |
| `<Space>cp` | Copy file path to clipboard |
| `<Space>cf` | Copy file content to clipboard |
| `<Space>cs` | Copy selection to clipboard (visual mode) |
| `<Space>ctx` | Copy project context to clipboard |
| `<Space>ct` | Open Claude terminal |

### Utilities
| Key | Action |
|-----|--------|
| `<Space>u` | Toggle undo tree |
| `<Space>tt` | Toggle trouble diagnostics |
| `<Space>zz` | Toggle zen mode |
| `<Space>t` | Toggle terminal |
| `<Space>f` | Format buffer |

### Text Editing
| Key | Action |
|-----|--------|
| `J/K` (visual) | Move selection up/down |
| `<Ctrl>d/<Ctrl>u` | Scroll half-page (centered) |
| `n/N` | Next/previous search (centered) |
| `<Space>p` | Paste without losing register |
| `<Space>y` | Yank to system clipboard |
| `<Space>d` | Delete to void register |
| `<Space>s` | Search and replace word under cursor |

### Documentation
| Key | Action |
|-----|--------|
| `<Space>nf` | Generate function docs |
| `<Space>nc` | Generate class docs |
| `<Space>nt` | Generate type docs |
| `<Space>nF` | Generate file docs |

### Themes
| Key | Action |
|-----|--------|
| `<Space>tr` | Switch to Rose Pine theme |
| `<Space>tt` | Switch to Tokyo Night theme |

## 🔄 Claude Code Workflow

### Perfect Symbiotic Development

1. **Learning New Language:**
   - Start in Learning Mode (`<Space>ml`)
   - When stuck → Claude Mode (`<Space>mc`)
   - Ask Claude for help → Copy context (`<Space>ctx`)
   - Return to Learning Mode to implement

2. **Development Work:**
   - Use Development Mode (`<Space>md`) for full intelligence
   - Complex refactoring → Claude Mode for discussion
   - Quick context sharing with `<Space>cp`, `<Space>cf`, `<Space>cs`

3. **Quick Context Sharing:**
   - `<Space>ctx` - Get project overview for Claude
   - `<Space>cf` - Share current file with Claude
   - `<Space>cs` - Share selected code with Claude

## 🎯 Mode Behaviors

### 🎓 Learning Mode
- ❌ No autocomplete
- ❌ No LSP hover/diagnostics
- ❌ No formatting
- ✅ Syntax highlighting only
- Perfect for learning without crutches

### ⚡ Development Mode
- ✅ Full LSP intelligence
- ✅ Autocomplete
- ✅ Diagnostics and error highlighting
- ✅ Auto-formatting
- ✅ Git integration
- Maximum productivity

### 🤖 Claude Mode
- ✅ LSP enabled (but less intrusive)
- ❌ No autocomplete (cleaner for Claude interaction)
- ✅ Git integration
- ✅ Optimized terminal layout
- Perfect for Claude Code collaboration

## 🔧 Customization

### Adding New Languages

1. Edit `nvim/after/plugin/lsp.lua`
2. Add your language server to `ensure_installed`
3. Add custom configuration in handlers

### Adding New Plugins

1. Add plugin to `nvim/lua/d00ksky/packer.lua`
2. Create configuration in `nvim/after/plugin/`
3. Run `:PackerSync`

### Mode Customization

Edit `nvim/lua/d00ksky/modes.lua` to adjust mode behaviors.

## 📋 Requirements

### Automatic Installation
The setup script installs everything automatically:

- **Neovim 0.8+**
- **Node.js & npm** (for language servers)
- **Python 3 & pip** (for Python development)
- **Go** (for Go development)
- **Git** (for version control)
- **Build tools** (gcc, make, etc.)
- **Clipboard support** (xclip)

### Manual Dependencies (if setup fails)
```bash
# Ubuntu/Debian
sudo apt install git curl build-essential unzip nodejs npm python3 python3-pip golang-go xclip

# Fedora
sudo dnf install git curl gcc gcc-c++ make unzip nodejs npm python3 python3-pip golang xclip

# Arch Linux
sudo pacman -S git curl base-devel unzip nodejs npm python python-pip go xclip
```

## 🐧 Linux & WSL Compatibility

- ✅ **Ubuntu/Debian** (apt)
- ✅ **Fedora** (dnf) 
- ✅ **RHEL/CentOS** (yum)
- ✅ **Arch Linux** (pacman)
- ✅ **WSL 1 & 2** (with Windows clipboard integration)

## 🎨 Status Line Information

Your status line shows:
- **Current mode** (Learning/Development/Claude)
- **Git branch** with diff stats
- **File path** and modification status
- **LSP diagnostics** count
- **Line/column position** with relative positioning
- **Progress** through file

## 🔍 Included Plugins

### Core
- **Packer** - Plugin manager
- **Plenary** - Lua utilities

### Navigation
- **Telescope** - Fuzzy finder
- **Neo-tree** - File explorer
- **Harpoon** - Quick file switching

### LSP & Completion
- **LSP-Zero** - LSP configuration
- **Mason** - LSP installer
- **nvim-cmp** - Autocompletion
- **LuaSnip** - Snippets

### Git
- **Fugitive** - Git commands
- **GitSigns** - Git decorations

### UI
- **Rose Pine** - Color scheme
- **Tokyo Night** - Alternative color scheme
- **Lualine** - Status line
- **TreeSitter** - Syntax highlighting

### Utilities
- **UndoTree** - Visual undo history
- **Trouble** - Diagnostics panel
- **Zen Mode** - Distraction-free writing
- **ToggleTerm** - Terminal integration
- **Cloak** - Hide sensitive information
- **Neogen** - Documentation generator

## 🆘 Troubleshooting

The setup script now includes automatic fixes for common issues, but here are manual solutions if needed:

### Mason Package Errors
**Issue**: "Cannot find package tsserver" or similar errors  
**Solution**: Already fixed in setup script! If you see this:
```bash
# In Neovim
:MasonTroubleshoot
# OR manually install with correct names:
:MasonInstall pyright gopls typescript-language-server lua-language-server rust-analyzer
```

### Python LSP Installation Issues
**Issue**: "externally-managed-environment" errors  
**Solution**: Script now handles this automatically by using system packages first:
```bash
# Manual fix if needed:
sudo apt install python3-pylsp  # Ubuntu/Debian
# OR
pip3 install --user python-lsp-server --break-system-packages
```

### Rust Toolchain Issues
**Issue**: "rustup could not choose a version of cargo to run"  
**Solution**: Fixed automatically in script, manual fix:
```bash
rustup default stable
```

### Neo-tree Migration Warnings
**Issue**: Neo-tree showing migration/deprecation warnings  
**Solution**: Fixed automatically in script with warning suppression

### Plugin Issues
```bash
# In Neovim
:PackerClean
:PackerSync
```

### LSP Issues
```bash
# In Neovim
:Mason
# Language servers install automatically when you open relevant files
```

### Permission Issues
```bash
chmod +x setup.sh
```

### WSL Clipboard Issues
Ensure Windows is in PATH:
```bash
echo $PATH | grep -q "/mnt/c/Windows/System32" || echo 'export PATH="$PATH:/mnt/c/Windows/System32"' >> ~/.bashrc
```

### Complete Reset (if all else fails)
```bash
# Use the included fix scripts:
./fix_setup_issues.sh    # Fix common setup problems
./fix_neotree.sh         # Fix Neo-tree warnings
./reset_mason.sh         # Reset Mason completely

# Or manual cleanup:
rm -rf ~/.config/nvim ~/.cache/nvim ~/.local/share/nvim
./setup.sh  # Re-run setup
```

## 📝 License

MIT License - feel free to customize and share!

---

**Happy coding! 🚀**

*Now go make some coffee and enjoy your perfectly configured Neovim setup!*
