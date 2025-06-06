awk '/MemTotal/ {total=$2} /MemAvailable/ {available=$2} END {printf " %d%%\n", (total-available)*100/total}' /proc/meminfo
