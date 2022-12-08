#### Ubuntu package

```shell
# Ubuntu package
apt install zsh git openjdk-11-jdk containerd.io

# apt source
echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" |tee /etc/apt/sources.list.d/google-cloud-sdk.list
echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu   focal stable" |tee /etc/apt/sources.list.d/docker.list 
```

#### zsh & oh-my-zsh

```shell
# oh-my-zsh
git clone https://github.com/ohmyzsh/ohmyzsh.git ~/.oh-my-zsh
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# config
cat > ~/.zshrc << "EOF"
export ZSH="$HOME/.oh-my-zsh"
export PATH=$PATH:/usr/local/go/bin

ZSH_THEME="agnoster"
plugins=(
  git 
  zsh-syntax-highlighting 
  zsh-autosuggestions
)

source $ZSH/oh-my-zsh.sh
source <(kubectl completion zsh)
EOF

# change shell
chsh -s $(which zsh)
```

#### VIM

```shell
# bundle
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

# config
cat > ~/.vimrc << "EOF"
syntax on
syntax enable
set t_Co=256
colorscheme molokai

set tabstop=4
set nowrap
set ignorecase
set encoding=utf-8 fileencodings=utf-8


filetype on
filetype plugin indent on
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'       "vundle插件
Plugin 'vim-syntastic/syntastic'    "语法检查
Plugin 'exvim/ex-colorschemes'
call vundle#end()
EOF

# vim
:PluginInstall
```

#### K3S

```shell
# kernel module
nf_conntrack
br_netfilter

# master
curl -sfL https://get.k3s.io | sh -
cat /var/lib/rancher/k3s/server/node-token  # join token

# worker
curl -sfL http://rancher-mirror.cnrancher.com/k3s/k3s-install.sh | K3S_URL=https://x.x.x.x:6443 K3S_TOKEN=xxx sh -
```
