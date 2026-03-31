#!/bin/bash
# =============================================================================
# Script 1: System Identity Report
# Author: Ishan Baghel | Roll Number: 24BCE10485
# Course: Open Source Software | OSS Capstone Project
# Software Chosen: Git (GPL v2)
# Description: Displays a welcome screen with key system information including
#              kernel version, user details, uptime, and OS license info.
# =============================================================================

# --- Student Information Variables ---
STUDENT_NAME="Ishan Baghel"          # Replace with your actual name
ROLL_NUMBER="24BCE10485"    # Replace with your roll number
SOFTWARE_CHOICE="Git"               # Chosen open-source software

# --- Gather System Information using command substitution $() ---
KERNEL=$(uname -r)                          # Kernel release version
DISTRO=$(cat /etc/os-release | grep ^PRETTY_NAME | cut -d= -f2 | tr -d '"')  # Distro name
USER_NAME=$(whoami)                         # Currently logged-in user
HOME_DIR=$HOME                              # Home directory of current user
UPTIME=$(uptime -p)                         # Human-readable uptime
CURRENT_DATE=$(date '+%A, %d %B %Y')        # e.g. Tuesday, 31 March 2026
CURRENT_TIME=$(date '+%H:%M:%S')            # e.g. 14:35:22
HOSTNAME=$(hostname)                        # Machine hostname

# --- OS License Detection ---
# Most Linux distributions are licensed under GPL v2 or compatible licenses
# We check the os-release file for identification, then state the license
OS_ID=$(cat /etc/os-release | grep ^ID= | cut -d= -f2 | tr -d '"')

# Use a case statement to map known distros to their base license
case "$OS_ID" in
    ubuntu|debian|linuxmint)
        OS_LICENSE="GNU GPL v2 (Linux Kernel) + various open-source licenses"
        ;;
    fedora|rhel|centos|rocky|almalinux)
        OS_LICENSE="GNU GPL v2 (Linux Kernel) + GNU GPL / LGPL components"
        ;;
    arch|manjaro)
        OS_LICENSE="GNU GPL v2 (Linux Kernel) — rolling release"
        ;;
    *)
        OS_LICENSE="GNU General Public License v2 (GPL v2) — Linux Kernel"
        ;;
esac

# --- Display the System Identity Report ---
echo "============================================================"
echo "         OPEN SOURCE AUDIT — SYSTEM IDENTITY REPORT        "
echo "============================================================"
echo ""
echo "  Student   : $STUDENT_NAME ($ROLL_NUMBER)"
echo "  Software  : $SOFTWARE_CHOICE (Chosen for OSS Audit)"
echo ""
echo "------------------------------------------------------------"
echo "  SYSTEM INFORMATION"
echo "------------------------------------------------------------"
echo "  Hostname       : $HOSTNAME"
echo "  Distribution   : $DISTRO"
echo "  Kernel Version : $KERNEL"
echo "  Logged-in User : $USER_NAME"
echo "  Home Directory : $HOME_DIR"
echo ""
echo "------------------------------------------------------------"
echo "  TIME & AVAILABILITY"
echo "------------------------------------------------------------"
echo "  Date           : $CURRENT_DATE"
echo "  Time           : $CURRENT_TIME"
echo "  System Uptime  : $UPTIME"
echo ""
echo "------------------------------------------------------------"
echo "  LICENSE INFORMATION"
echo "------------------------------------------------------------"
echo "  OS License     : $OS_LICENSE"
echo "  Git License    : GNU General Public License v2 (GPL v2)"
echo "  What this means: You are free to use, study, modify, and"
echo "  redistribute this OS and Git — provided that any modified"
echo "  versions you distribute also remain open source (GPL v2)."
echo ""
echo "============================================================"
echo "  'Freedom is not just a feature — it is the foundation.'  "
echo "============================================================"
