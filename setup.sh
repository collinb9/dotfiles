# misc rc files
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
chmod +x ~/.git_template/*
git config --global init.templatedir '~/.git_template'
ln -svfn ~/.dotfiles/.git_template ~
chmod +x ~/.git_template/hooks/*

# zsh
ln -svfn ~/.dotfiles/.zshrc ~
sudo rm -rf ~/.oh-my-zsh
ln -svfn ~/.dotfiles/.oh-my-zsh ~
chmod +x ~/.oh-my-zsh/*

# fzf
ln -svfn ~/.dotfiles/.fzf ~
chmod +x ~/.fzf/*
~/.fzf/install
chmod +x ~/.fzf/*

# /bin
ln -svfn ~/.dotfiles/bin/ ~
