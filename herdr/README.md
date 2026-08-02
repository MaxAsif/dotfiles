# Herdr

Terminal multiplexer with tmux-like keybindings.

Herdr is a modern terminal multiplexer that organizes terminals into:
- **Workspaces** - similar to tmux sessions
- **Tabs** - similar to tmux windows  
- **Panes** - split panes within tabs
- **Floating popups** - scratch terminals that overlay without changing the layout

## Installation

```bash
# Install herdr (exact method depends on your system)
# For Fedora:
sudo dnf install herdr

# For other systems, check: https://github.com/hderms/herdr

# Copy the configuration
cp config.toml ~/.config/herdr/config.toml
```

## Configuration

The `config.toml` provides tmux-like keybindings:

- **Prefix**: `Ctrl+Space` (instead of tmux's `Ctrl+B`)
- **Split horizontal** (top/bottom): `Prefix + -`
- **Split vertical** (left/right): `Prefix + v`
- **Navigate panes**: `Prefix + h/j/k/l` (vi-style)
- **New tab**: `Prefix + c`
- **Next tab**: `Prefix + n`
- **Floating scratch**: `Prefix + p`
- **Reload config**: `Prefix + Shift + R`

## Usage

See `config.toml` for the complete keymap and customization options.
