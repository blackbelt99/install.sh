#!/bin/bash

# Clear terminal for clean dashboard view
clear

# ==========================================
# 🌟 PREMIUM COLOR CODES & FX
# ==========================================
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m'

# FUNCTION: TYPING EFFECT ANIMATION
type_effect() {
    local text="$1"
    local delay="$2"
    for (( i=0; i<${#text}; i++ )); do
        echo -n "${text:$i:1}"
        sleep "$delay"
    done
    echo ""
}

# FUNCTION: LOADING BAR ANIMATION
loading_bar() {
    local title="$1"
    echo -ne "${YELLOW}⏳ $title ${NC}[          ]"
    sleep 0.3
    echo -ne "\b\b\b\b\b\b\b\b\b\b\b[===       ]"
    sleep 0.3
    echo -ne "\b\b\b\b\b\b\b\b\b\b\b[======     ]"
    sleep 0.3
    echo -ne "\b\b\b\b\b\b\b\b\b\b\b[=========  ]"
    sleep 0.3
    echo -ne "\b\b\b\b\b\b\b\b\b\b\b[==========]"
    echo -e " ${GREEN}DONE!${NC}"
}

# AUTOMATED ROOT/SUDO PRIVILEGE CHECK
if [ "$(id -u)" -eq 0 ]; then
    SUDO_CMD=""
else
    SUDO_CMD="sudo"
fi

# ==========================================
# MAIN INTERACTIVE LIST MENU
# ==========================================
show_menu() {
    clear

    # BLACKBELT // MODERN TERMINAL UI
    echo -e "${BLUE}┌──────────────────────────────────────────────────────────────┐${NC}"
    echo -e "${BLUE}│${NC} ${WHITE}BLACKBELT${NC} ${CYAN}//${NC} ${WHITE}VPS MANAGEMENT TERMINAL${NC}             ${GREEN}● READY${NC} ${BLUE}│${NC}"
    echo -e "${BLUE}├──────────────────────────────────────────────────────────────┤${NC}"
    echo -e "${BLUE}│${NC}  ${YELLOW}SYSTEM${NC}    ${GREEN}ONLINE${NC}       ${YELLOW}ENGINE${NC}    QEMU / VM           ${BLUE}│${NC}"
    echo -e "${BLUE}│${NC}  ${YELLOW}PROFILE${NC}   UBUNTU 22.04   ${YELLOW}NETWORK${NC}  TCP FORWARD       ${BLUE}│${NC}"
    echo -e "${BLUE}└──────────────────────────────────────────────────────────────┘${NC}"
    echo ""

    echo -e "${CYAN}  BLACKBELT CONTROL CENTER${NC}"
    echo -e "  ${WHITE}Choose a module to continue:${NC}"
    echo ""

    echo -e "  ${BLUE}01${NC}  ${WHITE}CREATE VM${NC}       ${GREEN}New Ubuntu instance${NC}"
    echo -e "      └─ Provision storage, CPU, RAM and boot the VM"
    echo ""
    echo -e "  ${BLUE}02${NC}  ${WHITE}RESTART VM${NC}      ${GREEN}Existing instance${NC}"
    echo -e "      └─ Restart the current Ubuntu VM channel"
    echo ""
    echo -e "  ${BLUE}03${NC}  ${WHITE}NETWORK${NC}         ${GREEN}TCP port forwarding${NC}"
    echo -e "      └─ Add or modify host → VM forwarding rules"
    echo ""
    echo -e "  ${BLUE}04${NC}  ${WHITE}MAINTENANCE${NC}     ${GREEN}Cache & configuration${NC}"
    echo -e "      └─ Clean local VPS files and temporary data"
    echo ""
    echo -e "  ${RED}05${NC}  ${WHITE}CLOSE TERMINAL${NC}  ${RED}Exit${NC}"
    echo ""
    echo -e "${CYAN}────────────────────────────────────────────────────────────────${NC}"
    echo -ne "${WHITE}blackbelt${NC}@${CYAN}core${NC} ${BLUE}›${NC} "
    read CHOICE

    case $CHOICE in
        1) create_vps ;;
        2) restart_vps ;;
        3) configure_tcp ;;
        4) clean_vps ;;
        5) exit 0 ;;
        *) echo -e "${RED}Invalid module. Use 1-5.${NC}"; sleep 2; show_menu ;;
    esac
}

