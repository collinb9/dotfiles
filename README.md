# Dotfiles - Portable Configuration Management

Personal dotfiles repository for Linux development environment with Neovim, tmux, and terminal-based workflows. Includes enhanced setup with safety features, distribution support (Arch + Debian), and profile-based installation.

## Quick Start

### First-Time Installation

```bash
git clone git@github:collinb9/dotfiles ~/.dotfiles
chmod +x ~/.dotfiles/setup.sh
~/.dotfiles/setup.sh
```

**Important:** Back up existing dot files before running setup, as files with matching names will be replaced.

### Customization

1. Copy the example user configuration:
```bash
cp ~/.dotfiles/config/user.conf.example ~/.dotfiles/config/user.conf
```

2. Edit your personal settings:
```bash
$EDITOR ~/.dotfiles/config/user.conf
```

3. Re-run setup to apply changes:
```bash
~/.dotfiles/setup.sh
```

## Installation Profiles

The setup script supports different profiles for various environments:

### Full Profile (Default)
```bash
~/.dotfiles/setup.sh
```
- Installs all configurations (nvim, tmux, zsh, git, alacritty, etc.)
- Installs full package list (LSP servers, development tools, utilities)
- Recommended for personal desktops and workstations

### Minimal Profile
```bash
~/.dotfiles/setup.sh --profile minimal
```
- Installs only essential configurations
- Skips package installation
- Recommended for VMs, cloud instances, and systems with limited resources

## User Customization

The `config/user.conf` file allows customization without modifying core dotfiles:

### Git Configuration

```bash
# Personal git email (used in default .gitconfig)
GIT_PERSONAL_EMAIL="your.email@example.com"

# Work git email (used in work .gitconfig)
GIT_WORK_EMAIL="work.email@company.com"

# Work directory path for conditional git config
GIT_WORK_DIR="$HOME/Work"
```

**Note:** Git does not support shell variable expansion in `includeIf` paths. After running setup, you must manually update your `.gitconfig` with the full path to your work directory:

```ini
[includeIf "gitdir:/home/user/Work/"]
    path = ~/.dotfiles/git/work.gitconfig
```

### Desktop Environment

```bash
# Wallpaper path for .xinitrc and awesome window manager
WALLPAPER_PATH="$HOME/Pictures/wallpapers/arch.jpg"
```

The .xinitrc will automatically use this variable, or fall back to the default if not set.

## Supported Distributions

### Arch Linux
- Full package management via pacman
- Optional AUR helper support
- Complete development tool stack

### Debian / Ubuntu
- Essential packages via apt
- Basic development tools and utilities
- Compatible with latest stable releases

The setup script auto-detects your distribution and installs appropriate packages.

## Tool Installation

The setup script automatically installs additional development tools beyond system packages when using the **full profile**:

### Rust-based Tools (via cargo)

- **uv**: Fast Python package manager
- **cfn-lsp-extra**: CloudFormation Language Server
- **stylua**: Lua code formatter
- **tombi**: TOML formatter/linter

If Rust/cargo is not installed, setup.sh will automatically install rustup.

### Python Tools (via pipx)

- **cfn-lint**: CloudFormation template linter
- **beautysh**: Shell script formatter
- **ruff**: Python linter/formatter (Debian fallback if not in system packages)

These are installed in isolated environments via pipx to avoid conflicts.

### Node.js Tools (via npm)

- **mcp-hub**: Model Context Protocol hub (required for nvim MCP integration)
- **prettierd**: Fast Prettier daemon for code formatting
- **eslint_d**: Fast ESLint daemon for linting

Requires Node.js/npm to be installed (included in system package lists).

### Neovim Plugin Dependencies

- **opencode**: AI platform plugins installed via npm in `.config/opencode/`

### Skipping Tool Installation

To skip additional tool installation and only install system packages + configs:

```bash
./setup.sh --skip-tools
```

Or for minimal profile (no additional tools by default):

```bash
./setup.sh minimal
```

### Manual Tool Installation

If you need to install tools manually later:

```bash
# Rust tools (after installing rustup)
cargo install uv cfn-lsp-extra stylua tombi

# Python tools
pipx install cfn-lint beautysh ruff

# Node.js tools
npm install -g mcp-hub prettierd eslint_d

# opencode dependencies
cd ~/.config/opencode && npm install
```

## Safety Features

### Automatic Backups

Before creating symbolic links, setup.sh automatically backs up existing configurations:

