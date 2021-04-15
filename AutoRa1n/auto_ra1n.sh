#!/bin/bash

echo "PiRa1n: Waiting for an iDevice..."
while true; do
    # Enter recovery mode if iDevice is connected
    if idevice_id -l > /dev/null 2>&1 && [[ -n $(idevice_id -l) ]]; then
		echo "PiRa1n: Entering recovery mode..."
		ideviceenterrecovery "$(idevice_id -l)"
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
