#!/bin/bash
# <xbar.title>Network Monitor</xbar.title>
# <xbar.version>v1.0</xbar.version>
# <xbar.author>H.A.</xbar.author>
# <xbar.desc>Shows Wi-Fi, DNS, and Internet health</xbar.desc>
# <xbar.refreshTime>1m</xbar.refreshTime>

WIFI_DEVICE=$(networksetup -listallhardwareports | awk '/Wi-Fi|AirPort/{getline; print $2}')
WIFI_STATUS=$(ifconfig "$WIFI_DEVICE" 2>/dev/null | grep status: | awk '{print $2}')

PING_TARGET="8.8.8.8"
DNS_TARGET="google.com"

# Check Internet
ping -c 1 -W 1 $PING_TARGET &>/dev/null
INTERNET_UP=$?

# Check DNS
dig $DNS_TARGET +short +time=1 | grep -q '[0-9]'
DNS_UP=$?

notify() {
  osascript -e "display notification \"$1\" with title \"Network Alert\""
}

# Output to xbar menu bar
if [[ "$WIFI_STATUS" != "active" ]]; then
  echo "📡 Wi-Fi: Disconnected"
  echo "---"
  echo "❌ No Wi-Fi interface"
  notify "Wi-Fi is disconnected"
elif [[ $INTERNET_UP -ne 0 ]]; then
  echo "🌍 Internet: 🔴 Down"
  echo "---"
  echo "❌ Cannot reach $PING_TARGET"
  notify "Internet is down"
elif [[ $DNS_UP -ne 0 ]]; then
  echo "🔎 DNS: 🔴 Broken"
  echo "---"
  echo "❌ DNS lookup for $DNS_TARGET failed"
  notify "DNS resolution is failing"
else
  echo "✅ Internet OK"
  echo "---"
  echo "📶 Wi-Fi: $WIFI_DEVICE ($WIFI_STATUS)"
  echo "🌍 Ping: $PING_TARGET ✅"
  echo "🔎 DNS: $DNS_TARGET ✅"
fi
