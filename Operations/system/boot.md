### BIOS vs UEFI
#### BIOS
1. 开机加电自检, POST (Power-On Self-Test)
该过程主要对计算机各种硬件设备进行检测，如 CPU、内存、主板、硬盘、CMOS 芯片等，如果出现致命故障则停机，并且由于初始化过程还没完成，所以不会出现任何提示信号；如果出现一般故障则会发出蜂鸣；若未出现故障，加电自检完成(枚举本地硬件设备初始化)。
2. 按 Boot Sequence 查找可用设备, 找到后从该设备第一个扇区读取 MBR
[[boot#MBR(Master Boot Record)|加载主引导记录 MBR]]

#### UEFI
xxx

### MBR vs GPT
#### MBR(Master Boot Record)
1. Boot loader: 主引导加载程序,446B,加载内核到内存中运行
**Linux 中的 Boot loader 为: grab 或 grab2, 加载 /boot/grab/vmlinux.. 内核到内存中**
2. Disk Partition Table: 分区表,64B,记录每个分区信息(大小,起始扇区和大小等).每个分区16B.
3. Boot Flag: 分区表标记,2B,表示设备是否可启动.

#### GPT(Globally Unique Identifier)
1. 

### Kernel
内核初始化硬件
加载驱动
初始化内存管理,进程管理
挂载根文件系统
切换 rootfs
运行 init 程序

### Systemd
/etc/rcX.d/
/etc/init.d/



>Reference:
>1. [BIOS vs UEFI](https://learn.microsoft.com/en-us/windows-hardware/manufacture/desktop/boot-to-uefi-mode-or-legacy-bios-mode?view=windows-11)
>2. [MBR vs GPT](https://www.easeus.com/partition-master/mbr-vs-gpt.html)
>3. [计算机是如何启动的?](https://www.ruanyifeng.com/blog/2013/02/booting.html)