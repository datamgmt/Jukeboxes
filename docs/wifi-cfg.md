# WiFi Configuration

> [!WARNING]
> This project is under development and currently largely untested.
> It is being documented as if finished but may be revised before the project is complete.
> You are advised not to use this project until this warning is removed

*wifi-cfg* is a utility to allow the WiFi of a Raspberry Pi to be configured on first boot.

It configures a default WiFi access point named RaspberryPi-Setup.
This allows you to log in via a web page and configure the Raspberry Pi to connect to your local network

## Installation

Run the installation script on your fresh Raspberry Pi and then reboot:

```
chmod +x wifi-cfg.sh
sudo ./wifi-cfg.sh
sudo reboot
```

This is normally done when creating an image for distribution

## Usage

This is normally done by the user who is running the Raspberry Pi

* Look for the RaspberryPi-Setup WiFi network
* Connect using the defauklt password `raspberry`
* Open a browser and go to http://192.168.4.1
* Click "Scan for Networks"
* Select your network and enter the password
* Click "Connect to Network"
* The Pi will reboot and join your main network

The setup only runs once - after configuration, it permanently switches to normal WiFi client mode!

## Customization

You can modify these settings in the script:

AP SSID: Change ssid=RaspberryPi-Setup in hostapd.conf
AP Password: Change wpa_passphrase=raspberry in hostapd.conf
IP Address: Change 192.168.4.1 throughout if needed
Country Code: Change country=US in wpa_supplicant config


