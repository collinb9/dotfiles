# polybar
sudo rm -rf ~/.config/polybar
ln -svfn ~/.dotfiles/.config/polybar/ ~/.config

# bat
sudo rm -rf ~/.config/bat
ln -svfn ~/.dotfiles/.config/bat/ ~/.config

# ranger
sudo rm -rf ~/.config/ranger
ln -svfn ~/.dotfiles/.config/ranger/ ~/.config

# htop
sudo rm -rf ~/.config/htop
ln -svfn ~/.dotfiles/.config/htop/ ~/.config

# tmux
sudo rm -rf ~/.config/tmux
ln -svfn ~/.dotfiles/.config/tmux/ ~/.config

# nvim
sudo rm -rf ~/.config/nvim
ln -svfn ~/.dotfiles/.config/nvim/ ~/.config

# alacritty
sudo rm -rf ~/.config/alacritty
ln -svfn ~/.dotfiles/.config/alacritty/ ~/.config

# rofi
sudo rm -rf ~/.config/rofi
ln -svfn ~/.dotfiles/.config/rofi/ ~/.config

# awesome
sudo rm -rf ~/.config/awesome
ln -svfn ~/.dotfiles/.config/awesome/ ~/.config

# picom
sudo rm -rf ~/.config/picom
ln -svfn ~/.dotfiles/.config/picom/ ~/.config

# gtk
sudo rm -rf ~/.config/gtk-3.0
ln -svfn ~/.dotfiles/.config/gtk-3.0/ ~/.config

# misc rc files
ln -svfn ~/.dotfiles/.xinitrc ~
ln -svfn ~/.dotfiles/.inputrc ~
ln -svfn ~/.dotfiles/.screenrc ~
ln -svfn ~/.dotfiles/.psqlrc ~

# vim
sudo rm -rf ~/.vim
ln -svfn ~/.dotfiles/.vim ~

# git
ln -svfn ~/.dotfiles/.gitconfig ~
sudo rm -rf ~/.git_template
ln -svfn ~/.git_template ~
git config --global init.templatedir '~/.git_template'
ln -svfn ~/.dotfiles/.git_template ~
chmod +x ~/.git_template/hooks/*

# zsh
ln -svfn ~/.dotfiles/.zshrc ~
sudo rm -rf ~/.config/zsh
ln -svfn ~/.dotfiles/.config/zsh/ ~/.config
sudo rm -rf ~/.oh-my-zsh
ln -svfn ~/.dotfiles/.oh-my-zsh ~
chmod +x ~/.oh-my-zsh/*
~/.oh-my-zsh/tools/install.sh

# fzf
ln -svfn ~/.dotfiles/.fzf ~
chmod +x ~/.fzf/*
~/.fzf/install
chmod +x ~/.fzf/*

# /bin
ln -svfn ~/.dotfiles/bin/ ~
