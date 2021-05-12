# opendroneid-wireshark-dissector

Wireshark dissector plugin to parse and analyze captured Open Drone ID packets

It currently only supports Wi-Fi Beacon, with changes on the way for Wi-Fi NAN and Bluetooth

### Guide

1. Get Wireshark to sniff using "monitor mode".  I had the most luck by doing the following:
    1. Install "[Acrylic Wi-Fi Sniffer](https://www.acrylicwifi.com/en/downloads-free-license-wifi-wireless-network-software-tools/download-acrylic-wi-fi-sniffer/)" (trial)
    2. Run Wireshark *as Administrator* (this is a must)
    3. Click on "Config Gear" next to Acrylic Wi-Fi Sniffer interface
    4. Many of the integrated Wi-Fi adapters will not support monitor mode, some USB adapters do.  I've had good luck with the ASUS 802.11n USB adapter.

2. Installation of dissector in Wireshark (Windows)
    1. If one does not exist, create 1 "plugins" folder under \\\<user dir\>\AppData\Roaming\Wireshark\ . You can find a link to this folder by clicking "Help->About->Folders->Personal Lua Plugins
    2. Clone this repo to that plugins folder
    3. While in Wireshark, press CTRL+SHIFT+L to re-read the new dissector(s)

![Wireshark Screenshot](https://github.com/opendroneid/wireshark-dissector/blob/main/img/screenshot.png)
