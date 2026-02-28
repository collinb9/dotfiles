# Agent Guidelines for .dotfiles Repository

This document provides comprehensive guidelines for agentic coding agents working in this dotfiles repository.

## Repository Overview

This is a personal dotfiles configuration repository for a Linux development environment, primarily focused on terminal-based workflows with Neovim, tmux, and various development tools. It's not a traditional software project but a configuration management system.

## Setup and Installation

### Initial Setup
```bash
# Clone and setup dotfiles
git clone <repo-url> ~/.dotfiles
cd ~/.dotfiles
chmod +x setup.sh
./setup.sh  # Full profile (default) - installs all configurations and packages
```

**Safety Features:**
- **Automatic Backups**: All existing configurations backed up with timestamps before any changes
- **Idempotent**: Safe to run multiple times; won't recreate existing symbolic links
- **Error Handling**: Strict error checking (`set -euo pipefail`) prevents partial installations
- **Distribution Detection**: Auto-detects Arch Linux or Debian/Ubuntu and installs appropriate packages

### Installation Profiles

The setup script supports different installation profiles for various environments:

**Full Profile (Default)**
```bash
~/.dotfiles/setup.sh
```
- Installs all configurations (nvim, tmux, zsh, git, alacritty, etc.)
- Installs complete package list (LSP servers, development tools, utilities)
- Recommended for personal desktops and workstations

**Minimal Profile**
```bash
~/.dotfiles/setup.sh --profile minimal
```
- Installs only essential configurations
- Skips package installation
- Recommended for VMs, cloud instances, and resource-constrained systems

### User Customization

Customize your dotfiles without modifying core files using `config/user.conf`:

```bash
# 1. Copy the example configuration
cp ~/.dotfiles/config/user.conf.example ~/.dotfiles/config/user.conf

# 2. Edit with your personal settings
$EDITOR ~/.dotfiles/config/user.conf

# 3. Re-run setup to apply changes
~/.dotfiles/setup.sh
```

**Customizable Settings:**
- Git email addresses (personal and work)
- Work directory path for conditional git configuration
- Wallpaper path for X11 and window manager
- Other environment-specific variables

**Reference:** See README.md for comprehensive customization documentation

### Directory Structure
```
~/.dotfiles/
├── .config/          # XDG config directory
│   ├── nvim/        # Neovim Lua configuration
│   ├── tmux/        # Terminal multiplexer config
│   ├── alacritty/   # Terminal emulator config
│   └── [tools]/     # Various tool configurations
├── bin/             # Custom executable scripts
├── .git_template/   # Git hooks and templates
└── [rc files]       # Shell and tool configurations
```

## Build, Test, and Lint Commands

Since this is a dotfiles repository, traditional build/test commands don't apply. Instead:

### Configuration Validation
```bash
# Validate Python scripts with Pylint
pylint bin/aws_access_key_rotation.py
pylint bin/sam_workflow.py

# Validate CloudFormation templates (if any)
cfn-lint template.yml

# Test Neovim configuration
nvim --headless -c "checkhealth" -c "qa"

# Validate shell scripts
shellcheck bin/*.sh

# Format Python files
black --line-length 79 bin/*.py

# Format Lua files
stylua .config/nvim/
```

### Setup Testing
```bash
# Test symbolic link creation (dry run)
./setup.sh  # Review output for any errors

# Verify git configuration
git config --list

# Test zsh configuration
zsh -c "source ~/.zshrc && echo 'Config loaded successfully'"
```

## Code Style Guidelines

### Python (`bin/*.py`)

#### Naming Conventions
- **Variables/Functions**: `snake_case` (enforced by Pylint)
- **Classes**: `PascalCase`
- **Constants**: `UPPER_CASE`
- **Private/Protected**: Leading underscore `_private_method`

#### Formatting
- **Line Length**: 79 characters (Black formatter)
- **Indentation**: 4 spaces
- **String Quotes**: Double quotes for strings, single for characters
- **Import Order**: Standard library, third-party, local imports

#### Error Handling
```python
# Preferred error handling
try:
    result = risky_operation()
except SpecificException as e:
    logger.error(f"Operation failed: {e}")
    raise
```

### Lua (Neovim Configuration)

#### Naming Conventions
- **Variables**: `snake_case`
- **Functions**: `snake_case`
- **Tables**: `snake_case` for data, `PascalCase` for modules
- **Constants**: `UPPER_CASE`

#### Formatting
- **Indentation**: 2 spaces
- **Table formatting**: Trailing commas encouraged
- **String quotes**: Double quotes preferred

```lua
-- Good table structure
local config = {
  option = "value",
  nested = {
    key = true,
    list = { "item1", "item2" },
  },
}
```