# STEP 1: CONFIGURE STORAGE & DOWNLOAD CLOUD ARCHITECTURE
create_vps() {
    clear
    echo -e "${RED}==========================================================${NC}"
    echo -e "${WHITE}BLACKBELT // CREATE VM${NC}"
    echo -e "${RED}==========================================================${NC}"
    echo ""
    
    echo -ne "${BLUE}🔹 Enter RAM Size in GB (e.g., 4, 8, 16, 32): ${NC}"
    read RAM_GB
    echo -ne "${BLUE}🔹 Enter CPU Cores (e.g., 2, 4, 8): ${NC}"
    read CPU_CORES
    echo -ne "${BLUE}🔹 Enter Disk Space to ADD in GB (e.g., 10, 20): ${NC}"
    read DISK_ADD
    echo -ne "${BLUE}🔹 Create Username (Default: ubuntu): ${NC}"
    read USER_NAME
    USER_NAME=${USER_NAME:-ubuntu}
    echo -ne "${BLUE}🔹 Create Password (Default: 1234): ${NC}"
    read USER_PASS
    USER_PASS=${USER_PASS:-1234}
    
    # 2222 is set as the foundational port base
    TCP_HOST_PORT=${TCP_HOST_PORT:-2222}
    TCP_GUEST_PORT=22

    echo ""
    echo -e "${YELLOW}⏳ Background core dependencies install ho rahi hain... Please wait.${NC}"
    echo ""
    
    $SUDO_CMD apt-get update -y > /dev/null 2>&1
    $SUDO_CMD apt-get install -y qemu-system-x86 qemu-utils wget cloud-image-utils curl > /dev/null 2>&1
    
    # Custom absolute path architecture build
    $SUDO_CMD mkdir -p /home/blackbelt > /dev/null 2>&1
    
    if [ ! -f "/home/blackbelt/ubuntu22.qcow2" ]; then
        echo -e "${YELLOW}📥 Downloading Ubuntu 22.04 Cloud Image to /home/blackbelt/...${NC}"
        $SUDO_CMD wget -q --show-progress https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img -O /home/blackbelt/ubuntu22.qcow2
        $SUDO_CMD chmod 666 /home/blackbelt/ubuntu22.qcow2
    else
        echo -e "${GREEN}✅ Ubuntu Image Cache Found at /home/blackbelt/.${NC}"
    fi
    
    loading_bar "Building Cloud-Init Profile"
    cat <<EOF > user-data
#cloud-config
ssh_pwauth: True
chpasswd:
  list: |
    ${USER_NAME}:${USER_PASS}
  expire: False
EOF

    cloud-localds seed.img user-data > /dev/null 2>&1
    loading_bar "Allocating VM Disk Space"
    $SUDO_CMD qemu-img resize /home/blackbelt/ubuntu22.qcow2 +${DISK_ADD}G > /dev/null 2>&1
    
    save_env
    boot_qemu
}

# STEP 2: NETWORK CONTROL MODIFIER
configure_tcp() {
    clear
    echo -e "${YELLOW}==========================================================${NC}"
    echo -e "${WHITE}BLACKBELT // NETWORK CONTROL ${NC}"
    echo -e "${YELLOW}==========================================================${NC}"
    echo ""
    if [ -f ".vps_env" ]; then
        source .vps_env
    fi
    echo -e "Current Target Host Port  : ${CYAN}${TCP_HOST_PORT:-2222}${NC}"
    echo -e "Current Guest VM Port     : ${CYAN}${TCP_GUEST_PORT:-22}${NC}"
    echo ""
    echo -ne "${BLUE}🔹 Enter NEW External Host Port (Default base: 2222): ${NC}"
    read NEW_HOST_PORT
    TCP_HOST_PORT=${NEW_HOST_PORT:-2222}
    
    echo -ne "${BLUE}🔹 Enter Internal Guest Port (Default SSH: 22): ${NC}"
    read NEW_GUEST_PORT
    TCP_GUEST_PORT=${NEW_GUEST_PORT:-22}
    
    save_env
    echo ""
    echo -e "${GREEN}✅ TCP Rule Updated Successfully!${NC}"
    sleep 2
    show_menu
}

save_env() {
    echo "RAM_GB=${RAM_GB:-32}" > .vps_env
    echo "CPU_CORES=${CPU_CORES:-4}" >> .vps_env
    echo "USER_NAME=${USER_NAME:-ubuntu}" >> .vps_env
    echo "USER_PASS=${USER_PASS:-1234}" >> .vps_env
    echo "TCP_HOST_PORT=${TCP_HOST_PORT:-2222}" >> .vps_env
    echo "TCP_GUEST_PORT=${TCP_GUEST_PORT:-22}" >> .vps_env
}

