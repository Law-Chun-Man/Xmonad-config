#!/bin/bash

CURRENT_GOVERNOR=$(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor)

if [ "$CURRENT_GOVERNOR" = "schedutil" ]; then
    echo 
else
    echo 
fi

