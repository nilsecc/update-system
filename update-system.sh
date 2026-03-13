#!/bin/bash

# Security error handling
set -eu

# Colors
ROJO='\033[0;31m'
VERDE='\033[0;32m'
AMARILLO='\033[1;33m'
AZUL='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color (Reset)

# BANNER
if command -v figlet &> /dev/null; then
    echo -e "${AZUL}"
    figlet System Updater
    echo -e "${NC}"
else
    echo -e "${AZUL}--- System Updater ---${NC}"
fi
echo -e "${CYAN}By: nilsecc | For Arch-based systems${NC}"
echo "--------------------------------------------------------------------------"

# Checking if yay is installed
if ! command -v yay &> /dev/null; then
    echo -e "${ROJO}Error: yay is not installed.${NC}"
    exit 1
fi

# Show free space before updates
before=$(df -h / | tail -1 | awk '{print $4}')

# Official + AUR update through yay
echo ""
echo -e "${AZUL}Updating dependencies and packages...${NC}"
yay -Syu --noconfirm

# Clean Orphan dependencies
echo ""
echo -e "${AZUL}Searching for orphan dependencies...${NC}"
orphans=$(pacman -Qtdq) || orphans=""

if [[ -n "$orphans" ]]; then
    echo -e "${AMARILLO}Deleting orphan dependencies:${NC}"
    echo "$orphans"
    sudo pacman -Rns $orphans --noconfirm
else
    echo -e "${VERDE}No orphan dependencies.${NC}"
fi

# Clean Cache
echo ""
echo -e "${AZUL}Cleaning pacman cache (keeping last 3)...${NC}"
sudo paccache -r

echo ""
echo -e "${AZUL}Cleaning AUR cache (keeping last 3)...${NC}"
if [ -d "$HOME/.cache/yay" ]; then
    paccache -r -k 3 -c "$HOME/.cache/yay"
fi

# Search for .pacnew
echo ""
echo -e "${AZUL}Searching for new .pacnew files...${NC}"
pacnew=$(sudo find /etc -name "*.pacnew" 2>/dev/null || true)

if [[ -n "$pacnew" ]]; then
    echo -e "${ROJO}Found .pacnew files:${NC}"
    echo -e "${AMARILLO}$pacnew${NC}"
else
    echo -e "${VERDE}No .pacnew files found.${NC}"
fi

# Cleaning logs
echo ""
echo -e "${AZUL}Cleaning old systemd logs...${NC}"
sudo journalctl --vacuum-time=2weeks

# Final free space
after=$(df -h / | tail -1 | awk '{print $4}')

echo ""
echo -e "${CYAN}------------------------------------${NC}"
echo -e "${VERDE}Free space before update: $before${NC}"
echo -e "${VERDE}Free space after update: $after${NC}"
echo -e "${CYAN}------------------------------------${NC}"

echo ""
echo -e "${VERDE}DONE.${NC}"
