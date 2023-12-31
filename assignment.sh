#!/bin/bash


# Assignment 2
# Linux Scripting
# COMP2137
# Made by Lobarev Vadim 200530998
# 2023-10-06


# Defining variables to store system information
HOSTNAME=$(hostname)
OS=$(source /etc/os-release && echo $PRETTY_NAME)
UPTIME=$(uptime -p)

# Hardware information
# exit statement ensures only the first CPU entry is captured.
CPU=$(lshw -c processor | awk -F ': ' '/product/ {print $2; exit}')

CPU_SPEED=$(lshw -c processor | awk -F ': ' '/capacity/ {print $2; exit}')

RAM=$(free -h | awk '/Mem:/ {print $2}')
# tail -n +2 command is used to skip the header line
DISKS=$(lsblk -o NAME,MODEL,SIZE | tail -n +2)
VIDEO_CARD=$(lspci | grep VGA | awk -F ': ' '{print $3}')

# Network information
FQDN=$(hostname -f)
# ip -o -4 addr show scope global retrieves information about network
IP_ADDRESS=$(ip -o -4 addr show scope global | awk '{print $4}')
GATEWAY=$(ip route | awk '/default/ {print $3}')
DNS_SERVER=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2}')

# Interface information
# ip -o -4 addr show is used to display information about network
INTERFACE_NAME=$(ip -o -4 addr show | awk '{print $2}' | head -n 1)
IP_CIDR=$(ip -o -4 addr show | awk '/scope global/ {print $2}')

# System status
USERS=$(who | awk '{print $1}' | sort | uniq | tr '\n' ', ')
DISK_SPACE=$(df -h | awk '{if(NR>1) print $6, $4}')
PROCESS_COUNT=$(ps aux | wc -l)
LOAD_AVERAGES=$(cat /proc/loadavg | awk '{print $1, $2, $3}')
MEMORY_ALLOCATION=$(free -h | awk '/Mem:/ {print $3}')
# cut -d':' -f2 is used to extract the port number from the address and port
# tr '\n' ',' | sed 's/,$//' is used to replace newline characters with commas and remove the trailing comma using 'sed'
LISTENING_PORTS=$(ss -tuln | awk 'NR > 1 {print $5}' | cut -d':' -f2 | sort -n | uniq | tr '\n' ',' | sed 's/,$//')
UFW_RULES=$(sudo ufw status numbered)

# Output the system report
cat << EOF

System Report generated by $(whoami), $(date +"%Y-%m-%d %H:%M:%S")

System Information
------------------
Hostname: $HOSTNAME
OS: $OS
Uptime: $UPTIME

Hardware Information
--------------------
CPU: $CPU
Speed: $CPU_SPEED
RAM: $RAM
Disks:
$DISKS
Video: $VIDEO_CARD

Network Information
-------------------
FQDN: $FQDN
Host Address: $IP_ADDRESS
Gateway IP: $GATEWAY
DNS Server: $DNS_SERVER

Interface Name: $INTERFACE_NAME
IP Address: $IP_CIDR

System Status
-------------
Users Logged In: $USERS
Disk Space:
$DISK_SPACE
Process Count: $PROCESS_COUNT
Load Averages: $LOAD_AVERAGES
Memory Allocation: $MEMORY_ALLOCATION
Listening Network Ports: $LISTENING_PORTS
UFW Rules:
$UFW_RULES

EOF
