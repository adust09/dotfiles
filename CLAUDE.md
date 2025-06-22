# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Structure

This is a personal dotfiles repository that manages shell configuration, development tools, and system settings:

- `.zshrc` - Main zsh configuration that sources all files from `.zsh/` directory
- `.zsh/` - Modular zsh configuration files:
  - `fzf.zsh` - FZF integration with custom functions
  - `git.zsh` - Git aliases and FZF-integrated git functions  
  - `alias.zsh` - General command aliases
  - `oh-my-zsh.zsh` - Oh My Zsh configuration
  - `node.js.zsh` - Node.js related settings
  - `ascii-art.zsh` - Terminal art customization
- `config/Code/setting.json` - VS Code settings
- `plugins/` - Third-party tools and plugins:
  - `zsh-autocomplete/` - Zsh autocomplete plugin
  - `zsh-syntax-highlighting/` - Syntax highlighting for zsh
  - `fonts/` - Powerline fonts collection
  - `chatgpt-cli/` - ChatGPT command line interface
  - `circom/` - Circom zero-knowledge circuit compiler
- `memorybank/` - Memory management directory

## Common Commands

### Shell Configuration
- `zshreload` - Reload zsh configuration: `source ~/dotfiles/.zshrc`
- `zshconfig` - Open dotfiles in VS Code: `code ~/dotfiles`

### FZF-Enhanced Git Workflow
- `fgb()` - Interactive git branch checkout using fzf
- `fbr()` - Checkout git branch including remote branches with fzf
- `fshow()` - Interactive git commit browser with fzf
- `fstash()` - Interactive git stash browser with fzf
- `freset()` - Interactive git reset with commit selection
- `fdiff()` - Interactive file diff selector
- `fmerge()` - Interactive branch merge selector
- `frebase()` - Interactive rebase branch selector
- `select-git-branch-friendly` - Bound to Ctrl+B for inline branch selection

### FZF-Enhanced System Functions
- `fcd()` - Navigate to recent directories using cdr and fzf
- `fvim()` - Find and open files with vim using ripgrep and fzf
- `fh()` - Search and execute command history with fzf
- `fssh()` - Interactive SSH host selection from known_hosts
- `fev()` - Browse environment variables with fzf
- `fpkill()` - Interactive process killer with fzf
- `fbrave()` - Search Brave browser history with fzf

### Development Tools
- ChatGPT CLI: `chat` (alias for `cd ~/dotfiles/plugins/chatgpt-cli && python3 chatgpt.py`)
- Browser-use agent: `bu` (alias for interactive agent script)
- Go shortcuts: `gob` (build), `gor` (run), `got` (test), `gof` (fmt), `gov` (vet), `gom` (mod)

### Git Aliases
- `gbd` - Delete branch: `git branch -D`
- `gcb` - Create and checkout branch: `git checkout -b`
- `gcmm` - Commit with message: `git commit -m`
- `gtr` - Pretty git tree log with graph and colors
- `fgbd` - Delete multiple branches interactively with fzf

## Development Environment

### Language Support
- **Go**: GOROOT and GOPATH configured via Homebrew
- **Python**: pyenv configured for version management
- **Node.js**: NVM and nodebrew support configured
- **Rust**: Cargo bin directory in PATH
- **Ruby**: rbenv configured

### Package Managers
- Homebrew (macOS)
- Conda/Miniconda
- pyenv (Python)
- nvm/nodebrew (Node.js)
- rbenv (Ruby)
- Cargo (Rust)

### VS Code Configuration
Extensive language-specific formatting rules configured in `config/Code/setting.json`:
- TypeScript/JavaScript: Prettier with 2-space tabs
- Rust: rust-analyzer with format on save
- Go: Official Go formatter
- Python: Black formatter
- LaTeX: Workshop tools configured
- Markdown: Markdownlint

## Key Features

1. **Modular Configuration**: All zsh config split into logical files that are auto-sourced
2. **FZF Integration**: Extensive use of fzf for interactive command-line workflows
3. **Git-Centric Workflow**: Multiple FZF-enhanced git functions for branch management, history browsing, and interactive operations
4. **Multi-Language Development**: Configured for Go, Rust, Python, Node.js, TypeScript, LaTeX, and more
5. **Font Support**: Extensive collection of Powerline-compatible fonts
6. **Plugin Management**: Third-party zsh plugins for autocomplete and syntax highlighting