### Shell Scripts (`bin/*.sh`)

#### Style
- **Shebang**: `#!/bin/bash` or `#!/bin/zsh`
- **Variables**: `UPPER_CASE` for constants, `lower_case` for locals
- **Quoting**: Always quote variables: `"$variable"`
- **Functions**: `snake_case`

```bash
#!/bin/bash
set -euo pipefail  # Strict error handling

readonly SCRIPT_DIR="$(dirname "$0")"
local_var="value"

function process_files() {
    local input_dir="$1"
    # Implementation
}
```

### CloudFormation Templates

#### File Detection
- Files are auto-detected as CloudFormation if they contain AWS resource types
- Custom file type: `*.cloudformation`

#### Linting
- Uses `cfn-lint` with custom rules in `.cfnlintrc`
- Ignores W3002 (hardcoded partition warnings)

#### Style
- **Resources**: PascalCase names
- **Parameters**: PascalCase with descriptive names
- **Outputs**: PascalCase, prefixed with stack purpose

## Git Workflow

### Branch Strategy
- **Main**: `main` branch for stable configurations
- **Feature**: `feature/description` for new configurations
- **Hotfix**: `hotfix/issue` for urgent fixes

### Commit Guidelines
```bash
# Good commit messages
git commit -m "nvim: add LSP configuration for Python development"
git commit -m "zsh: update aliases for better git workflow"
git commit -m "tmux: fix session restoration keybinding"

# Commit format: [component]: [description]
# Components: nvim, tmux, zsh, git, alacritty, bin, setup
```

### Worktree Usage
```bash
# Use git worktrees for parallel work
git worktree add ../dotfiles-feature feature/new-config
```

## File Organization Principles

### Configuration Files
- Use XDG Base Directory specification
- Modular configurations (separate files for different features)
- Environment-specific configs (work vs personal git settings)

### Scripts (`bin/`)
- Executable scripts for automation
- Proper shebang and error handling
- Documentation comments for complex logic

### Symbolic Links
- All configurations linked via `setup.sh`
- Use absolute paths for reliability
- Include cleanup before creating new links

## Development Environment Integration

### Neovim as Primary Editor
- LSP servers: bash-language-server, pylsp, lua-language-server
- Auto-completion via nvim-cmp
- Formatting on save via conform.nvim
- Linting via nvim-lint

### Terminal Workflow
- **Terminal**: Alacritty with tmux integration
- **Multiplexing**: tmux for session management
- **Shell**: Zsh with oh-my-zsh framework

### AI Integration
- GitHub Copilot enabled in Neovim
- OpenCode AI plugin configured
- CodeCompanion for AI-assisted development

## Testing and Validation

### Configuration Testing
```bash
# Test Neovim startup
nvim --startuptime startup.log +q && cat startup.log

# Validate tmux configuration
tmux source-file ~/.config/tmux/tmux.conf

# Test shell configuration
zsh -c "source ~/.zshrc && echo 'Success'"
```

### Link Verification
```bash
# Check all symbolic links
find ~ -maxdepth 2 -type l -exec ls -la {} \;

# Verify git configuration
git config --get-regexp 'user|core|push'
```

## Common Patterns and Anti-Patterns

###  Good Practices
- Modular configuration files
- Environment-specific settings (work/personal git configs)
- Proper error handling in scripts
- XDG-compliant directory structure
- Version-controlled configurations

###  Avoid
- Hardcoded absolute paths (except in setup.sh)
- Mixing personal and work configurations
- Committing sensitive information
- Breaking existing symbolic links without cleanup
- Platform-specific configurations without guards

## Troubleshooting

### Common Issues
1. **Broken symlinks**: Re-run `setup.sh`
2. **Git config conflicts**: Check conditional includes in `.gitconfig`
3. **Neovim errors**: Check `:checkhealth` and plugin status
4. **Terminal issues**: Verify Alacritty and tmux configurations
5. **Shell problems**: Check `.zshrc` and oh-my-zsh status

### Debugging Commands
```bash
# Check symlink status
ls -la ~/.config/nvim ~/.tmux.conf ~/.zshrc

# Verify git configuration
git config --list --show-origin

# Test Neovim health
nvim +checkhealth +qa

# Debug shell startup
zsh -x -c "source ~/.zshrc"
```

## Additional Notes

- This repository is optimized for Linux environments, particularly Arch Linux
- CloudFormation development is specially supported with custom file type detection
- Python development follows strict Pylint rules with 79-character line limits
- AWS development includes access key rotation and SAM workflow automation
- All configurations are designed for terminal-first development workflows