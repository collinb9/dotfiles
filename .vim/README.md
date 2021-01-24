# Vim config
This repo contains the file to reproduce my current vim setup. It corresponds
to the setup in my dotfiles. To use this configuration, do the following:
```
git clone .............. ~/.vim
./vim_setup.sh
```
## Requirements
You may need to install the latest version of vim. Instructions [here](https://www.vim.org/git.php).
Based on your opperating system, there will be some further setup required
### MacOS
You must have vim compiled with python3. To check if that is already the case,
enter the following command inside vim: 
`:echo has("python3")`
which will return 1 if the python version is compiled, and 0 otherwise. 
To install vim with python3 enabled via homebrew, use the following:
```
brew remove vim
brew cleanup
brew install vim --with-python3
```
To install the YouCompleteMe plugin, you need to run the following commands
```
cd ~/.vim/pack/ycm-core/YouCompleteMe
python3 install.py --all
```
### Linux
Your vim must also be compiled with python on linux, but this is likely done by
default. To install YouCompleteMe, you must first install cmake, java, mono-complete, go,
node and npm. To install mono, run
```

sudo apt-key dev --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys
3FA7EO328081BFF6A14DA29AA6A19B38D3D831EF
sudo sh -c 'echo "deb https://download.mono-project.com/repo/ubuntustable-bionic main" > /etc/apt/sources.list.d/mono-official-stable.list'
sudo apt install mono-complete
```
To install go, do the following
```
curl -O https://storage.googleapis.com/golang/go1.12.9.linux-amd64.tar.gz
sha256sum go1.12.9.linux-amd64.tar.gz
tar -xvf go1.12.9.linux-amd64.tar.gz
sudo chown -R root:root ./go
sudo mv go /usr/local
```
Next, open up `~/.profile` and add the following two lines
```
export GOPATH=$HOME/go
export PATH=$PATH:/usr/local/go/bin:$GOPATH/bin
```
And load the changes with 
```
source ~/.profile
```
Cmake, node and npm can be installed as normal 
```
sudo apt install cmake
sudo apt install nodejs
sudo apt install npm
```
To install java, run
```
sudo apt-get install openjdk-11-jdk
```
After doing all that, compile YCM with 
```
cd ~/.vim/pack/ycm-core/start/YouCompleteMe
git submodule update --init --recursive
python3 install.py --all

```
Note, you may have to update gcc and specify the C++ compiler to use with 
```
CXX=gcc-X ./install.py -all
```

