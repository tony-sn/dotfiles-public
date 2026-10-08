# Load OS-specific configuration
switch (uname)
    case Darwin
        source (dirname (status --current-filename))/config-osx.fish
    case Linux
        source (dirname (status --current-filename))/config-linux.fish
    case '*'
        source (dirname (status --current-filename))/config-windows.fish
end

# Load local non-versioned configuration
set -l local_config (dirname (status --current-filename))/config-local.fish
test -f $local_config; and source $local_config

# OpenClaw Completion
test -f '/home/tonynguyen/.openclaw/completions/openclaw.fish'; and source '/home/tonynguyen/.openclaw/completions/openclaw.fish'
