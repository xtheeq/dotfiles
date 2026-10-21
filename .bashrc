# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]; then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
export JAVA_HOME=/usr/lib/jvm/java-17-temurin-jdk
export ANDROID_HOME=$HOME/Android/Sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/platform-tools
export PATH="$HOME/src/flutter/bin:$PATH"
export PNPM_HOME="$HOME/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME/bin:"*) ;;
  *) export PATH="$PNPM_HOME/bin:$PATH" ;;
esac

export EDITOR=hx
export VISUAL=hx

if [ -d ~/.bashrc.d ]; then
    for rc in ~/.bashrc.d/*; do
        if [ -f "$rc" ]; then
            . "$rc"
        fi
    done
fi
unset rc
. "$HOME/.cargo/env"

alias c=clear
eval "$(starship init bash)"

e() {
    case "${1-}" in
        shell|-*)
            '/home/atheeq/.cargo/bin/elio' "$@"
            return $?
            ;;
    esac

    local tmp cwd status_code
    tmp="$(mktemp -t "elio-cwd.XXXXXX")" || return
    '/home/atheeq/.cargo/bin/elio' --cwd-file "$tmp" "$@"
    status_code=$?

    if [ -s "$tmp" ]; then
        cwd="$(cat -- "$tmp")"
        rm -f -- "$tmp"
        if [ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && [ -d "$cwd" ]; then
            cd -- "$cwd" || return $?
        fi
    else
        rm -f -- "$tmp"
    fi

    return "$status_code"
}


# Vite+ bin (https://viteplus.dev)
. "$HOME/.vite-plus/env"

eval "$(zoxide init --cmd cd bash)"


# opencode
export PATH=/home/atheeq/.opencode/bin:$PATH
