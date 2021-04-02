#!/bin/bash

if [ `id -u` -ne 0 ];
then
	echo 'Run as root!'
	exit 1
fi

apt-get update
apt-get -y upgrade
apt-get -y install libssl-dev libtool make autoconf pkg-config vim tmux git build-essential libxml2-dev python2.7 python2.7-dev fuse libtool autoconf libusb-1.0-0-dev libfuse-dev python-dev python3-dev acl
apt-get -y install libcurl4-nss-dev libzip-dev libreadline-dev

export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig
echo "export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig" |  tee -a /etc/bash.bashrc

mkdir iphone_libs 
cd iphone_libs

idevice_id -h  2>&1 >/dev/null
if [ $? -ne 0 ];
then
	git clone https://github.com/libimobiledevice/libplist.git
	git clone https://github.com/libimobiledevice/libusbmuxd.git
	git clone https://github.com/libimobiledevice/usbmuxd.git
	git clone https://github.com/libimobiledevice/libimobiledevice.git
	git clone https://github.com/libimobiledevice/ifuse.git

	cd libplist && ./autogen.sh && make &&  make install && cd ..
	cd libusbmuxd && ./autogen.sh && make &&  make install && cd ..
	cd libimobiledevice && ./autogen.sh && make &&  make install && cd ..
	cd usbmuxd && ./autogen.sh && make &&  make install && cd ..
	cd ifuse && ./autogen.sh && make &&  make install && cd ..

	groupadd -g 140 usbmux &>/dev/null
	useradd -c 'usbmux user' -u 140 -g usbmux -d / -s /sbin/nologin usbmux &>/dev/null
	passwd -l usbmux &>/dev/null
fi

idevicerestore -h 2>&1 >/dev/null
if [ $? -ne 0 ];
then

	git clone https://github.com/libimobiledevice/libirecovery
	cd libirecovery && ./autogen.sh && make && make install && cd ..

	git clone https://github.com/libimobiledevice/idevicerestore
	cd idevicerestore && ./autogen.sh && make && make install && cd ..
fi

idevicerestore -h  2>&1 >/dev/null
if [ $? -ne 0 ];
then
	git clone https://github.com/libimobiledevice/ideviceinstaller
	cd ideviceinstaller && ./autogen.sh && make && make install && cd ..
fi

ideviceactivation -h 2>&1  >/dev/null 
if [ $? -ne 0 ];
then
	git clone https://github.com/libimobiledevice/libideviceactivation
	cd libideviceactivation && ./autogen.sh && make && make install && cd ..
fi

echo /usr/local/lib |  tee /etc/ld.so.conf.d/libimobiledevice-libs.conf
 ldconfig
echo 'Hopefully all done. Please reboot!'
