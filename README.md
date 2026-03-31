# OSS Audit — The Open Source Audit

**Student Name:** Ishan Baghel  
**Roll Number:** 24BCE10485  
**Course:** Open Source Software — NGMC Capstone  
**Chosen Software:** Git (GNU General Public License v2)  
**Repository:** `oss-audit-[rollnumber]`

---

## About This Project

This repository contains the five shell scripts submitted as part of the **Open Source Audit** capstone project for the OSS course. The chosen software for the audit is **Git** — the distributed version control system originally created by Linus Torvalds in 2005, released under the **GNU GPL v2** license.

Each script is fully commented and demonstrates specific shell scripting concepts covered in Units 1–5 of the course.

---

## Repository Structure

```
oss-audit-[rollnumber]/
│
├── script1_system_identity.sh       # System Identity Report
├── script2_package_inspector.sh     # FOSS Package Inspector
├── script3_disk_permission_auditor.sh  # Disk and Permission Auditor
├── script4_log_analyzer.sh          # Log File Analyzer
├── script5_manifesto_generator.sh   # Open Source Manifesto Generator
│
└── README.md                        # This file
```

---

## Script Descriptions

### Script 1 — System Identity Report
**File:** `script1_system_identity.sh`

Displays a welcome screen with key system information including the Linux distribution name, kernel version, logged-in user, home directory, system uptime, current date and time, and the open-source license that covers the operating system and Git.

**Shell concepts used:** Variables, `echo`, command substitution `$()`, `case` statement, basic output formatting with `printf`.

---

### Script 2 — FOSS Package Inspector
**File:** `script2_package_inspector.sh`

Checks whether Git (or any specified FOSS package) is installed on the system. Detects whether the system uses RPM (`rpm -qi`) or DEB (`dpkg -l`) package management, retrieves version and license information, and uses a `case` statement to print a one-line open-source philosophy note for each known package.

**Shell concepts used:** `if-then-else`, `case` statement, `rpm -qi` / `dpkg -l`, pipe with `grep`, `command -v` for tool detection.

---

### Script 3 — Disk and Permission Auditor
**File:** `script3_disk_permission_auditor.sh`

Loops through a predefined list of important system directories (`/etc`, `/var/log`, `/home`, `/usr/bin`, `/tmp`, `/usr/share`, `/opt`) and reports the size, permissions, owner, and group of each. Also specifically audits Git's configuration paths (`/etc/gitconfig`, `~/.gitconfig`) and flags world-readable sensitive files.

**Shell concepts used:** `for` loop, arrays, `df -h`, `du -sh`, `ls -ld`, `awk`, `cut`, `-d` directory check, `-e` existence check.

---

### Script 4 — Log File Analyzer
**File:** `script4_log_analyzer.sh`

Reads a log file line by line and counts how many lines contain a specified keyword (default: `error`). Includes a do-while style retry loop that re-checks if the file is empty before proceeding, and displays the last 5 matching lines with a percentage summary.

**Shell concepts used:** `while IFS= read -r` loop, `if-then`, counter variables `$(())`, command-line arguments `$1` and `$2`, `grep -i`, `tail`, `wc -l`, exit codes.

**Usage:**
```bash
./script4_log_analyzer.sh /var/log/syslog error
./script4_log_analyzer.sh /var/log/auth.log WARNING
```

---

### Script 5 — Open Source Manifesto Generator
**File:** `script5_manifesto_generator.sh`

An interactive script that asks the user three questions, then composes and saves a personalised open-source philosophy statement to a `.txt` file named `manifesto_<username>.txt`. Demonstrates the alias concept via comments and shell functions.

**Shell concepts used:** `read -p` for user input, string concatenation with `echo >>`, writing to a file with `>` and `>>`, `date` command, shell functions, `cat` to display output, the alias concept demonstrated via comments.

**Usage:**
```bash
./script5_manifesto_generator.sh
```
The script is interactive — it will prompt you for input.

---

## How to Run the Scripts

### Step 1 — Clone the Repository

```bash
git clone https://github.com/[your-username]/oss-audit-[rollnumber].git
cd oss-audit-[rollnumber]
```

### Step 2 — Make the Scripts Executable

```bash
chmod +x script1_system_identity.sh
chmod +x script2_package_inspector.sh
chmod +x script3_disk_permission_auditor.sh
chmod +x script4_log_analyzer.sh
chmod +x script5_manifesto_generator.sh
```

Or make all of them executable at once:

```bash
chmod +x *.sh
```

### Step 3 — Run Each Script

```bash
# Script 1: No arguments needed
./script1_system_identity.sh

# Script 2: No arguments needed (inspects Git by default)
./script2_package_inspector.sh

# Script 3: No arguments needed
./script3_disk_permission_auditor.sh

# Script 4: Provide a log file path and optional keyword
./script4_log_analyzer.sh /var/log/syslog error
./script4_log_analyzer.sh /var/log/auth.log failed

# Script 5: No arguments — interactive prompts
./script5_manifesto_generator.sh
```

---

## Dependencies

| Script | Dependencies | Notes |
|--------|-------------|-------|
| Script 1 | `uname`, `whoami`, `uptime`, `date`, `cat` | All standard — available on every Linux system |
| Script 2 | `rpm` or `dpkg`, `grep`, `git` | `rpm` for Red Hat family; `dpkg` for Debian/Ubuntu |
| Script 3 | `ls`, `du`, `df`, `awk`, `cut` | All standard — available on every Linux system |
| Script 4 | `grep`, `tail`, `wc`, `sleep` | All standard — available on every Linux system |
| Script 5 | `date`, `cat`, `echo` | All standard — available on every Linux system |

All scripts are written in **Bash** and require no additional package installation beyond the standard Linux utilities listed above. They have been written to run on both **Debian/Ubuntu** and **Red Hat/Fedora/CentOS** based systems.

---

## Tested Environments

- Ubuntu 22.04 LTS / 24.04 LTS
- Fedora 38+
- CentOS Stream 9 / Rocky Linux 9
- Any system with Bash 4.0+

---

## Notes on Script 4 — Log File

Script 4 requires an existing log file to analyse. Common paths to use:

| Distribution | Log File Path |
|---|---|
| Ubuntu / Debian | `/var/log/syslog` |
| Fedora / RHEL / CentOS | `/var/log/messages` |
| Any system | `/var/log/auth.log` or `/var/log/kern.log` |

If you do not have access to system logs, you can create a test log file:

```bash
echo "INFO: system started" > test.log
echo "ERROR: connection refused" >> test.log
echo "WARNING: disk space low" >> test.log
echo "ERROR: failed to start service" >> test.log
./script4_log_analyzer.sh test.log error
```

---

## Academic Integrity

All scripts in this repository are original work written for the VITyarthi OSS Capstone. The code demonstrates understanding of shell scripting concepts as taught in Units 1–5 of the course. Comments in each script explain every non-obvious line.

---

*"Every tool you will use in your career was shaped by people who chose to build in the open and share their work freely."*
