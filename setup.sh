# polybar
sudo rm -rf $HOME/.config/polybar
ln -svfn $HOME/.dotfiles/.config/polybar/ $HOME/.config

# bat
sudo rm -rf $HOME/.config/bat
ln -svfn $HOME/.dotfiles/.config/bat/ $HOME/.config

# curl
sudo rm -rf $HOME/.config/curl
ln -svfn $HOME/.dotfiles/.config/curl/ $HOME/.config

# ranger
sudo rm -rf $HOME/.config/ranger
ln -svfn $HOME/.dotfiles/.config/ranger/ $HOME/.config

# htop
sudo rm -rf $HOME/.config/htop
ln -svfn $HOME/.dotfiles/.config/htop/ $HOME/.config

# tmux
sudo rm -rf $HOME/.config/tmux
ln -svfn $HOME/.dotfiles/.config/tmux/ $HOME/.config

# nvim
sudo rm -rf $HOME/.config/nvim
ln -svfn $HOME/.dotfiles/.config/nvim/ $HOME/.config

# alacritty
sudo rm -rf $HOME/.config/alacritty
ln -svfn $HOME/.dotfiles/.config/alacritty/ $HOME/.config

# rofi
sudo rm -rf $HOME/.config/rofi
ln -svfn $HOME/.dotfiles/.config/rofi/ $HOME/.config

# awesome
sudo rm -rf $HOME/.config/awesome
ln -svfn $HOME/.dotfiles/.config/awesome/ $HOME/.config

# picom
sudo rm -rf $HOME/.config/picom
ln -svfn $HOME/.dotfiles/.config/picom/ $HOME/.config

# gtk
sudo rm -rf $HOME/.config/gtk-3.0
ln -svfn $HOME/.dotfiles/.config/gtk-3.0/ $HOME/.config

# stockfish client
sudo rm -rf $HOME/.config/stockfish_socket_client
ln -svfn $HOME/.dotfiles/.config/stockfish_socket_client/ $HOME/.config

# misc rc files
ln -svfn $HOME/.dotfiles/.xinitrc $HOME
ln -svfn $HOME/.dotfiles/.inputrc $HOME
ln -svfn $HOME/.dotfiles/.screenrc $HOME
ln -svfn $HOME/.dotfiles/.psqlrc $HOME

# vim
sudo rm -rf $HOME/.vim
ln -svfn $HOME/.dotfiles/.vim $HOME

# git
ln -svfn $HOME/.dotfiles/.gitconfig $HOME
sudo rm -rf $HOME/.git_template
ln -svfn $HOME/.git_template $HOME
git config --global init.templatedir '$HOME/.git_template'
ln -svfn $HOME/.dotfiles/.git_template $HOME
chmod +x $HOME/.git_template/hooks/*

# zsh
ln -svfn $HOME/.dotfiles/.zshrc $HOME
sudo rm -rf $HOME/.config/zsh
ln -svfn $HOME/.dotfiles/.config/zsh/ $HOME/.config

# /bin
ln -svfn $HOME/.dotfiles/bin/ $HOME
chmod u+x $HOME/bin/**
