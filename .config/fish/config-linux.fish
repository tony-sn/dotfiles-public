# =============================================================================
# 1. Environment & AI Agent Configuration
# =============================================================================
set -gx GOPATH $HOME/go
set -gx EDITOR nvim

# Keep user shell as fish for interactive sessions, while routing Claude Code specifically to bash
if test -x /usr/bin/fish
    set -gx SHELL /usr/bin/fish
else if test -x /bin/fish
    set -gx SHELL /bin/fish
end
set -gx CLAUDE_CODE_SHELL /usr/bin/bash

# Prevent build tools and interactive pagers from hanging background / AI agent executions
set -gx MSBUILDDISABLENODEREUSE 1
set -gx DOTNET_CLI_TELEMETRY_OPTOUT 1
set -gx PAGER cat

# Nemoclaw opt-in
set -gx NEMOCLAW_ACCEPT_EXPERIMENTAL_OPENSHELL_UPGRADE 1
set -gx NEMOCLAW_CONFIRM_LEGACY_MANAGED_RECREATE '["titan-nemoclaw"]'

# API Keys & Secrets live in config-local.fish (gitignored)

# Terminal Colors
set -gx COLORTERM truecolor

# =============================================================================
# 2. GUI & Wayland Configuration
# =============================================================================
set -gx GDK_BACKEND wayland,x11
set -gx QT_QPA_PLATFORM "wayland;xcb"
set -gx MOZ_ENABLE_WAYLAND 1
set -gx ELECTRON_OZONE_PLATFORM_HINT auto
set -gx QT_AUTO_SCREEN_SCALE_FACTOR 1

# =============================================================================
# 3. Toolchains & Package Managers
# =============================================================================
# User binaries, toolchains & Linuxbrew
fish_add_path -g /usr/local/go/bin ~/.local/share/bob/nvim-bin ~/.local/bin /home/linuxbrew/.linuxbrew/bin

# =============================================================================
# 4. WSL Windows Interop & PATH Resolution
# =============================================================================
# Append specific Windows tools without blocking cross-OS stat/9P calls
for win_path in /mnt/c/WINDOWS/system32 /mnt/c/WINDOWS "/mnt/c/Users/tonys/AppData/Local/Programs/Microsoft VS Code/bin" "/mnt/c/Users/tonys/AppData/Local/Programs/Antigravity IDE/bin" /mnt/c/Users/tonys/scoop/shims
    if not contains -- "$win_path" $PATH
        set -ga PATH "$win_path"
    end
end

# Clean and deduplicate PATH (removes duplicates, dead paths, and enforces User -> System -> Windows precedence)
# Note: Skips test -d on /mnt/* to prevent slow 9P/drvfs cross-OS stat hangs in WSL
function _dedup_path
    set -l user_paths
    set -l system_paths
    set -l windows_paths
    set -l seen_dirs

    for dir in $PATH
        test -z "$dir"; and continue
        if not string match -q "/mnt/*" -- "$dir"
            test -d "$dir"; or continue
        end
        contains -- "$dir" $seen_dirs; and continue

        # Filter out canonical symlink duplicates, empty game dirs, and redundant one-off dirs
        if test "$dir" = "/sbin" -o "$dir" = "/bin" -o "$dir" = "/usr/games" -o "$dir" = "/usr/local/games"
            continue
        end
        if string match -qr "\.(lmstudio|opencode|resend)/bin" -- "$dir"
            continue
        end
        if string match -qr "\.local/share/mise/installs/" -- "$dir"
            continue
        end

        set -a seen_dirs "$dir"

        if string match -q "/mnt/c/*" -- "$dir"
            set -a windows_paths "$dir"
        else if string match -q "/usr/*" -- "$dir"; or string match -q "/lib/*" -- "$dir"
            set -a system_paths "$dir"
        else
            set -a user_paths "$dir"
        end
    end
    set -gx PATH $user_paths $system_paths $windows_paths
end
_dedup_path
functions -e _dedup_path

# Mise toolchain (activated in shims mode for minimal, clean PATH)
if command -q mise
    mise activate fish --shims | source
end

# =============================================================================
# 5. Interactive Shell Settings, Aliases & Prompts
# =============================================================================
if status is-interactive
    # Theme configuration
    set -g theme_color_scheme terminal-dark
    set -g fish_prompt_pwd_dir_length 1
    set -g theme_display_user yes
    set -g theme_hide_hostname no
    set -g theme_hostname always

    # Core aliases
    alias ls "ls -p -G"
    alias la "ls -A"
    alias ll "ls -l"
    alias lla "ll -A"
    alias g git
    alias c claude
    alias claude-yolo "claude --dangerously-skip-permissions"
    command -qv nvim; and alias vim nvim
    alias neovide "neovide.exe --wsl"
    alias zed "/mnt/c/Users/tonys/AppData/Local/Programs/Zed/bin/Zed.exe"

    # Modern CLI tool aliases
    if type -q eza
        alias ll "eza -l -g --icons"
        alias lla "ll -a"
    end

    alias lg lazygit
    alias mux tmuxinator
    alias pn pnpm
    alias tm tmux
    alias tmks "tmux kill-server"
    alias open xdg-open
    alias oc openclaw
    alias ollc "ollama launch claude --model gemma4-26b-dev"

    # Only downgrade prompt for automated headless AI agent execution, NOT interactive user terminals
    function _is_headless_agent
        test -n "$ANTIGRAVITY_AGENT"; and return 0
        test -n "$AI_AGENT"; and return 0
        test "$TERM" = "dumb"; and return 0
        return 1
    end

    if _is_headless_agent
        set -gx TERM dumb
        set -gx PAGER cat
        function fish_prompt
            echo -n "$PWD \$ "
        end
        function fish_right_prompt; end
        function fish_mode_prompt; end
    else
        # Starship prompt & zoxide for interactive user terminals (both WSL & IDE)
        type -q starship; and starship init fish | source
        type -q zoxide; and zoxide init fish | source
    end
end
