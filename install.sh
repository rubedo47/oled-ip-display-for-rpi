#!/bin/bash

set -e

echo "Updating package lists..."
sudo apt-get update

echo "Installing required system packages..."
sudo apt-get install -y \
    python3-pip \
    python3-setuptools \
    python3-venv \
    python3-pil \
    git \
    wget \
    i2c-tools

# Create virtual environment if it doesn't exist
if [ ! -d "stats_env" ]; then
    echo "Creating Python virtual environment..."
    python3 -m venv stats_env --system-site-packages
fi

echo "Activating virtual environment..."
source stats_env/bin/activate

echo "Upgrading pip..."
pip3 install --upgrade pip

echo "Installing Adafruit Python shell..."
pip3 install --upgrade adafruit-python-shell

# Download Blinka installer script if not already downloaded
if [ ! -f "raspi-blinka.py" ]; then
    echo "Downloading raspi-blinka.py..."
    wget https://raw.githubusercontent.com/adafruit/Raspberry-Pi-Installer-Scripts/master/raspi-blinka.py
fi

echo "Running Blinka installer..."
printf 'n\n' | sudo -E env PATH=$PATH python3 raspi-blinka.py

echo "Installing CircuitPython libraries..."
pip3 install --upgrade adafruit_blinka
pip3 install adafruit-circuitpython-ssd1306

echo "Installing netifaces"
pip3 install netifaces

echo "Checking for OLED display on I2C bus..."
sudo i2cdetect -y 1

echo ""
echo "If you do NOT see address 3c:"
echo "Run: sudo raspi-config"
echo "Then enable:"
echo "3 Interface Options -> I5 I2C -> Yes"
echo "Also fix connection of screen"

# Clone repository if not already present
if [ ! -d "oled-tests" ]; then
    echo "Cloning OLED test repository..."
    git clone https://github.com/Wm-Mason-Cyber/oled-ip-display-for-rpi
fi
echo "Entering project directory..."
cd oled-ip-display-for-rpi

echo ""
echo "Setup complete."
echo ""
echo "SDA >>> 1"
echo "SCL >>> 3"
echo "VCC >>> 5"
echo "GND >>> 6"
echo ""
echo "2 4 6"
echo "1 3 5"

