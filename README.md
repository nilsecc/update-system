# update-system

Maintenance script for **Arch-based Linux Distributions**. This script automates common system maintenance tasks, designed for users who want a **single command to keep their system clean and updated**.

---

## Features 

- System update (official repositories + AUR)
- Orphan dependency detection and removal
- Pacman cache cleaning
- AUR cache cleaning
- Detection of .pacnew configuration files
- Systemd log cleanup
- Disk space comparison before and after update

---

## Requirements

The script requires: 

- Arch-based Linux distribution
- yay (AUR helper)
- paccache (from pacman-contrib)
- Optional: figlet for banner display

Install requirements:

```bash
sudo pacman -S yay pacman-contrib figlet
```

--- 

## Usage

Make the script executable:

```bash
chmod +x update-system.sh
```

Run it:

```bash
./update-system.sh
```

---

## Optional 

You can add an alias to easily run the script from anywhere. 
Add this line to your ~/.bashrc or ~/.zshrc or any shell:

```bash
alias update="/path/to/update-system.sh"
```

Now you can simply run:

```bash
update
```
