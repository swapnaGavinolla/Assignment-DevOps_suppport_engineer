# Audio Data Cleanup Script

This Bash script is designed to clean out .wav audio data files in a specified directory that are older than a certain threshold, with the option to specify the threshold duration.

## Usage

To use the script, follow these steps:

1. Ensure the script `clean_audio_data.sh` has executable permissions:
    ```bash
    chmod +x clean_audio_data.sh
    ```

2. Run the script:
    ```bash
    ./clean_audio_data.sh [time_threshold]
    ```

    - If no argument is provided, the script will clean out audio files older than 40 hours by default.
    - If an argument is provided in the format of Xhrs (e.g., 10hrs), the script will clean out audio files older than X hours.

3. Review the output to ensure audio files are cleaned out as expected.
