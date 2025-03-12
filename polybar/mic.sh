#!/bin/bash

MUTED=$(pactl get-source-mute @DEFAULT_SOURCE@ | grep -oP 'yes|no')

if [ "$MUTED" = "yes" ]; then
    echo 
else
    pactl set-source-mute @DEFAULT_SOURCE@ toggle
    echo 
fi

