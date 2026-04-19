#!/usr/bin/env sh

read -r cpu user nice system idle iowait irq softirq steal guest guest_nice </proc/stat

total1=$((user + nice + system + idle + iowait + irq + softirq + steal))
idle1=$((idle + iowait))

sleep 0.5

read -r cpu user nice system idle iowait irq softirq steal guest guest_nice </proc/stat

total2=$((user + nice + system + idle + iowait + irq + softirq + steal))
idle2=$((idle + iowait))

total=$((total2 - total1))
idle=$((idle2 - idle1))

if [ "$total" -eq 0 ]; then
    printf " 0%%"
    exit 0
fi

usage=$((100 * (total - idle) / total))
printf " %s%%" "$usage"
