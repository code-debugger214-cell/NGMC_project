#!/bin/bash
# =============================================================================
# Script 4: Log File Analyzer
# Author: Ishan Baghel | Roll Number: 24BCE10485
# Course: Open Source Software | OSS Capstone Project
# Software Chosen: Git (GPL v2)
# Description: Reads a log file line by line, counts occurrences of a keyword,
#              shows the last 5 matching lines, and retries if the file is empty.
# Usage: ./script4_log_analyzer.sh <logfile> [keyword]
# Example: ./script4_log_analyzer.sh /var/log/syslog error
# =============================================================================

# --- Command-line arguments ---
LOGFILE=$1                  # First argument: path to the log file
KEYWORD=${2:-"error"}       # Second argument: keyword to search (default: "error")
COUNT=0                     # Counter for keyword occurrences
MAX_RETRIES=3               # Maximum number of retry attempts if file is empty
RETRY=0                     # Current retry count

# --- Header ---
echo "============================================================"
echo "            LOG FILE ANALYZER — OSS Capstone Audit         "
echo "============================================================"
echo ""

# --- Validate that a log file argument was provided ---
if [ -z "$LOGFILE" ]; then
    echo "  ERROR: No log file specified."
    echo "  Usage: $0 <logfile> [keyword]"
    echo "  Example: $0 /var/log/syslog error"
    exit 1
fi

# --- Check that the specified file actually exists ---
if [ ! -f "$LOGFILE" ]; then
    echo "  ERROR: File '$LOGFILE' not found."
    echo ""
    echo "  Common log files to try:"
    echo "    /var/log/syslog        (Debian/Ubuntu)"
    echo "    /var/log/messages      (RHEL/CentOS/Fedora)"
    echo "    /var/log/auth.log      (authentication events)"
    echo "    /var/log/kern.log      (kernel messages)"
    exit 1
fi

echo "  Log File : $LOGFILE"
echo "  Keyword  : '$KEYWORD' (case-insensitive)"
echo ""

# --- Do-while style retry loop: retry if the file is empty ---
# Bash does not have a native do-while, so we simulate it with a while loop
# that always executes at least once by checking the condition at the bottom
while true; do

    # Check if the file is empty using the -s flag (true if file has size > 0)
    if [ ! -s "$LOGFILE" ]; then
        RETRY=$((RETRY + 1))    # Increment retry counter

        echo "  WARNING: '$LOGFILE' appears to be empty. (Attempt $RETRY of $MAX_RETRIES)"

        # If we have retried the maximum number of times, give up
        if [ "$RETRY" -ge "$MAX_RETRIES" ]; then
            echo "  Log file is empty after $MAX_RETRIES checks. Exiting."
            exit 1
        fi

        # Wait 2 seconds before retrying (log might be written to shortly)
        echo "  Waiting 2 seconds before retrying..."
        sleep 2
        continue    # Go back to the top of the while loop
    fi

    # File has content — break out of the retry loop and proceed
    break

done

echo "  File size: $(du -sh "$LOGFILE" | cut -f1) | Lines: $(wc -l < "$LOGFILE")"
echo ""
echo "------------------------------------------------------------"
echo "  SCANNING FOR KEYWORD: '$KEYWORD'"
echo "------------------------------------------------------------"

# --- While-read loop: read the file line by line ---
# IFS= prevents leading/trailing whitespace from being stripped
# -r prevents backslash from being treated as an escape character
while IFS= read -r LINE; do

    # if-then: check if the current line contains the keyword (case-insensitive)
    # grep -i = case insensitive, -q = quiet (no output, just exit code)
    if echo "$LINE" | grep -iq "$KEYWORD"; then
        COUNT=$((COUNT + 1))    # Increment the match counter
    fi

done < "$LOGFILE"   # Redirect file content into the while loop

# --- Print the total count ---
echo ""
echo "  Keyword '$KEYWORD' found $COUNT time(s) in: $LOGFILE"
echo ""

# --- Show the last 5 matching lines using tail + grep pipeline ---
# This gives context about the most recent occurrences
echo "------------------------------------------------------------"
echo "  LAST 5 LINES MATCHING '$KEYWORD':"
echo "------------------------------------------------------------"

# grep -i = case insensitive; tail -5 = show only the last 5 results
MATCHES=$(grep -i "$KEYWORD" "$LOGFILE" | tail -5)

if [ -n "$MATCHES" ]; then
    # -n "$MATCHES" is true if the variable is NOT empty
    echo "$MATCHES" | while IFS= read -r MATCH_LINE; do
        echo "  >> $MATCH_LINE"
    done
else
    echo "  No matching lines found."
fi

echo ""
echo "------------------------------------------------------------"

# --- Summary statistics ---
TOTAL_LINES=$(wc -l < "$LOGFILE")   # Total number of lines in the file

# Calculate percentage of lines containing the keyword (integer arithmetic)
if [ "$TOTAL_LINES" -gt 0 ]; then
    PERCENT=$(( COUNT * 100 / TOTAL_LINES ))
    echo "  SUMMARY: $COUNT of $TOTAL_LINES lines ($PERCENT%) contain '$KEYWORD'"
else
    echo "  SUMMARY: File contains 0 lines."
fi

echo ""
echo "============================================================"
echo "  Transparency in logging is an open-source value —"
echo "  your logs are yours to read, audit, and understand."
echo "============================================================"
