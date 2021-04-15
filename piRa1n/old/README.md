# DONT USE THIS :) USE: "../install.sh" INSTEAD

1. 
	download checkra1n arm 

2.
	scp checkra1n binary to rpi:
	```
	scp <path-of-checkra1n-binary>/checkra1n_<version>_armv7 root@<local-pi-ip-address>:~/
	```
3.
	log with ssh to your raspberry pi from your pc terminal:
	`ssh pi@<local-pi-ip-address>`
4.
	Create checkra1n user:
	```bash
	adduser checkra1n
	usermod -aG sudo checkra1n
	```
4.
	Create two files:
	- Open `auto_ra1n.sh` and paste this:
	```
	#!/bin/bash
	pkill checkra1n
	sudo /home/checkra1n/checkra1n_<version>_armv7 -c
	```
	- Reopen `01-checkra1n.rules` and paste this in one line:
	```
	ACTION=="add", ATTRS{idVendor}=="05ac", ATTRS{idProduct}=="1227", RUN+="/bin/bash /home/checkra1n/auto_ra1n.sh"
	```

5.
	move `auto_ra1n.sh` to `/home/checkra1n/`:
	`sudo mv ~/auto_ra1n.sh /home/checkra1n/`

	chmod it to make it runnable:
	`sudo chmod +x /home/checkra1n/auto_ra1n.sh`

6.
	add the script to sudoers by running sudo visudo and paste below
	```
	# Allow members of group sudo to execute any command
	%sudo ALL=(ALL:ALL) ALL
	```
	the line:
	`checkra1n ALL=(ALL) NOPASSWD: /home/checkra1n/auto_ra1n.sh`
	then ctrl+x to exit, then hit Y and then hit Enter.

7.
	put checkra1n binary file inside /home/checkra1n/checkra1n directory:
	`sudo mv ~/checkra1n_<version>_armv7 /home/checkra1n/checkra1n`

8.
	put the .rules file inside udev rules directory:
	`sudo mv /home/pi/01-checkra1n.rules /etc/udev/rules.d`
	reboot your pi:
	`sudo reboot`
```

Just connect the iPhone in DFU mode and chackra1n at `/home/checkra1n/` will 
be executed automatically.

Issue `lsusb` command to watch the iphone's status..
You can also check the progess at `tail -F /var/log/syslog`, however
beware the long output especially at heap spraying stage..

https://www.reddit.com/r/jailbreak/comments/f0qpt8/tutorial_how_to_setup_raspberry_pi_to_launch/
