#!/bin/bash
if [ `id -u` -ne 0 ];
then
	echo 'Run as root!'
	exit 1
fi

INSTALL_DIR='/opt/piRa1n'
mkdir -p ${INSTALL_DIR}
CHECKRAIN_BIN='checkra1n_12_2_arm64'

# Update the system and install the dependencies
apt-get update
apt-get -y upgrade
apt-get -y install libssl-dev libtool make autoconf pkg-config vim tmux git build-essential libxml2-dev python2.7 python2.7-dev fuse libtool autoconf libusb-1.0-0-dev libfuse-dev python-dev python3-dev acl
apt-get -y install libcurl4-nss-dev libzip-dev libreadline-dev libusb-1.0-0-dev libusbmuxd-tools 

# Compile libirecovery
irecovery -h 2>&1 >/dev/null
if [ $? -ne 0 ];
then
	git clone https://github.com/libimobiledevice/libirecovery
	cd libirecovery && ./autogen.sh && make && make install && cd ..
	ldconfig
fi 

cp -r ${CHECKRAIN_BIN} ${INSTALL_DIR}

# Create daemon script (startup)
cat << EOF > ${INSTALL_DIR}/startup.sh
#!/bin/bash

echo "PiRa1n: Waiting for an iDevice..."
while true; do
    # Enter recovery mode if iDevice is connected
    if idevice_id -l > /dev/null 2>&1 && [[ -n \$(idevice_id -l) ]]; then
		echo "PiRa1n: Entering recovery mode..."
		ideviceenterrecovery "\$(idevice_id -l)"
		sleep 4
    # Check if iDevice is in recovery mode
    elif lsusb | grep -q 'Recovery'; then
		echo "PiRa1n: iDevice is in recovery mode."
		/usr/local/bin/irecovery -c 'setenv auto-boot true'
		/usr/local/bin/irecovery -c 'saveenv'
		#/usr/local/bin/irecovery -c 'reboot'
      	sleep 16
    # Check if iDevice is in DFU mode
    elif lsusb | grep -q 'DFU'; then
    	echo "PiRa1n: iDevice is in DFU mode."
		sudo pkill -9 ${CHECKRAIN_BIN}
		sleep 2
		${INSTALL_DIR}/${CHECKRAIN_BIN} -c
    else
      sleep 1
	fi
done
EOF


# Enable piRa1n at startup
cat << EOF > /etc/systemd/system/piRa1n.service
[Unit]
Description=piRa1n
After=multi-user.target
[Service]
ExecStart=${INSTALL_DIR}/startup.sh
[Install]
WantedBy=multi-user.target
EOF

# Fix file permissions
chown -R 1000:1000 ${INSTALL_DIR}
chmod -R 755 ${INSTALL_DIR}
chmod +x ${INSTALL_DIR}/${CHECKRAIN_BIN}
chmod +x ${INSTALL_DIR}/startup.sh
chmod 644 /etc/systemd/system/piRa1n.service

# Enable service
systemctl daemon-reload
systemctl enable piRa1n.service
systemctl start piRa1n.service
systemctl status piRa1n
