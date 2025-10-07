#!/usr/bin/env bash
# 💾 Memory usage

used=$(free -h | awk '/Mem:/ {print $3}')
total=$(free -h | awk '/Mem:/ {print $2}')
echo "$used / $total"
