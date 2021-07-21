ln -svfn ~/.dotfiles/.zshrc ~
ln -svfn ~/.dotfiles/.inputrc ~
ln -svfn ~/.dotfiles/.gitconfig ~
sudo rm -rf ~/.vim
ln -svfn ~/.dotfiles/.vim ~
sudo rm -rf ~/.git_template
ln -svfn ~/.git_template ~
chmod +x ~/.git_template/*
git config --global init.templatedir '~/.git_template'
ln -svfn ~/.dotfiles/.git_template ~
chmod +x ~/.git_template/hooks/*
sudo rm -rf ~/.oh-my-zsh
ln -svfn ~/.dotfiles/.oh-my-zsh ~
chmod +x ~/.oh-my-zsh/*
ln -svfn ~/.dotfiles/.fzf ~
chmod +x ~/.fzf/*
~/.fzf/install
chmod +x ~/.fzf/*
# mkdir -p ~/bin
ln -svfn ~/.dotfiles/bin/ ~
