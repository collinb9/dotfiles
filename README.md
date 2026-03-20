# Dotfiles - Portable Configuration Management

Personal dotfiles repository for Linux development environment with Neovim, tmux, and terminal-based workflows. Includes enhanced setup with safety features, distribution support (Arch + Debian), and profile-based installation.

## Quick Start

### First-Time Installation

```bash
git clone git@github:collinb9/dotfiles ~/.dotfiles
chmod +x ~/.dotfiles/setup.sh
~/.dotfiles/setup.sh
```

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

## Usage

```
./setup.sh [minimal|full] [--skip-tools] [--skip-desktop] [--dry-run]
```

| Option           | Description                                              |
|------------------|----------------------------------------------------------|
| `full`           | Install all configurations and tools (default)           |
| `minimal`        | Install core configs only (shell, git, nvim)             |
| `--skip-tools`   | Skip additional tool installation (cargo, pipx, npm)     |
| `--skip-desktop` | Skip desktop/GUI configs (X11, window managers, terminals) |
| `--dry-run`      | Show what would be done without making changes           |

Options can be combined:

```bash
./setup.sh --skip-tools --skip-desktop
./setup.sh minimal --dry-run
```

## Installation Profiles

### Full Profile (Default)
```bash
~/.dotfiles/setup.sh
```
- Installs all configurations (nvim, tmux, zsh, git, alacritty, etc.)
- Installs additional development tools (via cargo, pipx, npm)
- Installs desktop/GUI configurations
- Recommended for personal desktops and workstations

### Minimal Profile
```bash
~/.dotfiles/setup.sh minimal
```
- Installs core configurations only (nvim, tmux, zsh, git, bin scripts, misc rc files)
- Still installs system packages via the package manager
- Skips development tool configs, desktop configs, and additional tools
- Recommended for VMs, cloud instances, and servers

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

### Tmux Prefix Key

```bash
# Tmux prefix key (single character combined with Ctrl)
# Examples: b (C-b), a (C-a), s (C-s)
TMUX_PREFIX_KEY="b"
```

On first run, setup.sh prompts interactively for the prefix key (pre-filled with `C-`). The choice is saved to `user.conf` and generates `~/.tmux.prefix.conf`, which tmux.conf sources. On subsequent runs the saved value is used without prompting.

### Desktop Environment

```bash
# Wallpaper path for .xinitrc and awesome window manager
WALLPAPER_PATH="$HOME/Pictures/wallpapers/arch.jpg"
```

The .xinitrc will automatically use this variable, or fall back to the default if not set.

## Supported Distributions

### Arch Linux
- Setup script detects Arch but assumes packages are managed by the user
- No automatic package installation

### Debian / Ubuntu
- Essential packages installed via apt from `config/packages/debian.txt`

The setup script auto-detects your distribution.

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

Before creating symbolic links, setup.sh automatically backs up existing files (that are not already symlinks) to a timestamped directory:

```
~/.dotfiles_backup_20250320_143000/
```

### Dry Run Mode

Preview what setup would do without making any changes:

```bash
~/.dotfiles/setup.sh --dry-run
```

Shows what symlinks, backups, package installs, and config files would be created. Tool installation (cargo, pipx, npm) is skipped entirely in dry-run mode.

## Configuration Structure

```
~/.dotfiles/
├── setup.sh                 # Main installation script
├── config/
│   ├── user.conf.example    # User customization template
│   └── packages/
│       ├── arch.txt         # Arch Linux package list
│       └── debian.txt       # Debian package list
├── .config/
│   ├── nvim/                # Neovim configuration (Lua)
│   ├── tmux/                # Tmux configuration
│   ├── zsh/                 # Zsh configuration
│   ├── ruff/                # Ruff (Python linter/formatter)
│   ├── bat/                 # Bat (cat replacement)
│   ├── curl/                # Curl configuration
│   ├── ranger/              # Ranger file manager
│   ├── htop/                # Htop process viewer
│   ├── opencode/            # Opencode AI platform
│   ├── uv/                  # uv (Python package manager)
│   ├── pylintrc             # Pylint configuration
│   ├── alacritty/           # Alacritty terminal emulator
│   ├── awesome/             # Awesome window manager
│   ├── picom/               # Picom compositor
│   ├── polybar/             # Polybar status bar
│   ├── rofi/                # Rofi application launcher
│   ├── gtk-3.0/             # GTK3 settings
│   └── stockfish_socket_client/
├── bin/                     # Custom executable scripts
├── .git_template/           # Git hooks and templates
├── .vim/                    # Vim configuration
├── .claude/                 # Claude Code agent config
├── .agents/                 # Agent skills
├── .pi/                     # Pi agent config
├── .omp/                    # Oh My Posh config
├── .zshrc                   # Zsh shell configuration
├── .gitconfig               # Git configuration
├── .inputrc                 # Readline configuration
├── .psqlrc                  # PostgreSQL client config
├── .cfnlintrc               # CloudFormation lint config
├── .screenrc                # Screen configuration
├── .xinitrc                 # X11 startup script
└── README.md                # This file
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
# Check key dotfiles links
ls -la ~/.config/nvim ~/.config/tmux ~/.zshrc ~/.gitconfig
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

### Change Tmux Prefix Key
1. Edit `config/user.conf`:
   ```bash
   TMUX_PREFIX_KEY="a"
   ```
2. Re-run setup to regenerate `~/.tmux.prefix.conf`:
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
