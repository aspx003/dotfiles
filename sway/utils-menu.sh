#!/bin/sh
SHOTS="$HOME/Pictures/Screenshots"
mkdir -p "$SHOTS"
FILE="$SHOTS/$(date +%Y-%m-%d_%H-%M-%S).png"

menu() {
  wofi --dmenu --prompt "$1" --width "${2:-320}" --height "${3:-320}" --cache-file /dev/null
}

notify() {
  command -v notify-send >/dev/null && notify-send "$1" "$2"
}

choice=$(printf 'Clipboard history\nScreenshot: full\nScreenshot: area\nScreenshot: window\nScreenshot: area to clipboard\nClear clipboard history\n' | menu "Utilities")

case "$choice" in
"Clipboard history")
  cliphist list | menu "Clipboard" 600 420 | cliphist decode | wl-copy
  ;;
"Screenshot: full")
  sleep 0.4
  grim "$FILE" && notify "Screenshot saved" "$FILE"
  ;;
"Screenshot: area")
  area=$(slurp) || exit 0
  grim -g "$area" "$FILE" && notify "Screenshot saved" "$FILE"
  ;;
"Screenshot: window")
  area=$(swaymsg -t get_tree | jq -r '.. | select(.pid? and .visible?) | .rect | "\(.x),\(.y) \(.width)x\(.height)"' | slurp -r) || exit 0
  grim -g "$area" "$FILE" && notify "Screenshot saved" "$FILE"
  ;;
"Screenshot: area to clipboard")
  area=$(slurp) || exit 0
  grim -g "$area" - | wl-copy && notify "Screenshot copied" "Paste it anywhere"
  ;;
"Clear clipboard history")
  cliphist wipe && notify "Clipboard" "History cleared"
  ;;
esac
