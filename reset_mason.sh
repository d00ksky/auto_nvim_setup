#!/bin/bash

# Reset Mason auto-installation and clear cache
echo "🔧 Resetting Mason configuration..."

# Remove the auto-install marker
rm -f ~/.local/share/nvim/mason_auto_installed

# Remove any cached Neovim configuration
rm -rf ~/.cache/nvim

# Remove compiled Packer file to force recompilation
rm -f ~/.config/nvim/plugin/packer_compiled.lua

echo "✅ Mason reset complete!"
echo "ℹ  Restart Neovim to apply the updated configuration"
echo "ℹ  Language servers will install with correct names (ts_ls instead of tsserver)"