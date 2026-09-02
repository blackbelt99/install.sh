#!/bin/bash

# BLACKBELT // MAIN LAUNCHER
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; PURPLE='\033[0;35m'; CYAN='\033[0;36m'; WHITE='\033[1;37m'; GRAY='\033[0;90m'; NC='\033[0m'
DASHBOARD_URL="https://raw.githubusercontent.com/blackbelt99/install.sh/main/vps-dashboard.sh"

while true; do
    clear
    echo -e "${CYAN}┌──────────────────────────────────────────────────────────┐${NC}"
    echo -e "${CYAN}│${NC} ${WHITE}BLACKBELT CONTROL CENTER${NC}                 ${GREEN}● ONLINE${NC} ${CYAN}│${NC}"
    echo -e "${CYAN}├──────────────────────────────────────────────────────────┤${NC}"
    echo -e "${CYAN}│${NC} ${YELLOW}SYSTEM${NC}   ${GREEN}ONLINE${NC}      ${YELLOW}ENGINE${NC}   ${WHITE}QEMU / VM${NC}       ${CYAN}│${NC}"
    echo -e "${CYAN}│${NC} ${YELLOW}PROFILE${NC}  ${WHITE}UBUNTU 22.04${NC}  ${YELLOW}NETWORK${NC}  ${WHITE}TCP FORWARD${NC}  ${CYAN}│${NC}"
    echo -e "${CYAN}└──────────────────────────────────────────────────────────┘${NC}"
    echo ""
    echo -e " ${CYAN}BLACKBELT${NC} ${GRAY}//${NC} ${WHITE}MAIN MODULES${NC}"
    echo -e " ${GRAY}Choose a module to continue:${NC}"
    echo ""
    echo -e " ${CYAN}[A]${NC} ${WHITE}VPS${NC}       ${GREEN}Virtual Private Server${NC}"
    echo -e "     └─ ${GRAY}Open VPS dashboard and management tools${NC}"
    echo ""
    echo -e " ${PURPLE}[B]${NC} ${WHITE}OTHER${NC}     ${GRAY}Reserved for future modules${NC}"
    echo ""
    echo -e " ${RED}[Q]${NC} ${WHITE}EXIT${NC}      ${GRAY}Close BLACKBELT${NC}"
    echo ""
    echo -e "${CYAN}────────────────────────────────────────────────────────────${NC}"
    echo -ne "${YELLOW}blackbelt@core${NC} > "
    read -r CHOICE
    case "${CHOICE:-}" in
        A|a)
            TMP="/tmp/blackbelt-vps-dashboard.sh"
            if curl -fsSL "$DASHBOARD_URL" -o "$TMP"; then
                chmod +x "$TMP"
                bash "$TMP"
                rm -f "$TMP"
            else
                echo -e "${RED}Could not load VPS dashboard from GitHub.${NC}"
                read -rp "Press Enter..."
            fi
            ;;
        B|b) echo -e "${GRAY}Other modules are not configured yet.${NC}"; sleep 1 ;;
        Q|q) clear; echo -e "${GREEN}BLACKBELT session closed.${NC}"; exit 0 ;;
        *) echo -e "${RED}Invalid option. Use A, B or Q.${NC}"; sleep 1 ;;
    esac
done
