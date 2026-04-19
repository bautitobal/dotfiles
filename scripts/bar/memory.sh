#!/usr/bin/env sh

awk '
/MemTotal:/ {total=$2}
/MemAvailable:/ {avail=$2}
END {
    used=(total-avail)/1024/1024
    printf "󰍛 %.1f Gi", used
}' /proc/meminfo
