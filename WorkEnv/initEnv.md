#### Common Init
##### Homebrew & zsh & oh-my-zsh
```shell
# Homebrew
#官方地址 = https://brew.sh/  
#中科大镜像 = https://mirrors.ustc.edu.cn/help/brew.git.html
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# oh-my-zsh
git clone https://github.com/ohmyzsh/ohmyzsh.git ~/.oh-my-zsh
#Plugin
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
#source <(kubectl completion zsh)
#source <(helm completion bash)
EOF

# change shell
chsh -s $(which zsh)

# PowerlineFont
#https://github.com/powerline/fonts
cd /tmp && git clone https://github.com/powerline/fonts.git --depth=1
cd fonts && ./install.sh

# iterm2-color
# https://iterm2colorschemes.com/

# 允许 Mac 安装任何来源软件
sudo spctl --master-disable

```

##### VIM
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
set hlsearch  "搜索高亮

filetype on
filetype plugin indent on
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'       "vundle插件
Plugin 'vim-syntastic/syntastic'    "语法检查插件
Plugin 'exvim/ex-colorschemes'      "颜色主题
call vundle#end()
EOF

# vim plugin install
:PluginInstall

# change colorscheme
mkdir ~/.vim/colors
cp ~/.vim/bundle/ex-colorschemes/colors/molokai.vim ~/.vim/colors/

```

##### K3S
```shell
# kernel module
nf_conntrack
br_netfilter


# master
curl -sfL https://get.k3s.io | sh -
cat /var/lib/rancher/k3s/server/node-token  # join token
##disable traefik
kubectl -n kube-system delete helmcharts.helm.cattle.io traefik
kubectl -n kube-system delete helmcharts.helm.cattle.io traefik-crd
kubectl -n kube-system delete pod --field-selector=status.phase==Succeeded 
##add to /etc/systemd/system/k3s.service
ExecStart=/usr/local/bin/k3s \
    server \
    --disable traefik \
    --disable traefik-crd \

##
systemctl daemon-reload
rm /var/lib/rancher/k3s/server/manifests/traefik.yaml
systemctl restart k3s


# worker
curl -sfL https://get.k3s.io | K3S_URL=https://myserver:6443 K3S_TOKEN=mynodetoken sh -

# access
mkdir ~/.kube
cp /etc/rancher/k3s/k3s.yaml ~/.kube/config

```


#### Fedora Init
```shell
# install packages
dnf install zsh git svn telnet wget curl make cmake
dnf install containerd

# yum repos resource(/etc/yum.repos.d/)
dnf install fedora-workstation-repositories
dnf config-manager --set-enabled google-chrome
dnf update
dnf install google-chrome-stable


# install extensions 
dnf install gnome-shell-extension-user-theme
gnome-extensions enable user-theme@gnome-shell-extensions.gcampax.github.com
# list
# https://extensions.gnome.org/
gnome-extensions list
dash-to-dock@micxgx.gmail.com
Hide_Activities@shay.shayel.org

# install theme tools
dnf install gnome-shell-theme-yaru
dnf install gnome-tweak-tool

# search 
dnf search gtk | grep theme
dnf search shell-theme
dnf search icon-theme
dnf search cursor-theme

```


#### Ubuntu Init
```shell
# install package
apt install zsh git svn telnet wget curl make cmake
apt install openjdk-11-jdk 
apt install containerd.io


# apt repos resource(/etc/apt/sources.list)
echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" |tee /etc/apt/sources.list.d/google-cloud-sdk.list
echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu  focal stable" |tee /etc/apt/sources.list.d/docker.list 

```