```
~/.dotfiles/.backups/
  ├── nvim/
  ├── tmux/
  ├── alacritty/
  ├── .zshrc
  ├── .gitconfig
  └── [other configs]
```

All backups are timestamped and preserved. Original files are never deleted without a backup.

### Dry Run Mode

Test the setup without making changes:

```bash
~/.dotfiles/setup.sh --dry-run
```

This shows what symbolic links would be created without actually creating them.

## Configuration Structure

```
~/.dotfiles/
├── setup.sh                 # Main installation script
├── config/
│   ├── user.conf.example   # User customization template
│   └── packages/
│       ├── arch.txt        # Arch Linux package list
│       └── debian.txt      # Debian package list
├── .config/
│   ├── nvim/               # Neovim configuration (Lua)
│   ├── tmux/               # Tmux configuration
│   └── alacritty/          # Alacritty terminal emulator config
├── bin/                    # Custom executable scripts
├── .git_template/          # Git hooks and templates
├── .xinitrc               # X11 startup script
├── .zshrc                 # Zsh shell configuration
├── .gitconfig             # Git configuration
└── README.md              # This file
```

## Migration from Old Setup

If you have an existing dotfiles setup, the new system is backward compatible:

1. **Backups are automatic** - Your current configurations are safely backed up
2. **Gradual adoption** - The setup preserves your existing behavior if you don't customize user.conf
3. **Custom variables** - Add customization to user.conf without modifying tracked files
4. **Git worktrees** - You can still use git worktrees for parallel work on features:
   ```bash
   git worktree add ../dotfiles-feature feature/new-config
   ```

## Validation Commands

### Test Configuration Startup
```bash
# Neovim health check
nvim --headless -c "checkhealth" -c "qa"

# Tmux configuration test
tmux source-file ~/.config/tmux/tmux.conf

# Zsh configuration test
zsh -c "source ~/.zshrc && echo 'Config loaded successfully'"
```

### Verify Symbolic Links
```bash
# Check all dotfiles links
ls -la ~/.config/nvim ~/.tmux.conf ~/.zshrc
```

### Lint and Format
```bash
# Python scripts
ruff check bin/*.py
ruff format bin/*.py

# Lua configuration
stylua .config/nvim/

# Shell scripts
shellcheck bin/*.sh
```

## Common Tasks

### Change Wallpaper
1. Edit `config/user.conf`:
   ```bash
   WALLPAPER_PATH="$HOME/Pictures/wallpapers/my-wallpaper.jpg"
   ```
2. Re-run setup:
   ```bash
   ~/.dotfiles/setup.sh
   ```

### Update Git Configuration
1. Edit `config/user.conf` with your email addresses
2. Update the work directory path in `.gitconfig` if needed
3. Re-run setup:
   ```bash
   ~/.dotfiles/setup.sh
   ```

### Add New Configuration
1. Add the file to the appropriate directory in `~/.dotfiles`
2. Update `setup.sh` with the new symbolic link
3. Document it in this README
4. Commit and push

## Troubleshooting

### Broken Symbolic Links
Re-run the setup script to repair broken links:
```bash
~/.dotfiles/setup.sh
```

### Configuration Not Applying
1. Verify user.conf exists and is correctly sourced
2. Re-run setup script
3. Reload shell: `exec $SHELL`

### Package Installation Failures
- **Arch**: Ensure pacman is available: `which pacman`
- **Debian**: Ensure apt is available: `which apt`
- **Custom systems**: Manually install packages from config/packages/

### Distribution Detection
The setup script auto-detects your distribution. To check:
```bash
cat /etc/os-release
```

## Development Notes

- Repository uses XDG Base Directory specification
- Modular configuration files for maintainability
- Environment-specific settings (work vs. personal)
- All scripts include proper error handling (set -euo pipefail)
- Git worktrees recommended for parallel feature development

## Contributing

When making changes to dotfiles:

1. Test on target distribution
2. Update user.conf.example if adding new variables
3. Follow code style guidelines (Python: PEP 8, Lua: 2-space indent)
4. Backup before testing destructive operations
5. Commit with descriptive messages: `git commit -m "component: description"`

Example commit messages:
- `nvim: add LSP configuration for Python development`
- `zsh: update aliases for better git workflow`
- `tmux: fix session restoration keybinding`
- `setup: add safety features and backup mechanism`

## License

Personal configuration. Use, modify, and distribute as needed for your own setup.
