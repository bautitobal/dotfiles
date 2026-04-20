#!/bin/bash

if wpctl get-volume @DEFAULT_AUDIO_SOURCE@ | grep -q MUTED; then
    echo "󰍭 muted"
else
    echo "󰍬 on"
fi
