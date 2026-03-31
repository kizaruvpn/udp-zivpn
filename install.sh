#!/usr/bin/env bash
set -e

CACHE_DIR="/etc/zivpn"
IP_FILE="$CACHE_DIR/ip.txt"
ISP_FILE="$CACHE_DIR/isp.txt"

mkdir -p "$CACHE_DIR"

# Ambil IP
IP=$(curl -4 -s ifconfig.me || curl -4 -s icanhazip.com)

# Ambil ISP (tanpa AS number)
ISP=$(curl -s ipinfo.io/org | cut -d " " -f 2-10)

# Default kalau gagal
IP=${IP:-N/A}
ISP=${ISP:-N/A}

# Simpan
echo "$IP"  > "$IP_FILE"
echo "$ISP" > "$ISP_FILE"

chmod 644 "$IP_FILE" "$ISP_FILE"

echo "================================="
echo "IP  : $IP"
echo "ISP : $ISP"
echo "Saved:"
echo " - $IP_FILE"
echo " - $ISP_FILE"
echo "================================="
echo

read -rp "Lanjutkan instalasi ZIVPN Manager? [Y/n]: " confirm
confirm=${confirm:-Y}

if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
  echo "❌ Instalasi dibatalkan."
  exit 0
fi

wget -q https://raw.githubusercontent.com/arivpnstores/udp-zivpn/main/zivpn-manager -O /usr/local/bin/zivpn-manager
chmod +x /usr/local/bin/zivpn-manager
/usr/local/bin/zivpn-manager