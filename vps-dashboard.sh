#!/bin/bash

clear

# ==========================================
# 🌟 PREMIUM COLOR CODES & FX
# ==========================================
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
TEAL='\033[38;5;93m'
NC='\033[0m'

# ==========================================
# LOCATE & LOAD install.sh (same folder as this script)
# ==========================================
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INSTALL_SCRIPT="${SCRIPT_DIR}/install.sh"

if [ -f "$INSTALL_SCRIPT" ]; then
    # Sourcing just loads the vps_dashboard()/create_vps()/etc. functions.
    # install.sh only auto-runs the panel when executed directly on its own.
    source "$INSTALL_SCRIPT"
else
    echo -e "${RED}✗ install.sh not found next to vps-dashboard.sh${NC}"
    echo -e "${YELLOW}  Expected at: ${INSTALL_SCRIPT}${NC}"
fi

# ==========================================
# OUTER MAIN MENU
# ==========================================
show_menu() {
    clear
    echo -e "${TEAL}==========================================================${NC}"
    echo -e "${WHITE}          [🥋 BLACKBELT PREMIUM VPS DASHBOARD 🥋]          ${NC}"
    echo -e "${TEAL}==========================================================${NC}"
    echo -e "${CYAN}  ____  _        _    ____ _  ______  _____ _   _____ ${NC}"
    echo -e "${CYAN} | __ )| |      / \\  / ___| |/ / __ )| ____| | |_   _|${NC}"
    echo -e "${CYAN} |  _ \\| |     / _ \\| |   | ' /|  _ \\|  _| | |   | |  ${NC}"
    echo -e "${CYAN} | |_) | |___ / ___ \\ |___| . \\| |_) | |___| |___| |  ${NC}"
    echo -e "${CYAN} |____/|_____/_/   \\_\\____|_|\\_\\____/|_____|_____|_|  ${NC}"
    echo -e "${TEAL}==========================================================${NC}"
    echo ""
    echo -e "${YELLOW}👉 SELECT AN OPTION TO PROCEED FROM LIST:${NC}"
    echo ""
    echo -e "  ${CYAN}[1]${NC} VPS Control Panel (Create/Restart/Network/System)"
    echo -e "  ${CYAN}[2]${NC} Exit Dashboard"
    echo ""
    echo -e "${TEAL}==========================================================${NC}"
    echo -ne "${WHITE}🔹 Enter Choice [1-2]: ${NC}"
    read -r CHOICE

    case "${CHOICE:-}" in
        1)
            if command -v vps_dashboard >/dev/null 2>&1; then
                vps_dashboard
            else
                echo -e "${RED}✗ install.sh failed to load, cannot open VPS Control Panel.${NC}"
                sleep 2
            fi
            ;;
        2) exit 0 ;;
        *) echo -e "${RED}❌ Invalid Choice! Please select 1-2.${NC}"; sleep 2 ;;
    esac
}

# EXECUTE TRIGGER
while true; do
    show_menu
done
