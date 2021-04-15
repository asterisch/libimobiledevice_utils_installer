# piRa1n (Raspberry Pi 4)

First run: `install_all_libimobiledevice.sh`.
Then install piRa1n:
```
cd piRa1n
./install.sh
```
To confirm that the service is running as expected monitor logs with:
```
journalctl -u piRa1n -f
```

## libimobiledevice + utils installer

Currently only for Linux!

Thanks to: 
- https://github.com/libimobiledevice
- https://github.com/raspberryenvoie/piRa1n
- https://www.reddit.com/r/jailbreak/comments/f0qpt8/tutorial_how_to_setup_raspberry_pi_to_launch/
