#!/bin/bash
# =============================================================================
# Script 3: Disk and Permission Auditor
# Author: Ishan Baghel | Roll Number: 24BCE10485
# Course: Open Source Software | OSS Capstone Project
# Software Chosen: Git (GPL v2)
# Description: Loops through important system directories and reports their
#              size, permissions, owner, and group. Also checks Git's config
#              directory specifically.
# =============================================================================

# --- List of important system directories to audit ---
# These directories are standard on Linux (FHS - Filesystem Hierarchy Standard)
DIRS=("/etc" "/var/log" "/home" "/usr/bin" "/tmp" "/usr/share" "/opt")

# --- Header ---
echo "============================================================"
echo "         DISK AND PERMISSION AUDITOR — OSS Audit           "
echo "============================================================"
echo ""
printf "%-20s %-15s %-30s\n" "DIRECTORY" "SIZE" "PERMISSIONS  OWNER  GROUP"
echo "------------------------------------------------------------"

# --- For loop: iterate over each directory in the DIRS array ---
for DIR in "${DIRS[@]}"; do

    # Check if the directory actually exists before trying to inspect it
    if [ -d "$DIR" ]; then
        # ls -ld gives a long listing for the directory itself (not its contents)
        # awk '{print $1, $3, $4}' extracts: permissions, owner, group
        PERMS=$(ls -ld "$DIR" | awk '{print $1, $3, $4}')

        # du -sh gives human-readable size; 2>/dev/null suppresses permission errors
        # cut -f1 takes only the size field (before the tab)
        SIZE=$(du -sh "$DIR" 2>/dev/null | cut -f1)

        # Print formatted row with directory, size, and permissions info
        printf "%-20s %-15s %-30s\n" "$DIR" "${SIZE:-N/A}" "$PERMS"
    else
        # Directory does not exist on this system
        printf "%-20s %-15s %-30s\n" "$DIR" "MISSING" "Directory not found"
    fi

done

echo ""
echo "------------------------------------------------------------"
echo "  GIT CONFIGURATION DIRECTORY AUDIT"
echo "------------------------------------------------------------"

# --- Check Git's global and system config directories specifically ---
# Git stores its system config in /etc/gitconfig and user config in ~/.gitconfig

# Array of Git-related paths to check
GIT_PATHS=("/etc/gitconfig" "$HOME/.gitconfig" "$HOME/.git" "/usr/share/git-core")

for GIT_PATH in "${GIT_PATHS[@]}"; do

    # Check if path exists (could be file or directory)
    if [ -e "$GIT_PATH" ]; then
        # Get permissions using ls -ld (works for both files and directories)
        GIT_PERMS=$(ls -ld "$GIT_PATH" | awk '{print $1, $3, $4}')
        GIT_SIZE=$(du -sh "$GIT_PATH" 2>/dev/null | cut -f1)

        echo "  Path       : $GIT_PATH"
        echo "  Permissions: $GIT_PERMS"
        echo "  Size       : ${GIT_SIZE:-N/A}"

        # Security note: warn if sensitive config files are world-readable
        # The first character from ls is file type; chars 8-10 are 'other' permissions
        WORLD_READ=$(ls -ld "$GIT_PATH" | cut -c8)
        if [ "$WORLD_READ" = "r" ]; then
            echo "  [NOTE] This path is world-readable — review if sensitive."
        fi
        echo ""
    else
        echo "  Path       : $GIT_PATH — NOT FOUND (may not be configured yet)"
        echo ""
    fi

done

# --- Overall disk usage summary ---
echo "------------------------------------------------------------"
echo "  OVERALL DISK USAGE SUMMARY"
echo "------------------------------------------------------------"

# df -h shows human-readable disk usage for all mounted filesystems
# grep '^/' filters only real disk partitions (excludes tmpfs, udev, etc.)
df -h | grep -E 'Filesystem|^/' | awk '{printf "  %-25s %-8s %-8s %-8s %s\n", $1, $2, $3, $4, $5}'

echo ""
echo "============================================================"
echo "  Tip: Permissions like 777 on /tmp are expected — it is"
echo "  a world-writable sticky directory by design (drwxrwxrwt)."
echo "============================================================"
