#!/bin/bash
# =============================================================================
# Script 2: FOSS Package Inspector
# Author: Ishan Baghel | Roll Number: 24BCE10485
# Course: Open Source Software | OSS Capstone Project
# Software Chosen: Git (GPL v2)
# Description: Checks whether key FOSS packages are installed, retrieves their
#              version and license info, and prints a philosophy note for each.
# =============================================================================

# --- Package to inspect (primary: Git) ---
PACKAGE="git"   # Change this if inspecting a different package

# --- Helper function: detect package manager and query package ---
# This function checks for rpm (Red Hat family) or dpkg (Debian family)
check_package() {
    local PKG=$1    # Local variable holds the package name passed in

    echo "------------------------------------------------------------"
    echo "  Inspecting Package: $PKG"
    echo "------------------------------------------------------------"

    # --- Detect which package manager is available on this system ---
    if command -v rpm &>/dev/null; then
        # RPM-based system (Fedora, CentOS, RHEL, Rocky Linux, etc.)
        if rpm -q "$PKG" &>/dev/null; then
            # Package is installed — print version, license, and summary
            echo "  Status  : INSTALLED (RPM-based system)"
            rpm -qi "$PKG" | grep -E 'Version|License|Summary|Size'
        else
            echo "  Status  : NOT INSTALLED on this RPM-based system"
            echo "  Install : sudo dnf install $PKG   (or yum install $PKG)"
        fi

    elif command -v dpkg &>/dev/null; then
        # Debian/Ubuntu-based system
        if dpkg -l "$PKG" 2>/dev/null | grep -q "^ii"; then
            # Package is installed — print version and description
            echo "  Status  : INSTALLED (Debian/Ubuntu-based system)"
            dpkg -l "$PKG" | grep "^ii" | awk '{print "  Version : "$3"\n  Arch    : "$4}'
            # Show more details if apt-cache is available
            if command -v apt-cache &>/dev/null; then
                apt-cache show "$PKG" 2>/dev/null | grep -E 'Version|License|Description-en' | head -5
            fi
        else
            echo "  Status  : NOT INSTALLED on this Debian/Ubuntu system"
            echo "  Install : sudo apt install $PKG"
        fi
    else
        # Fallback: try 'which' to see if the binary exists in PATH at all
        if which "$PKG" &>/dev/null; then
            echo "  Status  : FOUND in PATH (package manager unknown)"
            echo "  Version : $($PKG --version 2>/dev/null | head -1)"
        else
            echo "  Status  : NOT FOUND — no known package manager detected"
        fi
    fi
}

# --- Run the package check for Git ---
echo "============================================================"
echo "        FOSS PACKAGE INSPECTOR — OSS Capstone Audit        "
echo "============================================================"
echo ""

check_package "$PACKAGE"

echo ""

# --- Show Git version directly if binary is available ---
if command -v git &>/dev/null; then
    echo "  Git Binary  : $(which git)"
    echo "  Git Version : $(git --version)"
fi

echo ""

# --- Case statement: Philosophy notes for known FOSS packages ---
# A case statement matches the package name and prints a philosophy message
echo "------------------------------------------------------------"
echo "  OPEN SOURCE PHILOSOPHY NOTE"
echo "------------------------------------------------------------"

case "$PACKAGE" in
    git)
        echo "  Git (GPL v2): Born from Linus Torvalds' frustration with"
        echo "  proprietary version control, Git embodies the open-source"
        echo "  belief that tools built by the community should remain free."
        echo "  Every GitHub repository is built on top of this GPL software."
        ;;
    httpd|apache2)
        echo "  Apache (Apache 2.0): The web server that helped build the"
        echo "  open internet. Permissive licensed — companies can use it"
        echo "  without releasing their own code, fuelling widespread adoption."
        ;;
    mysql|mysqld)
        echo "  MySQL (GPL v2 / Commercial dual-license): A rare example of"
        echo "  a dual-license model — free for open-source use, commercial"
        echo "  for proprietary products. Shows how FOSS can fund itself."
        ;;
    firefox)
        echo "  Firefox (MPL 2.0): Mozilla's browser is a nonprofit's stand"
        echo "  against browser monopolies. MPL allows file-level copyleft,"
        echo "  balancing openness with commercial participation."
        ;;
    vlc)
        echo "  VLC (LGPL/GPL): Started by French students who just wanted"
        echo "  to watch video on their university network. Now it plays"
        echo "  virtually every format — freely, on every platform."
        ;;
    python3|python)
        echo "  Python (PSF License): Shaped entirely by community consensus"
        echo "  through PEPs. A permissive license encouraged adoption in"
        echo "  academia, industry, and open science alike."
        ;;
    libreoffice)
        echo "  LibreOffice (MPL 2.0): Born from a community fork of OpenOffice"
        echo "  when Oracle's stewardship raised concerns. Proof that community"
        echo "  ownership can rescue a project from corporate indifference."
        ;;
    *)
        # Default case for any unlisted package
        echo "  '$PACKAGE': Every FOSS package carries a story of someone"
        echo "  choosing to share their work rather than lock it away."
        echo "  That choice is the foundation of the modern software world."
        ;;
esac

echo ""
echo "============================================================"
