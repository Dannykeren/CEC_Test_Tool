
#!/bin/bash

# Check for root/sudo privileges
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run with sudo or as root" 
    exit 1
fi

# Update package lists
echo "Updating package lists..."
sudo apt update

# Install necessary packages
echo "Installing required packages..."
sudo apt install apache2 php libapache2-mod-php pigpio hostapd dnsmasq -y

# Start pigpio service
echo "Starting pigpio service..."
sudo systemctl enable pigpiod
sudo systemctl start pigpiod

# Configure GPIO pins (Example: GPIO 17, 18, 22, 23)
# You can modify this based on your GPIO pin requirements
echo "Configuring GPIO pins..."
sudo echo "17" > /sys/class/gpio/export
sudo echo "18" > /sys/class/gpio/export
sudo echo "22" > /sys/class/gip/export
sudo echo "23" > /sys/class/gpio/export

# Create a directory for the webpage files
echo "Creating directory for the webpage files..."
sudo mkdir /var/www/html/cectest

# Copy webpage files to the directory /var/www/html/cectest
# You can place your custom webpage files here

# Configure hostapd for the WiFi Access Point
echo "Configuring hostapd for WiFi Access Point..."
sudo cat << EOF | sudo tee /etc/hostapd/hostapd.conf
interface=wlan0
ssid=CECTestTool
hw_mode=g
channel=7
auth_algs=1
wpa=2
wpa_passphrase=0545533896
wpa_key_mgmt=WPA-PSK
wpa_pairwise=TKIP
rsn_pairwise=CCMP
EOF

# Configure dnsmasq for the WiFi Access Point
echo "Configuring dnsmasq for WiFi Access Point..."
sudo cat << EOF | sudo tee /etc/dnsmasq.conf
interface=wlan0
dhcp-range=192.168.12.51,192.168.12.90,255.255.255.0,24h
EOF

# Restart services
echo "Restarting services..."
sudo systemctl restart hostapd
sudo systemctl restart dnsmasq
sudo systemctl restart apache2

echo "Installation and configuration completed. CEC Test Tool setup is ready."
