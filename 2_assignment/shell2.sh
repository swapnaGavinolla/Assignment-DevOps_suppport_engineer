#!/bin/bash

# Function to highlight differences
highlight() {
    echo -e "\e[31m$1\e[0m"
}

# Function to check and print uptime
check_uptime() {
    uptime -p
}

# Function to check and print last reboot timestamp
check_last_reboot() {
    who -b
}

# Function to check and print server local time zone
check_timezone() {
    timezone=$(date +%Z)
    if [ "$timezone" != "IST" ]; then
        highlight "Server Local Time Zone is $timezone (Expected IST)"
    else
        echo "Server Local Time Zone is $timezone"
    fi
}

# Function to check and print last 10 installed packages with dates
check_installed_packages() {
    echo "Last 10 Installed Packages with Dates:"
    tail -n 10 /var/log/yum.log | grep 'Installed' | awk '{print $1, $2, $3}'
}

# Function to check and print OS version
check_os_version() {
    os_version=$(cat /etc/redhat-release)
    if [[ "$os_version" != *"Red Hat"* ]]; then
        highlight "OS Version: $os_version (Expected RHEL Family)"
    else
        echo "OS Version: $os_version"
    fi
}

# Function to check and print kernel version
check_kernel_version() {
    uname -r
}

# Function to check CPU specifications
check_cpu() {
    echo "CPU Specifications:"
    lscpu | grep -E "Model name|Architecture"
}

# Function to check disk specifications
check_disk() {
    echo "Disk Specifications:"
    df -h
}

# Function to check networking specifications
check_networking() {
    echo "Networking Specifications:"
    echo "Private IP: $(hostname -I)"
    echo "Public IP: $(curl -s ifconfig.me)"
    echo "Private DNS/Hostname: $(hostname)"
    echo "Public DNS/Hostname: $(dig +short myip.opendns.com @resolver1.opendns.com)"
    echo "Bandwidth: $(cat /proc/net/dev | grep 'eth0' | awk '{print $2,$10}')"
    echo "OS Firewall (Allowed Ports & Protocols): $(iptables -L)"
    echo "Network Firewall (Allowed Ports & Protocols): $(firewall-cmd --list-all)"
}

# Function to check CPU and RAM utilization
check_utilization() {
    echo "Utilization:"
    echo "CPU: $(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}')%"
    echo "RAM: $(free | grep Mem | awk '{print $3/$2 * 100.0}')%"
}

# Function to check storage utilization
check_storage_utilization() {
    echo "Storage Utilization:"
    df -h | grep -vE '^Filesystem|tmpfs|cdrom' | awk '{print $5 " " $6}' | while read output;
    do
        usep=$(echo $output | awk '{print $1}' | cut -d'%' -f1)
        partition=$(echo $output | awk '{print $2}')
        if [ $usep -gt 60 ]; then
            highlight "Partition $partition is $usep% full"
        else
            echo "Partition $partition is $usep% full"
        fi
    done
}

# Function to check password expiration
check_password_expiry() {
    echo "Password Expiration:"
    passwd -S $USER | awk '{print $3}'
}

# Main function to call all check functions
main() {
    echo "Auditing Hardware Specifications:"
    check_uptime
    check_last_reboot
    check_timezone
    check_installed_packages
    check_os_version
    check_kernel_version
    check_cpu
    check_disk
    check_networking
    check_utilization
    check_storage_utilization
    check_password_expiry
}

# Call the main function
main
