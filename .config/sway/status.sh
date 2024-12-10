#!/bin/bash
while true; do
  bat=$(cat /sys/class/power_supply/BAT0/capacity)
  status=$(cat /sys/class/power_supply/BAT0/status)
  if [ "$status" = "Charging" ]; then
    echo "⚡ $bat% | $(date +'%Y-%m-%d %X')"
  else
    echo "🔋 $bat% | $(date +'%Y-%m-%d %X')"
  fi
  sleep 1
done
