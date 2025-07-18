# Author: Tiyash Basu

# Set ID
_name := "Tiyash Basu"
_email := "tiyashbasu@gmail.com"
# _email := "tiyash.basu@frequenz.com"

# system
_system := $(shell uname -s)

# get gpg key
_gpg := $(shell gpg --list-secret-keys --keyid-format=long | grep -B2 $(_email) | head -n1 | cut -d'/' -f2 | cut -d' ' -f1)

# output directory
_out_dir := $(HOME)

.PHONY: nixos nixos-update nixos-switch nixos-test nixos-clean hypr zsh alacritty ghostty kitty tmux zellij fastfetch ssh nvim zed vscode git-user git-commit-template git

# System setup

nixos:
	cp nixos/configuration.nix /etc/nixos/configuration.nix
	cp nixos/wireguard.nix /etc/nixos/wireguard.nix

nixos-update: nixos
	nix-channel --update

nixos-test:
	nixos-rebuild --upgrade test

nixos-switch:
	nixos-rebuild --upgrade switch

nixos-clean:
	nix-collect-garbage --delete-old

hypr:
	cp -r hyprland/* $(_out_dir)/.config/

# Terminal setup

zsh:
	cp zsh/zshrc $(_out_dir)/.zshrc
	@echo "Check plugins in the zsh directory here"

alacritty:
	mkdir -p ~/.config/alacritty/themes
	-git clone https://github.com/alacritty/alacritty-theme ~/.config/alacritty/themes
	cp alacritty/alacritty.toml ~/.config/alacritty/alacritty.toml

ghostty:
	mkdir -p ~/.config/ghostty
	cp ghostty/$(_system)/* ~/.config/ghostty/

kitty:
	cp kitty/$(_system)/* $(_out_dir)/.config/kitty/

tmux:
	mkdir -p $(_out_dir)/.tmux/plugins
	-git clone https://github.com/tmux-plugins/tpm $(_out_dir)/.tmux/plugins/tpm
	cp tmux/$(_system)/tmux.conf $(_out_dir)/.tmux.conf
	@echo "Install tmux plugins by pressing prefix + I"

zellij:
	cp -r zellij $(_out_dir)/.config/

fastfetch:
	mkdir -p $(_out_dir)/.config/fastfetch
	cp fastfetch/config.jsonc $(_out_dir)/.config/fastfetch/config.jsonc

# SSH setup

ssh:
	cp ssh/config $(_out_dir)/.ssh/config

# Editor setup

nvim:
	mkdir -p $(_out_dir)/.config/nvim
	rm -rf $(_out_dir)/.config/nvim/*
	cp -r nvim $(_out_dir)/.config/

zed:
	mkdir -p $(_out_dir)/.config/zed
	cp zed/settings.json $(_out_dir)/.config/zed/settings.json

vscode:
	cp vscode/settings.json $(_out_dir)/Library/Application\ Support/Code/User/settings.json
	cp vscode/extensions.json $(_out_dir)/.vscode/extensions/extensions.json

# Git setup

git-user:
	git config --global user.name $(_name)
	git config --global user.email $(_email)
	git config --global core.editor nvim
	git config --global user.signingkey $(_gpg)
	git config --global format.signOff true
	git config --global commit.gpgsign true
	git config --global commit.verbose true
	git config --global tag.gpgsign true
	@echo "### COPY FROM THIS LINE ONWARDS ###"
	gpg --armor --export $(_gpg)
	@echo "### DO NOT COPY FROM THIS LINE ONWARDS ###"

git-commit-template:
	cp git/gitmessage ~/.gitmessage
	git config --global commit.template ~/.gitmessage

git: git-user git-commit-template

