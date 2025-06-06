echo  $(cat /sys/class/thermal/thermal_zone0/temp | cut -c 1,2)°C
