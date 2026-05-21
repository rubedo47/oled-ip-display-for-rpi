import time
import socket
import netifaces
import psutil
from PIL import Image, ImageDraw, ImageFont
import board
import busio
import adafruit_ssd1306

# OLED display size
WIDTH = 128
HEIGHT = 64

# Initialize I2C
i2c = busio.I2C(board.SCL, board.SDA)

# Initialize OLED
oled = adafruit_ssd1306.SSD1306_I2C(WIDTH, HEIGHT, i2c)

# Clear display
oled.fill(0)
oled.show()

# Create blank image for drawing
image = Image.new("1", (WIDTH, HEIGHT))
draw = ImageDraw.Draw(image)

# Load default font
font = ImageFont.load_default()


def get_ip_address():
    """Get Raspberry Pi IP address."""
    interfaces = netifaces.interfaces()

    for interface in interfaces:
        if interface == "lo":
            continue

        addrs = netifaces.ifaddresses(interface)

        if netifaces.AF_INET in addrs:
            ip_info = addrs[netifaces.AF_INET][0]
            return ip_info.get("addr", "No IP")

    return "No Network"


def get_cpu_temp():
    """Read CPU temperature."""
    try:
        with open("/sys/class/thermal/thermal_zone0/temp", "r") as f:
            temp = float(f.read()) / 1000.0
            return f"{temp:.1f}C"
    except:
        return "N/A"


def get_memory_usage():
    """Get RAM usage percentage."""
    memory = psutil.virtual_memory()
    return f"{memory.percent}%"


while True:
    # Clear drawing area
    draw.rectangle((0, 0, WIDTH, HEIGHT), outline=0, fill=0)

    hostname = socket.gethostname()
    ip = get_ip_address()
    cpu_temp = get_cpu_temp()
    mem_usage = get_memory_usage()

    # Draw text
    draw.text((0, 0), "Raspberry Pi", font=font, fill=255)
    draw.text((0, 16), f"Host: {hostname}", font=font, fill=255)
    draw.text((0, 28), f"IP: {ip}", font=font, fill=255)
    draw.text((0, 40), f"TEMP: {cpu_temp}  RAM: {mem_usage}", font=font, fill=255)

    # Display image
    oled.image(image)
    oled.show()

    # Refresh every 5 seconds
    time.sleep(5)
