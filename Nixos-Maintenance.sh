# When sometimes you just want to clean up your NixOS system without going through the hassle of running multiple commands, this script can help you out.
# It provides a simple menu to show disk usage, perform basic cleaning, aggressive cleaning, nuclear cleaning, and update NixOS.
# You can run this script as a regular user, and it will prompt you for sudo access when required.
#
# It's Alpha but it works and hasn't caused any issues "yet!" Use at your own risk. :-)
# 
# Usage: chmod +x Nixos-Maintenance.sh
#        ./Nixos-Maintenance.sh
#



#!/usr/bin/env bash

# Set colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored text
print_color() {
    local color=$1
    local text=$2
    echo -e "${color}${text}${NC}"
}

# Function to confirm action
confirm_action() {
    local prompt=$1
    read -p "${prompt} (y/n): " -n 1 -r
    echo
    [[ $REPLY =~ ^[Yy]$ ]]
}

# Function to show disk usage
show_disk_usage() {
    print_color $BLUE "\nCurrent Disk Usage:"
    df -h /
    echo -e "\nLargest paths in Nix store:"
    nix path-info -Sh /run/current-system | sort -hr | head -n 10
    echo
}

# Function to perform basic cleaning
basic_cleaning() {
    if confirm_action "Perform basic cleaning?"; then
        print_color $BLUE "Performing basic cleaning..."
        print_color $YELLOW "Removing old home-manager generations..."
        home-manager expire-generations "-30 days"
        
        print_color $YELLOW "Removing old system generations..."
        sudo nix-collect-garbage --delete-old
        
        print_color $YELLOW "Removing old boot entries..."
        sudo /run/current-system/bin/switch-to-configuration boot
        
        print_color $GREEN "Basic cleaning completed!"
    fi
}

# Function to perform aggressive cleaning
aggressive_cleaning() {
    if confirm_action "WARNING: This will perform aggressive cleaning. Continue?"; then
        print_color $BLUE "Performing aggressive cleaning..."
        print_color $YELLOW "Removing unused packages..."
        sudo nix-store --gc
        
        print_color $YELLOW "Cleaning up old profiles..."
        sudo nix-collect-garbage -d
        
        print_color $YELLOW "Cleaning flake cache..."
        rm -rf ~/.cache/nix/flake-registry.json
        rm -rf /nix/var/nix/gcroots/auto/*
        
        print_color $GREEN "Aggressive cleaning completed!"
    fi
}

# Function to perform nuclear cleaning
nuclear_cleaning() {
    if confirm_action "WARNING: This will delete all old generations. Are you absolutely sure?"; then
        print_color $RED "Performing nuclear cleaning..."
        print_color $YELLOW "Deleting all old generations..."
        sudo nix-collect-garbage --delete-old
        sudo nixos-rebuild boot
        
        print_color $YELLOW "Removing all generations except current..."
        nix profile wipe-history --profile /nix/var/nix/profiles/system --older-than 0d
        
        print_color $YELLOW "Cleaning home-manager generations..."
        home-manager generations | awk '/[0-9]/ {print $5}' | xargs -I{} home-manager remove-generations {}
        
        print_color $GREEN "Nuclear cleaning completed!"
    fi
}

# Function to update NixOS
update_nixos() {
    if confirm_action "Would you like to create a test build before updating?"; then
        print_color $BLUE "Creating test build..."
        sudo nixos-rebuild test
        
        if confirm_action "Test build completed. Would you like to proceed with the update?"; then
            print_color $BLUE "Updating NixOS..."
            sudo nixos-rebuild switch
            print_color $GREEN "Update completed!"
        else
            print_color $YELLOW "Rolling back to previous configuration..."
            sudo nixos-rebuild switch --rollback
            print_color $GREEN "Rollback completed!"
        fi
    else
        if confirm_action "Proceed with direct update?"; then
            print_color $BLUE "Updating NixOS..."
            sudo nixos-rebuild switch
            print_color $GREEN "Update completed!"
        fi
    fi
}

# Main menu
while true; do
    clear
    print_color $BLUE "NixOS Maintenance Script"
    echo "------------------------"
    echo "1. Show disk usage"
    echo "2. Basic cleaning (30-day-old generations)"
    echo "3. Aggressive cleaning (unused packages + flake cache)"
    echo "4. Nuclear cleaning (WARNING: removes all old generations)"
    echo "5. Update NixOS (with test option)"
    echo "6. Exit"
    echo
    
    read -p "Select an option (1-6): " choice
    echo
    
    case $choice in
        1) show_disk_usage ;;
        2) basic_cleaning ;;
        3) aggressive_cleaning ;;
        4) nuclear_cleaning ;;
        5) update_nixos ;;
        6) print_color $GREEN "Goodbye!"; exit 0 ;;
        *) print_color $RED "Invalid option!" ;;
    esac
    
    echo
    read -p "Press Enter to continue..."
done