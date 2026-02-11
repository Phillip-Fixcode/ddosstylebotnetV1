#!/bin/bash

# ZX3-God Installer for Kali Linux
# Run: sudo bash install.sh

echo -e "\033[1;36m"
echo "╔══════════════════════════════════════════════════╗"
echo "║             ZX3-God Installation                 ║"
echo "╚══════════════════════════════════════════════════╝"
echo -e "\033[0m"

# Check if running as root
if [[ $EUID -ne 0 ]]; then
   echo -e "\033[1;31m[!] Please run as root (sudo bash install.sh)\033[0m"
   exit 1
fi

# Update system
echo -e "\033[1;33m[*] Updating system...\033[0m"
apt update && apt upgrade -y

# Install Python and pip
echo -e "\033[1;33m[*] Installing Python and pip...\033[0m"
apt install -y python3 python3-pip python3-dev python3-venv

# Install system dependencies
echo -e "\033[1;33m[*] Installing system dependencies...\033[0m"
apt install -y build-essential libssl-dev libffi-dev
apt install -y wget curl git nmap net-tools
apt install -y chromium chromium-driver

# Install Python packages
echo -e "\033[1;33m[*] Installing Python packages...\033[0m"
pip3 install --upgrade pip
pip3 install requests cloudscraper undetected-chromedriver
pip3 install colorama httpx PySocks fake-useragent
pip3 install aiohttp asyncio numpy

# Create directories
echo -e "\033[1;33m[*] Creating directories...\033[0m"
mkdir -p ./resources
mkdir -p ./logs

# Download user agents database
echo -e "\033[1;33m[*] Downloading user agents database...\033[0m"
wget -O ./resources/ua.txt https://raw.githubusercontent.com/fmstrat/ua/master/all.txt

# Create proxy file
echo -e "\033[1;33m[*] Creating proxy file...\033[0m"
touch ./proxy.txt
echo "# Add your proxies here (one per line)" > ./proxy.txt
echo "# Format: ip:port" >> ./proxy.txt
echo "123.123.123.123:8080" >> ./proxy.txt

# Create configuration file
echo -e "\033[1;33m[*] Creating configuration file...\033[0m"
cat > config.json << EOF
{
    "zx3_config": {
        "max_threads": 50000,
        "udp_packet_size": 65507,
        "timeout": 3,
        "proxy_sources": [
            "https://api.proxyscrape.com/v2/",
            "https://raw.githubusercontent.com/TheSpeedX/SOCKS-List/master/",
            "https://www.proxy-list.download/"
        ],
        "auto_update": true,
        "log_level": "INFO"
    }
}
EOF

# Optimize system for performance
echo -e "\033[1;33m[*] Optimizing system performance...\033[0m"
sysctl -w net.ipv4.tcp_tw_reuse=1
sysctl -w net.ipv4.tcp_syncookies=0
sysctl -w net.core.somaxconn=8192
sysctl -w net.ipv4.tcp_max_syn_backlog=8192
ulimit -n 65536

# Set permissions
echo -e "\033[1;33m[*] Setting permissions...\033[0m"
chmod +x main.py
chmod +x install.sh

# Create launcher script
echo -e "\033[1;33m[*] Creating launcher script...\033[0m"
cat > zx3 << EOF
#!/bin/bash
python3 $(pwd)/main.py \$@
EOF
chmod +x zx3
mv zx3 /usr/local/bin/

echo -e "\033[1;32m"
echo "╔══════════════════════════════════════════════════╗"
echo "║           Installation Complete!                 ║"
echo "╚══════════════════════════════════════════════════╝"
echo -e "\033[0m"
echo ""
echo -e "\033[1;36m[*] Quick Start:\033[0m"
echo -e "  \033[1;33m1. Add proxies to proxy.txt file\033[0m"
echo -e "  \033[1;33m2. Run: python3 main.py\033[0m"
echo -e "  \033[1;33m3. Or use: zx3 (from anywhere)\033[0m"
echo ""
echo -e "\033[1;31m[*] Legal Notice:\033[0m"
echo -e "  This tool is for authorized testing only!"
echo -e "  Use only on systems you own or have permission to test."