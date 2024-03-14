### Init Environment
#### Common
##### HomeBrew
```shell
# Homebrew
# official
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
# mirror
export HOMEBREW_BREW_GIT_REMOTE="https://mirrors.ustc.edu.cn/brew.git"
export HOMEBREW_CORE_GIT_REMOTE="https://mirrors.ustc.edu.cn/homebrew-core.git"
export HOMEBREW_BOTTLE_DOMAIN="https://mirrors.ustc.edu.cn/homebrew-bottles"
export HOMEBREW_API_DOMAIN="https://mirrors.ustc.edu.cn/homebrew-bottles/api"
/bin/bash -c "$(curl -fsSL https://mirrors.ustc.edu.cn/misc/brew-install.sh)"

# how to use
brew list
brew install wget
brew search python

```

##### zsh && oh-my-zsh || oh-my-bash
```shell
# install and change shell to zsh
brew install zsh # Mac
apt install zsh  # Debian
chsh -s $(which zsh)

# install oh-myzsh
# cat InitEnvFiles/shell/yakir.zshrc

# config
cp InitEnvFiles/shell/yakir.zshrc ~/.zshrc

# install fonts = PowerlineFont
cd /tmp && git clone https://github.com/powerline/fonts.git --depth=1
cd fonts && ./install.sh

# iterm2-color
wget -O /tmp/HaX0R_GR33N.itermcolors https://raw.githubusercontent.com/mbadolato/iTerm2-Color-Schemes/master/schemes/HaX0R_GR33N.itermcolorsr
wget -O /tmp/Solarized_Darcula.itermcolors https://raw.githubusercontent.com/mbadolato/iTerm2-Color-Schemes/master/schemes/Solarized%20Darcula.itermcolors

# Allow Mac to install software from any source
sudo spctl --master-disable

```

##### Vim
```shell
# install vim and vundle
apt install vim
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

# config
cp InitEnvFiles/yakir.vimrc ~/.vimrc

# vim plugin install
vim
:PluginInstall

# install colorshceme and set to molokai
mkdir ~/.vim/colors
cp ~/.vim/bundle/ex-colorschemes/colors/molokai.vim ~/.vim/colors/

```

#### Custom
##### SSH Config
``` shell
# copy ssh config
cp InitEnvFiles/ssh/yakir.sshconfig ~/.ssh/config
# change private permission
chmod 600 InitEnvFiles/ssh/yakir_server.key

# Client Machine
mkdir ~/.ssh
cp InitEnvFiles/ssh/yakir_server.key ~/.ssh/
cp InitEnvFiles/ssh/yakir_server.pub ~/.ssh/
```

##### iTerm2
``` shell
# install
brew install iterm2

# import config
InitEnvFiles/iterm2/iterm2Profile.json

# import iterm2-color
InitEnvFiles/iterm2/Solarized_Darcula.itermcolors
InitEnvFiles/iterm2/HaX0R_GR33N.itermcolors

```

##### K3S
```shell
# kernel module
lsmod |grep -E "nf_conntrack|br_netfilter"

# master
curl -sfL https://get.k3s.io | sh -
cat /var/lib/rancher/k3s/server/node-token  # join token
##disable traefik
kubectl -n kube-system delete helmcharts.helm.cattle.io traefik
kubectl -n kube-system delete helmcharts.helm.cattle.io traefik-crd
kubectl -n kube-system delete pod --field-selector=status.phase==Succeeded 
##modify /etc/systemd/system/k3s.service
ExecStart=/usr/local/bin/k3s \
    server \
    --disable traefik \
    --disable traefik-crd \
##restart k3s server
rm /var/lib/rancher/k3s/server/manifests/traefik.yaml
systemctl daemon-reload
systemctl restart k3s

# worker
curl -sfL https://get.k3s.io | K3S_URL=https://k3s_server_ip:6443 K3S_TOKEN=k3s_server_token sh -

# get kubectl and helm client
apt install bash-completion
curl -LO https://dl.k8s.io/release/v1.27.3/bin/linux/amd64/kubectl
wget https://get.helm.sh/helm-v3.11.0-linux-amd64.tar.gz
cat >> ~/.bashrc << "EOF"
complete -o default -F __start_kubectl k
source <(kubectl completion bash)
source <(helm completion bash)
EOF

# kubectl client config
mkdir ~/.kube
cp /etc/rancher/k3s/k3s.yaml ~/.kube/config
kubectl get pod -A
helm list
```

#### Others
##### Fedora Init
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

##### Ubuntu Init
```shell
# install package
apt install zsh git svn telnet wget curl make cmake
apt install openjdk-11-jdk 
apt install containerd.io


# apt repos resource(/etc/apt/sources.list)
echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" |tee /etc/apt/sources.list.d/google-cloud-sdk.list
echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu  focal stable" |tee /etc/apt/sources.list.d/docker.list

```

### Init App
#### Browser
```textile
# Chrome

# Chrome Plugins
Adblock
Authenticator
Dark mode chrome
DuckDuckGo Privacy Essentials
FeHelper
Free VPN ZenMate-Best
GitHub加速
Google Docs Offline
MEGA
Multi Elasticsearch Head
Network+
Proxy SwitchyOmega
Tampermonkey
V2EXPolish
Vimium  # map q visitPreviousTab
划词翻译

# Firefox

# Opera

```

#### Terminal
```textile
# SecureCRT
InitEnvFiles/SecureCRT.xml
# activation software crontab
cp InitEnvFiles/activation_software.sh /opt/activation_software.sh
* * 9,19,29 * * sh /opt/activation_software.sh

# iTerm2
InitEnvFiles/iterm2Profiles.json

# Xshell
InitEnvFiles/windows_config/software/Xshell

```

#### Tools
##### Develop
```textile
# develop
Apifox
Goland
Pycharm

# virtual machine
Multipass

# network
Wireshark
bproxy

# record
Obsidian
Sublime-text

```

##### Clients
```textile
# subversion = svn-client

# git = git-client

# Another Redis Desktop Manager = redis-client 

# Offset Explorer 2 = kafka-client

# mysql = mysql-client

```

##### Others
```textile
# Xmind

# KeePassXC

# Raycast

# iStat Menus
982092332@qq.com 
GAWAE-FCWQ3-P8NYB-C7GF7-NEDRT-Q5DTB-MFZG6-6NEQC-CRMUD-8MZ2K-66SRB-SU8EW-EDLZ9-TGH3S-8SGA 

# Snipaste

```



>Reference:
> 1. [HomeBrew Official](https://brew.sh)
> 2. [中科大镜像](https://mirrors.ustc.edu.cn/help/brew.git.html)
> 3. [iterm2colors](https://iterm2colorschemes.com/)
> 4. [oh-my-zsh](https://github.com/ohmyzsh/ohmyzsh)
> 5. [Vim Awesome](https://vimawesome.com/)
