#!/bin/bash

# Default time threshold in hours
DEFAULT_THRESHOLD=40

# Function to print usage instructions
usage() {
    echo "Usage: $0 [time_threshold]"
    echo "Example: $0 10hrs"
    exit 1
}

# Function to clean audio files and generate log
clean_audio() {
    local threshold="$1"
    local log_file="deleted-files-$(date +'%d-%m-%Y').log"

    # Clean audio files older than the threshold
    find /data/audios/folder -name "*.wav" -type f -mmin +$((threshold * 60)) -print0 |
    while IFS= read -r -d '' file; do
        # Log file deletion
        echo "$(basename "$file") $(date -r "$file" --iso-8601=seconds) $(date --iso-8601=seconds)" >> "$log_file"
        # Remove file
        rm -f "$file"
    done
}

# Check if at least one argument is provided
if [ $# -eq 0 ]; then
    # No argument provided, use default threshold
    clean_audio "$DEFAULT_THRESHOLD"
elif [ $# -eq 1 ]; then
    # One argument provided, check if it's in the correct format
    if [[ "$1" =~ ^[0-9]+hrs$ ]]; then
        # Argument is in correct format, extract the time part and clean audio files
        time="${1%hrs}"
        clean_audio "$time"
    else
        # Argument is not in correct format, print usage instructions
        usage
    fi
else
    # More than one argument provided, print usage instructions
    usage
fi
