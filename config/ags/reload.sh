#!/bin/bash

ags quit &>/dev/null
sleep 0.3

ags run ~/.config/ags/app.ts &
disown