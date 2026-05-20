#!/bin/bash

set -e

echo "Updating package lists..."
sudo apt-get update

echo "Installing required system packages..."
sudo apt-get install -y \
    python3-pip \
    python3-setuptools \
    python3-pillow \
    git \
    wget \
    i2c-tools

echo "Upgrading pip..."
python3 -m pip install --upgrade pip --break-system-packages

echo "Installing Adafruit Python shell..."
python3 -m pip install --upgrade \
    adafruit-python-shell \
    --break-system-packages

# Download Blinka installer script if not already downloaded
if [ ! -f "raspi-blinka.py" ]; then
    echo "Downloading raspi-blinka.py..."
    wget https://raw.githubusercontent.com/adafruit/Raspberry-Pi-Installer-Scripts/master/raspi-blinka.py
fi

echo "Running Blinka installer..."
printf 'n\n' | sudo -E env PATH=$PATH python3 raspi-blinka.py

echo "Installing CircuitPython libraries..."
python3 -m pip install --upgrade \
    adafruit_blinka \
    adafruit-circuitpython-ssd1306 \
    netifaces \
    --break-system-packages

# Download gets the rest of the github repo
    echo "Downloading the rest of the repo..."
#    git clone https://github.com/Wm-Mason-Cyber/oled-ip-display-for-rpi
    git clone https://github.com/rubedo47/oled-ip-display-for-rpi

echo "Checking for OLED display on I2C bus..."
sudo i2cdetect -y 1

echo ""
echo "If you do NOT see address 3c:"
echo "Run: sudo raspi-config"
echo "Then enable (I2C):"
echo "Interface Options -> I2C -> Yes"
echo "Check the OLED screen connection"

echo ""
echo "Setup complete."

#runs the ip.py automatically
cd oled-ip-display-for-rpi
python3 ip.py
