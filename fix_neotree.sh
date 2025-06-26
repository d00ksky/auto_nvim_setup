#!/bin/bash

# Fix Neo-tree migration warnings
echo "🌳 Fixing Neo-tree migration warnings..."

# Remove any cached Neo-tree state
rm -rf ~/.cache/nvim
rm -rf ~/.local/state/nvim
rm -rf ~/.local/share/nvim/neo-tree

# Remove packer compiled to force reload
rm -f ~/.config/nvim/plugin/packer_compiled.lua

echo "✅ Neo-tree migration issues fixed!"
echo "ℹ  Restart Neovim to apply the changes"
echo "ℹ  Migration warnings should now be suppressed"