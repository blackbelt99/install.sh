#!/bin/bash

# ==========================================================
# BLACKBELT VPS DASHBOARD
# ==========================================================

# Colors
CYAN='\033[0;36m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
PURPLE='\033[0;35m'
RED='\033[0;31m'
WHITE='\033[1;37m'
GRAY='\033[0;90m'
NC='\033[0m'

clear

# ----------------------------------------------------------
# Header
# ----------------------------------------------------------

echo ""
echo -e "${CYAN}╭──────────────────────────────────────────────────────────╮${NC}"
echo -e "${CYAN}│${NC} ${WHITE}BLACKBELT VPS CONTROL${NC}                               ${CYAN}│${NC}"
echo -e "${CYAN}╰──────────────────────────────────────────────────────────╯${NC}"

echo ""

# Fake/status display
HOSTNAME_NOW=$(hostname 2>/dev/null || echo "BLACKBELT")
UPTIME_NOW=$(uptime -p 2>/dev/null | sed 's/up //' || echo "Online")

echo -e "${CYAN}●${NC} ${WHITE}SYSTEM STATUS${NC}"
echo -e "  Host       : ${GREEN}${HOSTNAME_NOW}${NC}"
echo -e "  Uptime     : ${GRAY}${UPTIME_NOW}${NC}"
echo -e "  Network    : ${GREEN}● CONNECTED${NC}"

echo ""
echo -e "${CYAN}──────────────────────────────────────────────────────────${NC}"
echo ""

# ----------------------------------------------------------
# Deployment
# ----------------------------------------------------------

echo -e "${CYAN}▣ DEPLOYMENT & SERVICES${NC}"
echo ""
echo -e "  ${WHITE}[1]${NC} VPS          ${GRAY}Virtual Private Server${NC}"
echo -e "  ${WHITE}[2]${NC} Panel        ${GRAY}Control Panel${NC}"
echo -e "  ${WHITE}[3]${NC} Wings        ${GRAY}Server Node${NC}"
echo -e "  ${WHITE}[4]${NC} Toolbox      ${GRAY}Management Tools${NC}"
echo -e "  ${WHITE}[5]${NC} Themes       ${GRAY}Dashboard Themes${NC}"
echo -e "  ${WHITE}[6]${NC} System       ${GRAY}System Information${NC}"
echo -e "  ${WHITE}[7]${NC} Container    ${GRAY}Container Management${NC}"
echo -e "  ${GREEN}[8]${NC} New Module   ${GRAY}Additional Module${NC}"

echo ""

# ----------------------------------------------------------
# Maintenance
# ----------------------------------------------------------

echo -e "${PURPLE}▣ MAINTENANCE & TOOLS${NC}"
echo ""
echo -e "  ${WHITE}[9]${NC} Extras       ${GRAY}Extra Utilities${NC}"
echo ""
echo -e "                  ${RED}[0] SHUTDOWN SYSTEM${NC}"

echo ""
echo -e "${CYAN}──────────────────────────────────────────────────────────${NC}"
echo ""

echo -ne "${CYAN}➜${NC} ${WHITE}Enter Option (0-9):${NC} "
read OPTION

case "$OPTION" in

    1)
        clear
        echo -e "${GREEN}[ VPS ]${NC} Opening VPS management..."
        sleep 1
        ;;

    2)
        clear
        echo -e "${GREEN}[ PANEL ]${NC} Opening panel management..."
        sleep 1
        ;;

    3)
        clear
        echo -e "${GREEN}[ WINGS ]${NC} Opening Wings management..."
        sleep 1
        ;;

    4)
        clear
        echo -e "${GREEN}[ TOOLBOX ]${NC} Opening toolbox..."
        sleep 1
        ;;

    5)
        clear
        echo -e "${GREEN}[ THEMES ]${NC} Opening themes..."
        sleep 1
        ;;

    6)
        clear
        echo ""
        echo -e "${CYAN}SYSTEM INFORMATION${NC}"
        echo ""
        echo "Hostname : $(hostname)"
        echo "Kernel   : $(uname -r)"
        echo "OS       : $(grep PRETTY_NAME /etc/os-release 2>/dev/null | cut -d= -f2- | tr -d '"')"
        echo ""
        read -p "Press Enter to return..."
        exec "$0"
        ;;

    7)
        clear
        echo -e "${GREEN}[ CONTAINER ]${NC} Opening container management..."
        sleep 1
        ;;

    8)
        clear
        echo -e "${GREEN}[ NEW MODULE ]${NC} Module system ready..."
        sleep 1
        ;;

    9)
        clear
        echo -e "${GREEN}[ EXTRAS ]${NC} Opening extra utilities..."
        sleep 1
        ;;

    0)
        clear
        echo -e "${RED}BLACKBELT VPS SYSTEM SHUTDOWN${NC}"
        exit 0
        ;;

    *)
        echo ""
        echo -e "${RED}Invalid option.${NC}"
        sleep 1
        exec "$0"
        ;;

esac
