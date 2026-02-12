#!/bin/bash


CONFIG="/etc/avilability_hosts/hosts.conf"

LOG="/var/log/pinger.log"


while true; do
    
    while IFS= read -r host; do
        
        [[ -z "$host" || "$host" =~ ^# ]] && continue

        
        if output=$(ping -c 1 -W 1 "$host" 2>&1); then
            
            latency=$(echo "$output" | grep -o 'time=.*ms' | head -1 | cut -d= -f2)
            echo "$(date '+%Y-%m-%d %H:%M:%S') $host: status=UP, latency=$latency" >> "$LOG"
        else
            # Недоступен
            echo "$(date '+%Y-%m-%d %H:%M:%S') $host: status=DOWN" >> "$LOG"
        fi
    done < "$CONFIG"

    sleep 60
done
