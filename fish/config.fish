if status is-interactive
    # Commands to run in interactive sessions can go here
    zoxide init fish | source
    starship init fish | source
    fastfetch
end

# Dev container paths
fish_add_path "$HOME/Dev/fqz/dev_containers/rust_arm64_host/scripts"
fish_add_path "$HOME/Dev/fqz/dev_containers/go/scripts"
fish_add_path "$HOME/Dev/fqz/dev_containers/python/scripts"
fish_add_path "$HOME/.rustup/toolchains/stable-aarch64-unknown-linux-gnu/bin"
