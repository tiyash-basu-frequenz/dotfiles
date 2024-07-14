# Author: Tiyash Basu

# Set ID
_name := "Tiyash Basu"
_email := "tiyashbasu@gmail.com"
# _email := "tiyash.basu@frequenz.com"

# get gpg key
_gpg := $(shell gpg --list-secret-keys --keyid-format=long | grep -B2 $(_email) | head -n1 | cut -d'/' -f2 | cut -d' ' -f1)

# output directory
_out_dir := $(HOME)

_system := $(shell uname -s)

.PHONY: setup-tmux setup-nvim setup-zsh setup-alacritty setup-kitty setup-ssh setup-vscode setup-git-user setup-git-commit-template setup-git setup-all

setup-tmux:
	mkdir -p $(_out_dir)/.tmux/plugins
	-git clone https://github.com/tmux-plugins/tpm $(_out_dir)/.tmux/plugins/tpm
	cp tmux/$(_system)/tmux.conf $(_out_dir)/.tmux.conf
	@echo "Install tmux plugins by pressing prefix + I"

setup-nvim:
	mkdir -p $(_out_dir)/.config/nvim
	cp -r nvim $(_out_dir)/.config/

setup-zsh:
	cp zsh/zshrc $(_out_dir)/.zshrc
	@echo "Check plugins in the zsh directory here"

setup-alacritty:
	mkdir -p ~/.config/alacritty/themes
	-git clone https://github.com/alacritty/alacritty-theme ~/.config/alacritty/themes
	cp alacritty/alacritty.toml ~/.config/alacritty/alacritty.toml

setup-kitty:
	cp kitty/* $(_out_dir)/.config/kitty/

setup-ssh:
	cp ssh/config $(_out_dir)/.ssh/config

setup-vscode:
	cp vscode/settings.json $(_out_dir)/Library/Application\ Support/Code/User/settings.json
	cp vscode/extensions.json $(_out_dir)/.vscode/extensions/extensions.json

setup-git-user:
	git config --global user.name $(_name)
	git config --global user.email $(_email)
	git config --global user.signingkey $(_gpg)
	git config --global commit.gpgsign true
	@echo "### COPY FROM THIS LINE ONWARDS ###"
	gpg --armor --export $(_gpg)
	@echo "### DO NOT COPY FROM THIS LINE ONWARDS ###"

setup-git-commit-template:
	cp git/gitmessage ~/.gitmessage
	git config --global commit.template ~/.gitmessage

setup-git: setup-git-user setup-git-commit-template

setup-nixos:
	cp nixos/configuration.nix /etc/nixos/configuration.nix

setup-all: setup-tmux setup-nvim setup-zsh setup-kitty setup-ssh setup-vscode setup-git
