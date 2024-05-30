#!/bin/bash

R="\e[31m" # wherver we use this it implements the red color 
# 01.Server Uptime

# Display the server uptime
uptime=$(uptime)
echo "Server Uptime: $uptime"

# 02.Last Server Reboot Timestamp

# Get the last server reboot timestamp
last_reboot=$(who -b | awk '{print $3, $4}')

# Display the last server reboot timestamp
echo "Last Server Reboot Timestamp: $last_reboot"


# 03.Server Local Time Zone [Expected IST, Highlight to NON-IST ]

# Get the server's local time zone
server_timezone=$(timedatectl | grep "Time zone" | awk '{print $3}')

# Check if the server's local time zone is not IST
if [ "$server_timezone" != "IST" ]; then
    echo "Server Local Time Zone: $R $server_timezone (NON-IST)"
else
    echo "Server Local Time Zone: $server_timezone"
fi

# 04. Last 10 installed packges with dates

# Store the output of the command in a variable
last_installed_packages=$(rpm -qa --last | head -10)

# Display the last 10 installed packages with dates
echo "$last_installed_packages"


# 05. OS version [Expected RHEL family, Highlight for different os]

# Get OS version
os_version=$(cat /etc/redhat-release)

# Check if it contains "Red Hat Enterprise Linux"
if [[ $os_version == *"Red Hat Enterprise Linux"* ]]; then
    echo -e "Red Hat Enterprise Linux: $os_version\e[0m"
# If it's not from RHEL family
else
    echo "$R $os_version"
fi

# 06. Kernel version

# Store the kernel version in a variable
kernel_version=$(uname -r)

# Print the kernel version
echo "Kernel version: $kernel_version"


# 07. CPU - Virtual cores

# Store the number of virtual CPU cores in a variable
virtual_cores=$(lscpu | grep -E '^CPU\(s\):' | awk '{print $2}')

# Print the number of virtual CPU cores
echo "Number of virtual CPU cores: $virtual_cores"

# 08. CPU - Clock speed

# Store the CPU clock speed in a variable
cpu_speed=$(lscpu | grep "CPU MHz" | awk '{print $3}')

# Print the CPU clock speed
echo "CPU clock speed: $cpu_speed MHz"

# 09.CPU - Architecture [Expected x86-64 , Highlight for other than x86-64]

# Get CPU architecture
cpu_arch=$(uname -m)

# Check if CPU architecture is x86-64
if [ "$cpu_arch" == "x86_64" ]; then
    echo "CPU Architecture: x86-64"
else
    echo "CPU Architecture: $R $cpu_arch "
fi

# 10. Disk - Mounted/Unmounted volumes, type, storage

# Function to check disk information
check_disk_info() {
    echo "Mounted volumes:"
    df -h | awk '{print "Filesystem:", $1, "Type:", $2, "Size:", $3, "Used:", $4, "Available:", $5, "Mounted on:", $6}'
    
    echo "Unmounted volumes:"
    lsblk -o NAME,FSTYPE,SIZE | grep -v "loop" | grep -v "/"
}

# Execute the function to check disk information
check_disk_info

# 11. Private and Public IP

# Get all IP addresses assigned to the server
ip_addresses=$(hostname -I)

# Split the list of IP addresses into an array
IFS=' ' read -r -a ip_array <<< "$ip_addresses"

# Iterate over each IP address and check if it's private or public
for ip in "${ip_array[@]}"; do
    # Check if IP address is private
    if [[ $ip =~ ^192\.168\. || $ip =~ ^10\. || $ip =~ ^172\.(1[6-9]|2[0-9]|3[0-1])\. || $ip =~ ^169\.254\. ]]; then
        echo "Private IP: $ip"
    else
        echo "Public IP: $ip"
    fi
done

# 12. Private and Public DNS or Hostname

# Get all IP addresses assigned to the server
ip_addresses=$(hostname -I)

# Initialize variables to store private and public hostnames
private_hostnames=""
public_hostnames=""

