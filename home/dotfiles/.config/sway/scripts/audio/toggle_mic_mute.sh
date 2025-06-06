#!/bin/bash
# toggle microphone mute
wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle

# get volume. Result string is
# Volume: x.xx [MUTED] or Volume: x.xx
mic_state=$(wpctl get-volume @DEFAULT_AUDIO_SOURCE@)

# substring of Volume string
# 1. split at : and continue with second split string
# 2. split at [ and continue with second split string
# 3. split at ] and continue with first split string
# Result is either the volume x.xx or MUTED
mic_state_sub=$(echo $mic_state | cut -d':' -f 2 | cut -d'[' -f 2 | cut -d']' -f 1)

# if substring is 'MUTED', send status to dunst
if  [ $mic_state_sub = 'MUTED' ]
then
    # clear all old dunst messages
    dunstctl close-all
    # send string to dunst
    dunstify 'Mic muted'
else
    dunstctl close-all
    dunstify 'Mic unmuted'
fi
