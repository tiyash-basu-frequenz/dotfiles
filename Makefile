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

.PHONY: all setup-nixos setup-zsh setup-alacritty setup-kitty setup-tmux setup-zellij setup-fastfetch setup-ssh setup-nvim setup-zed setup-vscode setup-git-user setup-git-commit-template setup-git

# System setup

setup-nixos:
	cp nixos/configuration.nix /etc/nixos/configuration.nix

# Terminal setup

setup-zsh:
	cp zsh/zshrc $(_out_dir)/.zshrc
	@echo "Check plugins in the zsh directory here"

setup-alacritty:
	mkdir -p ~/.config/alacritty/themes
	-git clone https://github.com/alacritty/alacritty-theme ~/.config/alacritty/themes
	cp alacritty/alacritty.toml ~/.config/alacritty/alacritty.toml

setup-kitty:
	cp kitty/* $(_out_dir)/.config/kitty/

setup-tmux:
	mkdir -p $(_out_dir)/.tmux/plugins
	-git clone https://github.com/tmux-plugins/tpm $(_out_dir)/.tmux/plugins/tpm
	cp tmux/$(_system)/tmux.conf $(_out_dir)/.tmux.conf
	@echo "Install tmux plugins by pressing prefix + I"

setup-zellij:
	cp -r zellij $(_out_dir)/.config/

setup-fastfetch:
	cp fastfetch/config.jsonc $(_out_dir)/.config/fastfetch/config.jsonc

# SSH setup

setup-ssh:
	cp ssh/config $(_out_dir)/.ssh/config

# Editor setup

setup-nvim:
	mkdir -p $(_out_dir)/.config/nvim
	cp -r nvim $(_out_dir)/.config/

setup-zed:
	mkdir -p $(_out_dir)/.config/zed
	cp zed/settings.json $(_out_dir)/.config/zed/settings.json

setup-vscode:
	cp vscode/settings.json $(_out_dir)/Library/Application\ Support/Code/User/settings.json
	cp vscode/extensions.json $(_out_dir)/.vscode/extensions/extensions.json

# Git setup

setup-git-user:
	git config --global user.name $(_name)
	git config --global user.email $(_email)
	git config --global core.editor nvim
	git config --global user.signingkey $(_gpg)
	git config --global format.signOff true
	git config --global commit.gpgsign true
	git config --global tag.gpgsign true
	@echo "### COPY FROM THIS LINE ONWARDS ###"
	gpg --armor --export $(_gpg)
	@echo "### DO NOT COPY FROM THIS LINE ONWARDS ###"

setup-git-commit-template:
	cp git/gitmessage ~/.gitmessage
	git config --global commit.template ~/.gitmessage

setup-git: setup-git-user setup-git-commit-template