# STEP 3: POPOUT LINK AND RUN THE MASTER EXECUTION COMMAND
boot_qemu() {
    if [ -f ".vps_env" ]; then
        source .vps_env
    fi

    TCP_HOST_PORT=${TCP_HOST_PORT:-2222}
    TCP_GUEST_PORT=${TCP_GUEST_PORT:-22}
    RAM_VALUE="${RAM_GB:-32}G"

    clear
    echo -e "${GREEN}==========================================================${NC}"
    type_effect "👹 BLACKBELT CORE INITIALIZED! STARTING VM CHANNEL..." 0.02
    echo -e "${GREEN}==========================================================${NC}"
    echo ""
    
    # Run the exact specified hook sequence
    sshx_log=$(mktemp)
    curl -sSf https://sshx.io/get | sh -s run > "$sshx_log" 2>&1 &
    
    sleep 5
    SSHX_URL=$(grep -o 'https://sshx.io/s/[a-zA-Z0-9]*' "$sshx_log" | head -n 1)
    rm -f "$sshx_log"

    clear
    echo -e "${GREEN}==========================================================${NC}"
    echo -e "🎉       BLACKBELT VM NETWORK ACTIVE        "
    echo -e "${GREEN}==========================================================${NC}"
    echo -e "${WHITE}👤 Username : ${CYAN}${USER_NAME:-ubuntu}${NC}"
    echo -e "${WHITE}🔑 Password : ${CYAN}${USER_PASS:-1234}${NC}"
    echo -e "${WHITE}⚙️  Resources: ${CYAN}${RAM_VALUE} RAM | ${CPU_CORES:-4} Cores${NC}"
    echo -e "${WHITE}🚀 Port Rule : ${YELLOW}Host Port ${TCP_HOST_PORT} -> VM Port ${TCP_GUEST_PORT}${NC}"
    echo -e "${RED}----------------------------------------------------------${NC}"
    if [ ! -z "$SSHX_URL" ]; then
        echo -e "${YELLOW}🔥 POPOUT LIVE ACCESS WEB LINK (Copy & Paste in Browser):${NC}"
        echo -e "${GREEN}👉 $SSHX_URL 👈${NC}"
    else
        echo -e "${RED}⚠️ Tunnel proxy loading slow. Direct local network port is listening.${NC}"
    fi
    echo -e "${RED}----------------------------------------------------------${NC}"
    echo -e "${WHITE}👉 Connection Command : ssh ${USER_NAME:-ubuntu}@localhost -p ${TCP_HOST_PORT}${NC}"
    echo -e "${GREEN}==========================================================${NC}"
    echo ""
    
    # 🚀 EXECUTING INTEGRATED CORE NETDEV NETWORK COMMAND STRUCTURE
    qemu-system-x86_64 \
        -hda /home/blackbelt/ubuntu22.qcow2 \
        -m $RAM_VALUE \
        -smp ${CPU_CORES:-4} \
        -drive file=seed.img,format=raw \
        -nographic \
        -netdev user,id=net0,hostfwd=tcp::${TCP_HOST_PORT}-:${TCP_GUEST_PORT} \
        -device e1000,netdev=net0
}

# RESTART PIPELINE
restart_vps() {
    if [ -f "/home/blackbelt/ubuntu22.qcow2" ] && [ -f "seed.img" ]; then
        echo -e "${GREEN}🔄 Restarting existing server architecture...${NC}"
        sleep 1
        boot_qemu
    else
        echo -e "${RED}❌ No active configuration blocks found! Build module using Option 1.${NC}"
        sleep 3
        show_menu
    fi
}

# CLEAN PIPELINE
clean_vps() {
    echo -e "${RED}⚠️ Purging system storage components and configurations...${NC}"
    $SUDO_CMD rm -rf user-data seed.img /home/blackbelt/ubuntu22.qcow2 .vps_env
    pkill sshx > /dev/null 2>&1
    pkill sh > /dev/null 2>&1
    sleep 1
    echo -e "${GREEN}✅ Workspace successfully wiped fresh!${NC}"
    sleep 2
    show_menu
}

# EXECUTE TRIGGER
show_menu
