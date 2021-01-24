ln -svfn ~/.dotfiles/.bashrc ~
ln -svfn ~/.dotfiles/.zshrc ~
sudo rm -rf ~/.vim
ln -svfn ~/.dotfiles/.vim ~
mkdir -p ~/bin
ln -svfn ~/.dotfiles/bin/custom_commands.sh ~/bin/
