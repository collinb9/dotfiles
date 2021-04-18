ln -svfn ~/.dotfiles/.bashrc ~
ln -svfn ~/.dotfiles/.zshrc ~
sudo rm -rf ~/.vim
ln -svfn ~/.dotfiles/.vim ~
sudo rm -rf ~/.git_template
ln -svfn ~/.dotfiles/.git_template ~
chmod +x ~/.git_template/hooks/*
mkdir -p ~/bin
ln -svfn ~/.dotfiles/bin/custom_commands.sh ~/bin/
