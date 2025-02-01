#!/bin/bash

# Your existing VPN connection command
VPN_CMD="sudo openconnect as13.v-ok.net"

# Path to your existing script
EXISTING_SCRIPT="/home/masayoshi/network/japanip.sh"

# Function to check internet connectivity
check_internet() {
    ping -c 1 google.com > /dev/null 2>&1
    return $?
}

# Function to check if the VPN is running
check_vpn() {
    pgrep openconnect > /dev/null 2>&1
    return $?
}

# Function to check if your existing script is running
check_existing_script() {
    pgrep -f "$EXISTING_SCRIPT" > /dev/null 2>&1
    return $?
}

# Function to restart the VPN
restart_vpn() {
    echo "$(date): Internet disconnected or VPN interrupted. Restarting VPN..."
    pkill openconnect  # Kill existing OpenConnect process
    eval $VPN_CMD &    # Restart VPN in the background
}

# Function to restart your existing script
restart_existing_script() {
    echo "$(date): Existing script interrupted. Restarting..."
    pkill -f "$EXISTING_SCRIPT"  # Kill existing instances of the script
    bash "$EXISTING_SCRIPT" &    # Restart the script in the background
}

# Main loop
while true; do
    if ! check_internet || ! check_vpn; then
        restart_vpn
    fi

    if ! check_existing_script; then
        restart_existing_script
    fi

    sleep 6  # Check every 60 seconds
done
