#!/bin/zsh

dnf config-manager --add-repo https://download.opensuse.org/repositories/shells:zsh-users:zsh-history-substring-search/Fedora_Rawhide/shells:zsh-users:zsh-history-substring-search.repo

dnf update

dnf install -y fastfetch starship zsh-autosuggestions zsh-syntax-highlighting zsh-history-substring-search
