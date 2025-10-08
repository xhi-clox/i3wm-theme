#!/bin/bash

# Color variables - CHANGE THESE TO WHATEVER YOU LIKE!
CPU_COLOR="#00eeff"      # Cyan
MEM_COLOR="#00eeff"      # Cyan  
VOL_COLOR="#00eeff"      # Cyan
TIME_COLOR="#00eeff"     # Pink
SEP_COLOR="#00eeff"      # Cyan for separators

# Simple working status script
echo '{"version":1}'
echo '['
echo '[]'

while true; do
    # CPU usage
    cpu=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{printf "%d", 100 - $1}')

    # Memory usage
    mem=$(free -m | awk 'NR==2{printf "%.1fG", $3/1024}')

    # Volume
    volume=$(pamixer --get-volume 2>/dev/null || echo "0")
    mute=$(pamixer --get-mute 2>/dev/null || echo "false")
    if [ "$mute" = "true" ]; then
        vol_display="<span foreground='$VOL_COLOR'> Muted</span>"
    else
        vol_display="<span foreground='$VOL_COLOR'> $volume%</span>"
    fi

    # Time
    time=$(date "+%H:%M %p")

    # Build status line with color variables
    separator="<span foreground='$SEP_COLOR'> | </span>"
    status="<span foreground='$CPU_COLOR'> $cpu%</span>$separator<span foreground='$MEM_COLOR'> $mem</span>$separator$vol_display$separator<span foreground='$TIME_COLOR'>$time</span>"

    echo ",[{\"full_text\": \"$status\", \"markup\": \"pango\"}]"

    sleep 2
done
