TARGETS = console-setup mountkernfs.sh hostname.sh resolvconf udev urandom hwclock.sh mountdevsubfs.sh checkroot.sh networking checkfs.sh mountall.sh checkroot-bootclean.sh bootmisc.sh mountall-bootclean.sh mountnfs.sh procps kmod mountnfs-bootclean.sh
INTERACTIVE = console-setup udev checkroot.sh checkfs.sh
udev: mountkernfs.sh
urandom: hwclock.sh
hwclock.sh: mountdevsubfs.sh
mountdevsubfs.sh: mountkernfs.sh udev
checkroot.sh: hwclock.sh mountdevsubfs.sh hostname.sh
networking: mountkernfs.sh urandom procps resolvconf
checkfs.sh: checkroot.sh
mountall.sh: checkfs.sh checkroot-bootclean.sh
checkroot-bootclean.sh: checkroot.sh
bootmisc.sh: udev mountall-bootclean.sh mountnfs-bootclean.sh checkroot-bootclean.sh
mountall-bootclean.sh: mountall.sh
mountnfs.sh: networking
procps: mountkernfs.sh udev
kmod: checkroot.sh
mountnfs-bootclean.sh: mountnfs.sh
