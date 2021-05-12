# opendroneid-wireshark-dissector

Wireshark dissector plugin to parse and analyze captured Open Drone ID packets

### Guide

1. Get Wireshark to sniff using "monitor mode".  I had the most luck by doing the following:
    1. Install "Acrylic Wi-Fi Sniffer" (trial)
    2. Run Wireshark *as Administrator* (this is a must)
    3. Click on "Config Gear" next to Acrylic Wi-Fi Sniffer interface
    4. Many of the integrated Wi-Fi adapters will not support monitor mode, some USB adapters do.  I've had good luck with the ASUS 802.11n USB adapter.

2. Installation of dissector (windows)
    1. If one does not exist, create 1 "plugins" folder under \\\<user dir\>\AppData\Roaming\Wireshark\
    2. Clone this repo to that plugins folder

![Wireshark Screenshot](https://github.com/opendroneid/wireshark-dissector/blob/main/img/screenshot.png)
