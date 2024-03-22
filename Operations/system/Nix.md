### Install
#### Nix package manager
##### Linux

```shell
# Install Nix via the recommended multi-user installation:
sh <(curl -L https://nixos.org/nix/install) --daemon

# Single-user installation
sh <(curl -L https://nixos.org/nix/install) --no-daemon
```

##### Docker
```shell
# Start a Docker shell with Nix
docker run -it nixos/nix

# Or start a Docker shell with Nix exposing a workdir directory
mkdir workdir
docker run -it -v $(pwd)/workdir:/workdir nixos/nix

# The workdir example from above can be also used to start hacking on nixpkgs
git clone --depth=1 https://github.com/NixOS/nixpkgs.git
docker run -it -v $(pwd)/nixpkgs:/nixpkgs nixos/nix

docker> nix-build -I nixpkgs=/nixpkgs -A hello
docker> find ./result # this symlink points to the build package
```

#### NixOS
##### [1. Obtaining NixOS](https://nixos.org/download/#nixos-iso)

##### 2. Manual Installation
###### Partitioning
```shell
# UEFI(GPT)
# Create a GPT partition table
parted /dev/sda -- mklabel gpt
# Add the boot partition.
parted /dev/sda -- mkpart ESP fat32 1MB 512MB
# Add the root partition. 
parted /dev/sda -- mkpart root ext4 512MB 100%
# NixOS by default uses the ESP (EFI system partition) as its /boot partition. It uses the initially reserved 512MiB at the start of the disk.
parted /dev/sda -- set 1 esp on



# Legacy Boot(MBR)
# Create a MBR partition table.
parted /dev/sda -- mklabel msdos
parted /dev/sda -- mkpart primary 1MB -2GB
parted /dev/sda -- set 1 boot on
parted /dev/sda -- mkpart primary linux-swap -2GB 100%
```

![[Pasted image 20240321172907.png]]

###### Formatting
```shell
# Format
mkfs.fat -F 32 -n boot /dev/sda1
mkfs.ext4 -L nixos /dev/sda2


##### Examples
# For initialising Ext4 partitions: mkfs.ext4. It is recommended that you assign a unique symbolic label to the file system using the option -L label, since this makes the file system configuration independent from device changes. For example:
mkfs.ext4 -L nixos /dev/sda1

# For creating swap partitions: mkswap. Again it’s recommended to assign a label to the swap partition: -L label. For example:
mkswap -L swap /dev/sda2

# UEFI systems
# For creating boot partitions: mkfs.fat. Again it’s recommended to assign a label to the boot partition: -n label. For example:
mkfs.fat -F 32 -n boot /dev/sda3

# For creating LVM volumes, the LVM commands, e.g., pvcreate, vgcreate, and lvcreate.

# For creating software RAID devices, use mdadm.
```

###### Installing
```shell
# Mount the target file system on which NixOS should be installed on /mnt, e.g.
mount /dev/sda2/ /mnt

# UEFI systems
# Mount the boot file system on /mnt/boot
mkdir -p /mnt/boot
mount /dev/sda1/ /mnt/boot

# Generate and edit config
nixos-generate-config --root /mnt
cat >> /mnt/etc/nixos/configuration.nix << "EOF"
{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # (for BIOS systems only)
  # boot.loader.grub.device = "/dev/sda";
  
  # (for UEFI systems only)
  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "yakir-nixos"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  # networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Asia/Shanghai";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  # Enable the X11 windowing system.
  # services.xserver.enable = true;


  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # sound.enable = true;
  # hardware.pulseaudio.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.yakir = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    openssh.authorizedKeys.keys = [
      # replace with your own public key
      "ssh-rsa <public-key> yakir@nixos"
    ];
    packages = with pkgs; [
      firefox
      tree
    ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim
    wget
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;
  services.openssh = {
    enable = true;
    settings = {
      X11Forwarding = true;
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
    openFirewall = true;
  }

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "23.11"; # Did you read the comment?
}
EOF

# Install NixOS
nixos-install
# set root password and reboot
```

###### 3. Upgrading
```shell
# switch channel
nix-channel --list
nixos https://nixos.org/channels/nixos-23.11
# add new channel
nix-channel --add https://channels.nixos.org/nixos-23.11 nixos
nix-channel --add https://channels.nixos.org/nixos-23.11-small nixos

# upgrade
nixos-rebuild switch --upgrade
```

### NixCommand
##### nixos-rebuild 
```shell
# build new configuration and try to realise the configuration in the running system
nixos-rebuild switch

# to build the configuration and switch the running system to it, but without making it the boot default.(so it will get back to a working configuration after the next reboot).
nixos-rebuild test

# to build the configuration and make it the boot default, but not switch to it now (so it will only take effect after the next reboot).
nixos-rebuild boot

# You can make your configuration show up in a different submenu of the GRUB 2 boot screen by giving it a different profile name
nixos-rebuild switch -p test

# to build the configuration but nothing more. can check syntax
nixos-rebuild build

# verbose argument
--show-trace --print-build-logs --verbose
```

##### nix-channel
```shell
# list
nix-channel list

# add new 
nix-channel --add https://channels.nixos.org/channel-name nixos
```

### Flakes
...



>Reference:
>1. [NixOS Official Manual](https://nixos.org/manual/nix/stable/language/)
>2. [NixOS 与 Flakes](https://nixos-and-flakes.thiscute.world/)
>3. [NixOS 中文文档](https://nixos-cn.org/tutorials/lang/)
>4. [NixOS Packages Search](https://search.nixos.org/packages)
>5. [NixOS Options Search](https://search.nixos.org/options)