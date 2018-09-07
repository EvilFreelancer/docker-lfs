#!/bin/bash
set -e
echo "Building linux kernel.."
echo "Approximate build time: 4.4 - 66.0 SBU (typically about 6 SBU)"
echo "Required disk space: 960 - 4250 MB (typically about 1100 MB)"

# 8.3. Linux package contains the Linux kernel
tar -xf /sources/linux-*.tar.xz -C /tmp/ \
  && mv /tmp/linux-* /tmp/linux \
  && pushd /tmp/linux

# ensure proper ownership of the files
chown -R 0:0 .

# 8.3.1 install kernel

# clean source tree
make mrproper

# copy premade config
# NOTE manual way is by launching:
# make menuconfig
cp /book/kernel.config .config

# compile
make

# installation
make modules_install

# copy kernel image
cp -iv arch/x86/boot/bzImage /boot/vmlinuz-4.18.5-lfs-8.3

# copy symbols
cp -iv System.map /boot/System.map-4.18.5

# copy original configuration
cp -iv .config /boot/config-4.18.5

# install documentation
install -d /usr/share/doc/linux-4.18.5
cp -r Documentation/* /usr/share/doc/linux-4.18.5

# 8.3.2. configure linux module load order
install -v -m755 -d /etc/modprobe.d
cat > /etc/modprobe.d/usb.conf << "EOF"
# Begin /etc/modprobe.d/usb.conf

install ohci_hcd /sbin/modprobe ehci_hcd ; /sbin/modprobe -i ohci_hcd ; true
install uhci_hcd /sbin/modprobe ehci_hcd ; /sbin/modprobe -i uhci_hcd ; true

# End /etc/modprobe.d/usb.conf
EOF

# cleanup
popd \
  && rm -rf /tmp/linux