# Function to resolve hostname from IP
get_hostname() {
    local ip=$1
    local hostname=$(host "$ip" | awk '{print $5}')
    echo "$hostname"
}

# Split the list of IP addresses into an array
IFS=' ' read -r -a ip_array <<< "$ip_addresses"

# Iterate over each IP address and check if it's private or public
for ip in "${ip_array[@]}"; do
    # Resolve hostname from IP
    hostname=$(get_hostname "$ip")

    # Check if IP address is private
    if [[ $ip =~ ^192\.168\. || $ip =~ ^10\. || $ip =~ ^172\.(1[6-9]|2[0-9]|3[0-1])\. || $ip =~ ^169\.254\. ]]; then
        # Append private hostname to the list
        private_hostnames+="$hostname "
    else
        # Append public hostname to the list
        public_hostnames+="$hostname "
    fi
done

# Print private and public hostnames
echo "Private Hostnames:"
echo "$private_hostnames"

echo "Public Hostnames:"
echo "$public_hostnames"

# 13. Networking - Bandwidth

# Run iftop and store the output in a variable
bandwidth_usage=$(sudo iftop)

# Print the output
echo "$bandwidth_usage"


# 14. Networking - OS Firewall (Allowed Ports & Protocols)

# Run firewall-cmd to get allowed ports and protocols and store the output in a variable
firewall_info=$(sudo firewall-cmd --list-all)

# Print the output
echo "$firewall_info"

# 15. Networking - Network Firewall (Allowed Ports & Protocols)

# Run iptables to get allowed ports and protocols and store the output in a variable
firewall_info=$(sudo iptables -L)

# Print the output
echo "$firewall_info"

# 16. CPU - Utilization [Expected Less than 60 %, Highlight CPU consumption]

# Get CPU utilization using top command and extract the CPU line
cpu_line=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}')

# Check if CPU utilization is greater than 60%
if (( $(echo "$cpu_line > 60" | bc -l) )); then
    echo "$R CPU Utilization is high: $cpu_line%"
else
    echo "CPU Utilization is within expected range: $cpu_line%"
fi 

# 17. RAM - Utilization [Expected Less than 60 %,Highlight RAM consumption]

# Get total memory and used memory using free command
total_memory=$(free -m | awk '/^Mem:/ {print $2}')
used_memory=$(free -m | awk '/^Mem:/ {print $3}')

# Calculate RAM utilization percentage
ram_utilization=$(awk "BEGIN {print ($used_memory/$total_memory)*100}")

# Check if RAM utilization is greater than 60%
if (( $(echo "$ram_utilization > 60" | bc -l) )); then
    echo " $R RAM Utilization is high: $ram_utilization%"
else
    echo "RAM Utilization is within expected range: $ram_utilization%"
fi

# 18. Storage [Expected Less than 60 %, other wise Highlight Storage consumption]

# Get storage usage information
disk_usage=$(df -h / | awk 'NR==2 {print $5}' | sed 's/%//')

# Check if storage utilization is greater than 60%
if [ $disk_usage -gt 60 ]; then
    echo "$R Storage Utilization is high: ${disk_usage}%"
else
    echo "Storage Utilization is within expected range: ${disk_usage}%"
fi

# 19. Highlight when current User Password Exipring

# Get the password expiration details for the current user
password_info=$(chage -l $(whoami))

# Extract the password expiration date
expiration_date=$(echo "$password_info" | grep "Password expires" | awk '{print $4}')

# Convert the expiration date to seconds since epoch
expiration_seconds=$(date -d "$expiration_date" +%s)

# Get the current date in seconds since epoch
current_seconds=$(date +%s)

# Calculate the number of seconds until password expiration
seconds_until_expiration=$((expiration_seconds - current_seconds))

# Convert seconds until expiration to days
days_until_expiration=$((seconds_until_expiration / 86400))

# Check if the password expires within the next 14 days (or any other threshold you choose)
if [ "$days_until_expiration" -lt 14 ]; then
    echo " $R Your password is expiring in $days_until_expiration days. Please consider changing it."
fi