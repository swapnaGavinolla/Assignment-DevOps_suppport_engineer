I have Written a bash script to audit the following hardware spec in RHEL. The script should print out following specifications and also audit report should highlight specifications if they are not matching expected specifications

01. Server Uptime

    Here I have used uptime `command` and stored the output in variable "uptime"
    and written echo statement to display the server uptime


2. Last Server Reboot Timestamp
 
   Here I have used uptime `who` and `awk` commands and  stored the output in variable  "last_reboot"
   and written echo statement to display the Last Server Reboot Timestamp

3. Server Local Time Zone [Expected IST, Highlight to NON-IST ]

    Here I have used timedatectl, awk & grep commands and  stored the output in variable "server_timezone"
    and wrote a condition to Check if the server's local time zone is not IST.
    
4. Last 10 installed packges with dates

    Here I have used rpm and head command and Stored the output of the command in a variable "last_installed_packages"

    and wrote echo statement to display the last 10 installed packages with dates


5. OS version [Expected RHEL family, Highlight for different os]

    1st got the OS version next wrote a condition to check if the OS version is from RHEL family or not highlight if it's different OS

6. Kernel version


    used uname command to get the kernel version Stored the kernel version in a variable "kernel_version" and
    wrote echo staement to Print the kernel version
   

7. CPU - Virtual cores

    used `lscpu` command to get information about the CPU architecture, including the number of virtual cores.
    Stored the number of virtual CPU cores in a variable "virtual_cores" and
    wrote echo staement to Print the number of virtual CPU cores
     

8. CPU - Clock speed

    using (lscpu, grep, CPU MHz )  Stored the CPU clock speed in a variable cpu_speed Print the CPU clock speed.
    This command displays the CPU clock speed in megahertz (MHz) as reported by the kernel.

9. CPU - Architecture [Expected x86-64 , Highlight for other than x86-64]

   using uname command got CPU architecture and using condition Checked if CPU architecture is x86-64 or not.
   echo statement will dispaly the output in highlighted state if CPU architecture is not x86-64.

10. Disk - Mounted/Unmounted volumes, type, storage
    wrote a Function to check disk information
    used  `df -h` command displayed information about disk space usage, including mounted volumes, their types, and storage capacity.

11. Private and Public IP

    Got all IP addresses assigned to the server and Splitted the list of IP addresses into an array.
    Iterated over each IP address and checked if it's private or public


12. Private and Public DNS or Hostname

    Got all IP addresses assigned to the server and Splitted the list of IP addresses into an array.
    Iterated over each IP address and checked if it's Private Hostname or Public Hostname

13. Networking - Bandwidth

    using `iftop` stored the output in a variable "bandwidth_usage"
    and Printed the output 


14. Networking - OS Firewall (Allowed Ports & Protocols)

    used `firewall-cmd` to get allowed ports and protocols and stored the output in a variable firewall_info
    and Printed the output.
 

15. Networking - Network Firewall (Allowed Ports & Protocols)
    used `iptables` to get allowed ports and protocols and stored the output in a variable firewall_info
    and Printed the output.

16. CPU - Utilization [Expected Less than 60 %, Highlight CPU consumption]

    Get CPU utilization using top command and extract the CPU line.
     if it's higher than 60% will Highlight the CPU consumption.

17. RAM - Utilization [Expected Less than 60 %,Highlight RAM consumption]

     If the RAM utilization is greater than 60%, it will highlight that the RAM utilization is high; otherwise, it will indicate that the RAM utilization is within the expected range.


18. Storage [Expected Less than 60 %, other wise Highlight Storage consumption]

    the condition will check the storage utilization of the root filesystem (/). If the storage utilization is greater than 60%, it will highlight that the storage utilization is high; otherwise, it will indicate that the storage utilization is within the expected range


19. Highlight when current User Password Exipring

 it will check if the current user's password is expiring within the next 14 days (I assumed 14 days). If the password is expiring soon, it will print a message highlighting the expiration.