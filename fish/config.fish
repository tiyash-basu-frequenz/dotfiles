if status is-interactive
    # Commands to run in interactive sessions can go here
    zoxide init fish | source
    starship init fish | source
    fastfetch
end

# Dev container paths
fish_add_path "$HOME/Dev/fqz/dev_containers/rust/scripts"
fish_add_path "$HOME/Dev/fqz/dev_containers/go/scripts"
fish_add_path "$HOME/Dev/fqz/dev_containers/python/scripts"

# Rust
fish_add_path "$HOME/.rustup/toolchains/stable-aarch64-unknown-linux-gnu/bin"

# NPM global packages
set -gx NPM_CONFIG_PREFIX ~/.npm-global
fish_add_path "$HOME/.npm-global/bin"
