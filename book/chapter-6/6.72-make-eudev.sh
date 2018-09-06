#!/bin/bash
set -e
echo "Building Eudev.."
echo "Approximate build time: 0.2 SBU"
echo "Required disk space: 78 MB"

# 6.72. The Eudev package contains programs for dynamic creation of device nodes.
tar -xf /sources/eudev-*.tar.gz -C /tmp/ \
  && mv /tmp/eudev-* /tmp/eudev \
  && pushd /tmp/eudev

# apply fixes
sed -r -i 's|/usr(/bin/test)|\1|' test/udev-test.pl
# add a workaround to prevent the /tools directory from being hard coded
# into Eudev binary files library locations
cat > config.cache << EOF
HAVE_BLKID=1
BLKID_LIBS="-lblkid"
BLKID_CFLAGS="-I/tools/include"
EOF
./configure --prefix=/usr   \
    --bindir=/sbin          \
    --sbindir=/sbin         \
    --libdir=/usr/lib       \
    --sysconfdir=/etc       \
    --libexecdir=/lib       \
    --with-rootprefix=      \
    --with-rootlibdir=/lib  \
    --enable-manpages       \
    --disable-static        \
    --config-cache
LIBRARY_PATH=/tools/lib make
mkdir -pv /lib/udev/rules.d
mkdir -pv /etc/udev/rules.d
# test
# NOTE FAIL: udev-test.pl
if [ $LFS_TEST -eq 1 ]; then make LD_LIBRARY_PATH=/tools/lib check || true; fi
# install
make LD_LIBRARY_PATH=/tools/lib install
tar -xvf /sources/udev-lfs-20171102.tar.bz2
make -f udev-lfs-20171102/Makefile.lfs install
# create initial database
LD_LIBRARY_PATH=/tools/lib udevadm hwdb --update
# cleanup
popd \
  && rm -rf /tmp/eudev
