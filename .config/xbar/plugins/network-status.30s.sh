#!/bin/bash

# <xbar.title>Network Status</xbar.title>
# <xbar.version>v2.1</xbar.version>
# <xbar.author>Hossein Aarabi</xbar.author>
# <xbar.desc>Monitors internet, VPN, Wi-Fi, Ethernet, latency, IP, DNS, gateway, and packet loss. Includes manual speed test trigger.</xbar.desc>
# <xbar.refreshTime>30s</xbar.refreshTime>

notify() {
  osascript -e "display notification \"$1\" with title \"Network Alert\""
}

# 🔌 Network Interfaces
WIFI_DEVICE=$(networksetup -listallhardwareports | awk '/Wi-Fi/{getline; print $2}')
WIFI_STATUS=$(networksetup -getairportpower "$WIFI_DEVICE" 2>/dev/null | awk '{print $NF}')
ETHERNET_ACTIVE=""
for iface in $(ifconfig -l | grep -E '^en[0-9]+$'); do
  if ifconfig "$iface" | grep -q "status: active"; then
    ETHERNET_ACTIVE="$iface"
    break
  fi
done

# 🌍 Connectivity
PING_TARGET="8.8.8.8"
DNS_TARGET="google.com"
ping -q -t 1 -c 1 "$PING_TARGET" &>/dev/null || curl -s --max-time 2 https://www.google.com >/dev/null; PING_OK=$?
dig +short "$DNS_TARGET" &>/dev/null; DNS_OK=$?
LATENCY=$(ping -c 1 "$PING_TARGET" | grep 'time=' | awk -F'time=' '{print $2}' | cut -d' ' -f1)
PUBLIC_IP=$(curl -s ifconfig.me)
GATEWAY=$(netstat -rn | awk '/default/ {print $2}' | head -n 1)

# 🔐 VPN
VPN_NAME=$(scutil --nc list | awk -F'"' '/Connected/ {print $2}' | head -n1)

# ✅ Top Bar Status
if [[ "$PING_OK" -eq 0 && "$DNS_OK" -eq 0 ]]; then
  echo "✅ Internet OK"
else
  echo "❌ No Internet"
fi

echo "---"

# ⚡️ Speedtest Trigger (manual)
echo "⚡️ Run Speed Test | bash='$HOME/bin/tools/xbar-scripts/xbar-speedtest.sh' terminal=true refresh=true"

echo "---"

# 🔐 VPN
if [[ -n "$VPN_NAME" ]]; then
  echo "🛡️ VPN: $VPN_NAME (Connected)"
else
  echo "🛡️ VPN: Not Connected"
  notify "VPN is disconnected"
fi

# 📶 Interfaces
if [[ "$WIFI_STATUS" == "On" ]]; then
  echo "📶 Wi-Fi: $WIFI_DEVICE (active)"
else
  echo "📶 Wi-Fi: $WIFI_DEVICE (off)"
  notify "Wi-Fi is disconnected"
fi

if [[ -n "$ETHERNET_ACTIVE" ]]; then
  echo "🔌 Ethernet: $ETHERNET_ACTIVE ✅"
else
  echo "❌ Ethernet: Disconnected"
fi

echo "---"

# 🌍 Diagnostics
if [[ "$PING_OK" -eq 0 ]]; then
  echo "🌍 Ping: $PING_TARGET ✅"
else
  echo "🌍 Ping: $PING_TARGET ❌"
  notify "Internet is down (ping failed)"
fi

if [[ "$DNS_OK" -eq 0 ]]; then
  echo "🔎 DNS: $DNS_TARGET ✅"
else
  echo "🔎 DNS: $DNS_TARGET ❌"
  notify "DNS resolution is failing"
fi

if [[ -n "$LATENCY" ]]; then
  echo "⏱️ Latency: ${LATENCY} ms"
fi

if [[ -n "$PUBLIC_IP" ]]; then
  echo "🌐 Public IP: $PUBLIC_IP"
fi

if [[ -n "$GATEWAY" ]]; then
  echo "📦 Gateway: $GATEWAY"
fi

echo "---"

# 🧭 Local IPs (interface labeled)
for iface in $(ifconfig -l | tr ' ' '\n' | grep -E '^en[0-9]+$'); do
  ip=$(ipconfig getifaddr "$iface" 2>/dev/null)
  if [[ -n "$ip" ]]; then
    echo "🧭 $iface: $ip"
  fi
done

echo "---"

# 📡 Packet Loss
LOSS=$(ping -c 10 "$PING_TARGET" | tail -2 | head -1 | awk -F, '{print $3}' | awk '{print $1}')
echo "📡 Packet Loss: $LOSS"
if [[ "${LOSS%\%}" -gt 5 ]]; then
  notify "⚠️ Packet loss is above 5%"
fi
