ln -svfn ~/.dotfiles/.bashrc ~
ln -svfn ~/.dotfiles/.zshrc ~
sudo rm -rf ~/.vim
ln -svfn ~/.dotfiles/.vim ~
sudo rm -rf ~/.git_template
ln -svfn ~/.dotfiles/.git_template ~
chmod +x ~/.git_template/hooks/*
sudo rm -rf ~/.oh-my-zsh
ln -svfn ~/.dotfiles/.oh-my-zsh ~
chmod +x ~/.oh-my-zsh *
mkdir -p ~/bin
ln -svfn ~/.dotfiles/bin/custom_commands.sh ~/bin/
