#!/bin/bash

# <xbar.title>Network Status</xbar.title>
# <xbar.version>v2.1</xbar.version>
# <xbar.author>Hossein Aarabi</xbar.author>
# <xbar.desc>Monitors internet, VPN, Wi-Fi, Ethernet, latency, IP, DNS, gateway, and packet loss. Includes manual speed test trigger.</xbar.desc>
# <xbar.refreshTime>30s</xbar.refreshTime>

notify() {
  osascript -e "display notification \"$1\" with title \"Network Alert\""
}

# ✅ Top Bar Status
if [[ "$PING_OK" -eq 0 && "$DNS_OK" -eq 0 ]]; then
  echo "✅ Internet OK"
else
  echo "❌ No Internet"
fi

echo "---"

# ⚡️ Speedtest Trigger (manual)
echo "⚡️ Run Speed Test | bash='$HOME/bin/tools/xbar/xbar-speedtest.sh' terminal=true refresh=true"

echo "---"

# 🔐 VPN
# Look for an active utun interface with an IP address assigned
VPN_STATE="disconnected"

# Scan all utun interfaces and check if any has an active IP address
for iface in $(ifconfig | awk -F: '/^utun[0-9]+:/ {print $1}'); do
  if ifconfig "$iface" | grep -q "inet "; then
    VPN_STATE="connected"
    break
  fi
done

# Output VPN status
if [[ "$VPN_STATE" == "connected" ]]; then
  echo "🛡️ VPN: Connected"
else
  echo "🛡️ VPN: Not Connected"
fi

# Notification on VPN disconnection
VPN_STATUS_FILE="/tmp/.xbar-vpn-status"
if [[ -f "$VPN_STATUS_FILE" ]]; then
  LAST_VPN_STATE=$(<"$VPN_STATUS_FILE")
else
  LAST_VPN_STATE=""
fi

if [[ "$VPN_STATE" != "$LAST_VPN_STATE" && "$VPN_STATE" == "disconnected" ]]; then
  notify "VPN is disconnected"
fi

echo "$VPN_STATE" > "$VPN_STATUS_FILE"

# 📶 Network Interfaces
# Track Wi-Fi status and notify only on change
WIFI_DEVICE=$(networksetup -listallhardwareports | awk '/Wi-Fi/{getline; print $2}')
WIFI_STATUS=$(networksetup -getairportpower "$WIFI_DEVICE" 2>/dev/null | awk '{print $NF}')
WIFI_STATUS_FILE="/tmp/.xbar-wifi-status"
WIFI_STATE="off"
if [[ "$WIFI_STATUS" == "On" ]]; then
  WIFI_STATE="on"
  echo "📶 Wi-Fi: $WIFI_DEVICE (active)"
else
  echo "📶 Wi-Fi: $WIFI_DEVICE (off)"
fi

if [[ -f "$WIFI_STATUS_FILE" ]]; then
  LAST_WIFI_STATE=$(<"$WIFI_STATUS_FILE")
else
  LAST_WIFI_STATE=""
fi

if [[ "$WIFI_STATE" != "$LAST_WIFI_STATE" && "$WIFI_STATE" == "off" ]]; then
  notify "Wi-Fi is disconnected"
fi

echo "$WIFI_STATE" > "$WIFI_STATUS_FILE"

# Better Ethernet detection (include all active non-Wi-Fi en* devices)
ETHERNET_ACTIVE=()
for iface in $(networksetup -listallhardwareports | awk '/Device/ {print $2}'); do
  # Skip if it's the known Wi-Fi device
  if [[ "$iface" == "$WIFI_DEVICE" ]]; then
    continue
  fi

  # Check if active and is an enX interface
  if [[ "$iface" == en* ]] && ifconfig "$iface" | grep -q "status: active"; then
    ETHERNET_ACTIVE+=("$iface")
  fi
done

if [[ ${#ETHERNET_ACTIVE[@]} -gt 0 ]]; then
  for eth in "${ETHERNET_ACTIVE[@]}"; do
    echo "🔌 Ethernet: $eth ✅"
  done
else
  echo "❌ Ethernet: Disconnected"
fi

echo "---"

# 🌍 Connectivity
PING_TARGET="8.8.8.8"
DNS_TARGET="google.com"
ping -q -t 1 -c 1 "$PING_TARGET" &>/dev/null || curl -s --max-time 2 https://www.google.com >/dev/null; PING_OK=$?
dig +short "$DNS_TARGET" &>/dev/null; DNS_OK=$?
LATENCY=$(ping -c 1 "$PING_TARGET" | grep 'time=' | awk -F'time=' '{print $2}' | cut -d' ' -f1)
PUBLIC_IP=$(curl -s ifconfig.me)
GATEWAY=$(netstat -rn | awk '/default/ {print $2}' | head -n 1)

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
