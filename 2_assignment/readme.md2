# Hardware Audit Script for RHEL

This Bash script is designed to audit various hardware specifications on a Red Hat Enterprise Linux (RHEL) server and highlight any deviations from the expected specifications.

## Specifications Audited

- Server Uptime
- Last Server Reboot Timestamp
- Server Local Time Zone (Expected IST, Highlight to NON-IST)
- Last 10 Installed Packages with Dates
- OS Version (Expected RHEL Family, Highlight for different OS)
- Kernel Version
- CPU Specifications (Virtual cores, Clock speed, Architecture)
- Disk Specifications (Mounted/Unmounted volumes, type, storage)
- Private and Public IP
- Private and Public DNS or Hostname
- Networking Specifications (Bandwidth, OS Firewall, Network Firewall)
- CPU Utilization (Expected Less than 60%, Highlight CPU consumption)
- RAM Utilization (Expected Less than 60%, Highlight RAM consumption)
- Storage Utilization (Expected Less than 60%, Highlight Storage consumption)
- Highlight when current User Password Expiring

## Usage

1. Ensure the script `hardware_audit.sh` has executable permissions:
    ```bash
    chmod +x hardware_audit.sh
    ```

2. Run the script:
    ```bash
    ./hardware_audit.sh
    ```

3. Review the output to identify any deviations from expected specifications.

## Notes

- If any specifications do not meet the expected criteria, they will be highlighted in red.
- Make sure to run the script with appropriate permissions.
- This script is specifically designed for RHEL systems and may not work as expected on other distributions.
