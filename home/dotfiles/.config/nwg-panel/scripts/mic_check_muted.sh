# Get the volume information
volume_info=$(wpctl get-volume @DEFAULT_AUDIO_SOURCE@)

# Check if the word "MUTED" is present in the output
if echo "$volume_info" | grep -q "MUTED"; then
    echo 
else
    echo 
fi
