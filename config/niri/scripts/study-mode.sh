#!/usr/bin/env bash
pkill steam 2>/dev/null
pkill vesktop 2>/dev/null
pkill discord 2>/dev/null
pkill spotify 2>/dev/null

brave \
  "https://miel.unlam.edu.ar" \
  "https://drive.google.com/drive/u/0/folders/1Du25znz9DURkQG82mZ5AJdRVT3c5LfR7" \
  >/dev/null 2>&1 &

obsidian >/dev/null 2>&1 &
kitty -e nvim >/dev/null 2>&1 &
spotify >/dev/null 2>&1 &
