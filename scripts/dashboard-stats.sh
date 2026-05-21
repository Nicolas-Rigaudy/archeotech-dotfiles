#!/usr/bin/env bash
# Outputs one line per stat: cpu:N  ram:N  disk:N  bat:N:Status

# CPU — two /proc/stat snapshots 300ms apart to compute delta
c1=$(awk '/^cpu /{t=$2+$3+$4+$5+$6+$7+$8; i=$5; print t, i; exit}' /proc/stat)
sleep 0.3
c2=$(awk '/^cpu /{t=$2+$3+$4+$5+$6+$7+$8; i=$5; print t, i; exit}' /proc/stat)
t1=${c1% *}; i1=${c1#* }
t2=${c2% *}; i2=${c2#* }
dt=$((t2 - t1)); di=$((i2 - i1))
cpu=0
[ "$dt" -gt 0 ] && cpu=$((100 * (dt - di) / dt))
echo "cpu:$cpu"

# RAM
awk '/MemTotal/{t=$2} /MemAvailable/{a=$2} END{print "ram:" int((t-a)*100/t)}' /proc/meminfo

# Disk (root filesystem usage %)
pct=$(df --output=pcent / 2>/dev/null | tail -1 | tr -d ' %')
echo "disk:${pct:-0}"

# Battery (try BAT0 then BAT1)
cap=$(cat /sys/class/power_supply/BAT0/capacity 2>/dev/null \
   || cat /sys/class/power_supply/BAT1/capacity 2>/dev/null \
   || echo 0)
st=$(cat /sys/class/power_supply/BAT0/status 2>/dev/null \
  || cat /sys/class/power_supply/BAT1/status 2>/dev/null \
  || echo Unknown)
echo "bat:$cap:$st"
