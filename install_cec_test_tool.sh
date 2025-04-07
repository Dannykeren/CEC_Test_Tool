{\rtf1\ansi\ansicpg1252\cocoartf2821
\cocoatextscaling0\cocoaplatform0{\fonttbl\f0\fnil\fcharset0 HelveticaNeue;}
{\colortbl;\red255\green255\blue255;\red255\green255\blue255;\red27\green27\blue32;}
{\*\expandedcolortbl;;\cssrgb\c100000\c100000\c100000;\cssrgb\c14118\c14118\c16863\c20000;}
\paperw11900\paperh16840\margl1440\margr1440\vieww23020\viewh22440\viewkind0
\deftab720
\pard\pardeftab720\partightenfactor0

\f0\fs28 \cf2 \expnd0\expndtw0\kerning0
\
\cb3 #!/bin/bash\cb1 \
\
\cb3 # Check for root/sudo privileges\cb1 \
\cb3 if [[ $EUID -ne 0 ]]; then\cb1 \
\cb3  \'a0 \'a0echo "This script must be run with sudo or as root" \cb1 \
\cb3  \'a0 \'a0exit 1\cb1 \
\cb3 fi\cb1 \
\
\cb3 # Update package lists\cb1 \
\cb3 echo "Updating package lists..."\cb1 \
\cb3 sudo apt update\cb1 \
\
\cb3 # Install necessary packages\cb1 \
\cb3 echo "Installing required packages..."\cb1 \
\cb3 sudo apt install apache2 php libapache2-mod-php pigpio hostapd dnsmasq -y\cb1 \
\
\cb3 # Start pigpio service\cb1 \
\cb3 echo "Starting pigpio service..."\cb1 \
\cb3 sudo systemctl enable pigpiod\cb1 \
\cb3 sudo systemctl start pigpiod\cb1 \
\
\cb3 # Configure GPIO pins (Example: GPIO 17, 18, 22, 23)\cb1 \
\cb3 # You can modify this based on your GPIO pin requirements\cb1 \
\cb3 echo "Configuring GPIO pins..."\cb1 \
\cb3 sudo echo "17" > /sys/class/gpio/export\cb1 \
\cb3 sudo echo "18" > /sys/class/gpio/export\cb1 \
\cb3 sudo echo "22" > /sys/class/gip/export\cb1 \
\cb3 sudo echo "23" > /sys/class/gpio/export\cb1 \
\
\cb3 # Create a directory for the webpage files\cb1 \
\cb3 echo "Creating directory for the webpage files..."\cb1 \
\cb3 sudo mkdir /var/www/html/cectest\cb1 \
\
\cb3 # Copy webpage files to the directory /var/www/html/cectest\cb1 \
\cb3 # You can place your custom webpage files here\cb1 \
\
\cb3 # Configure hostapd for the WiFi Access Point\cb1 \
\cb3 echo "Configuring hostapd for WiFi Access Point..."\cb1 \
\cb3 sudo cat << EOF | sudo tee /etc/hostapd/hostapd.conf\cb1 \
\cb3 interface=wlan0\cb1 \
\cb3 ssid=CECTestTool\cb1 \
\cb3 hw_mode=g\cb1 \
\cb3 channel=7\cb1 \
\cb3 auth_algs=1\cb1 \
\cb3 wpa=2\cb1 \
\cb3 wpa_passphrase=0545533896\cb1 \
\cb3 wpa_key_mgmt=WPA-PSK\cb1 \
\cb3 wpa_pairwise=TKIP\cb1 \
\cb3 rsn_pairwise=CCMP\cb1 \
\cb3 EOF\cb1 \
\
\cb3 # Configure dnsmasq for the WiFi Access Point\cb1 \
\cb3 echo "Configuring dnsmasq for WiFi Access Point..."\cb1 \
\cb3 sudo cat << EOF | sudo tee /etc/dnsmasq.conf\cb1 \
\cb3 interface=wlan0\cb1 \
\cb3 dhcp-range=192.168.12.51,192.168.12.90,255.255.255.0,24h\cb1 \
\cb3 EOF\cb1 \
\
\cb3 # Restart services\cb1 \
\cb3 echo "Restarting services..."\cb1 \
\cb3 sudo systemctl restart hostapd\cb1 \
\cb3 sudo systemctl restart dnsmasq\cb1 \
\cb3 sudo systemctl restart apache2\cb1 \
\
\cb3 echo "Installation and configuration completed. CEC Test Tool setup is ready."}