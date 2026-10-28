#!/bin/sh
choice=$(printf 'Lock\nLogout\nSuspend\nReboot\nShutdown\n' | wofi --dmenu --prompt "Power" --width 300 --height 280 --cache-file /dev/null)

case "$choice" in
  Lock)     swaylock ;;
  Logout)   swaymsg exit ;;
  Suspend)  systemctl suspend ;;
  Reboot)   systemctl reboot ;;
  Shutdown) systemctl poweroff ;;
esac
