#!/usr/bin/env bash
set -euo pipefail

# add "PROGRAM /usr/local/sbin/mdadm-log" to `/etc/mdadm.conf` to enable it
EVENT="${1:-UNKNOWN}"
ARRAY="${2:-UNKNOWN}"
DEVICE="${3:-}"

FILE="/var/log/mdadm.log"
LOCK="/run/lock/mdadm.lock"

# ensure lock dir exists (on Arch /run is tmpfs, recreated on boot)
install -d -m 0755 "$(dirname "$LOCK")"

stamp="$(date --iso-8601=seconds)"
host="$(< /etc/hostname)"

# if a component device is provided, include it
if [[ -n "$DEVICE" ]]; then
  line="$stamp host=$host event=$EVENT array=$ARRAY device=$DEVICE"
else
  line="$stamp host=$host event=$EVENT array=$ARRAY"
fi

# serialize appends (mdadm could this script concurrently)
{
  flock -x 200
  echo "$line" >> "$FILE"
} 200>"$LOCK"

# also send to journald/syslog
logger -t mdadm-monitor -- "$line"

exit 0
