#!/usr/bin/env bash
# vpn-wake-fix.sh v2 — Light-touch wake cleanup for AWS VPN Client
# Only cleans up stale network state; does NOT kill the VPN client.
# The client handles its own reconnection once the stale state is gone.

LOG_TAG="vpn-wake-fix"
log() { logger -t "$LOG_TAG" "$1"; }

log "Wake detected — starting light VPN cleanup"

# 1. Kill only stale openvpn processes (not the VPN client app)
if pgrep -f openvpn >/dev/null 2>&1; then
  pkill -9 -f openvpn 2>/dev/null
  log "Killed stale openvpn process"
  sleep 1
fi

# 2. Destroy stale utun interfaces
for iface in $(ifconfig -l | tr ' ' '\n' | grep utun); do
  # Skip utun0-3 which are system interfaces (iCloud Private Relay, etc.)
  case "$iface" in utun[0-3]) continue ;; esac
  ifconfig "$iface" destroy 2>/dev/null && log "Destroyed $iface"
done

# 3. Flush DNS cache
dscacheutil -flushcache 2>/dev/null
killall -HUP mDNSResponder 2>/dev/null
log "Flushed DNS"

# 4. Clean up stale scutil entries
echo "remove State:/Network/OpenVPN" | scutil 2>/dev/null
echo "remove State:/Network/OpenVPN/DNS" | scutil 2>/dev/null
log "Cleared stale scutil entries"

# 5. Restart the helper daemon
launchctl kickstart -k system/com.amazonaws.acvc.helper 2>/dev/null
log "Restarted helper daemon — cleanup complete"
