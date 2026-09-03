#!/bin/bash

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
GRAY='\033[0;90m'
NC='\033[0m'

# ==========================================
# PATHS / STATE
# ==========================================
BASE_DIR="/home/blackbelt"
IMAGE="${BASE_DIR}/ubuntu22.qcow2"
SEED="${BASE_DIR}/seed.img"
USER_DATA="${BASE_DIR}/user-data"
ENV_FILE="${BASE_DIR}/.vps_env"

# AUTOMATED ROOT/SUDO PRIVILEGE CHECK
if [ "$(id -u)" -eq 0 ]; then
    SUDO_CMD=""
else
    SUDO_CMD="sudo"
fi

load_env() {
    if [ -f "$ENV_FILE" ]; then
        source "$ENV_FILE"
    fi
}

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

valid_number() { [[ "${1:-}" =~ ^[0-9]+$ ]]; }
port_in_use() {
    local p="$1"
    if command -v ss >/dev/null 2>&1; then ss -ltnH 2>/dev/null | awk '{print $4}' | grep -Eq "[:.]${p}$"; else return 1; fi
}

# ==========================================
# VPS CONTROL PANEL MENU
# ==========================================
vps_dashboard() {
    while true; do
        clear
        echo -e "${CYAN}╭──────────────────────────────────────────────────────────╮${NC}"
        echo -e "${CYAN}│${NC} ${WHITE}BLACKBELT VPS CONTROL${NC}                  ${GREEN}● READY${NC} ${CYAN}│${NC}"
        echo -e "${CYAN}╰──────────────────────────────────────────────────────────╯${NC}"
        echo ""
        echo -e "${CYAN}●${NC} ${WHITE}SYSTEM STATUS${NC}"
        echo -e "  Host       : ${GREEN}$(hostname)${NC}"
        echo -e "  Network    : ${GREEN}● CONNECTED${NC}"
        echo -e "  VM Image   : ${GRAY}${IMAGE}${NC}"
        echo ""
        echo -e "${CYAN}──────────────────────────────────────────────────────────${NC}"
        echo ""
        echo -e "${CYAN}▣ DEPLOYMENT & SERVICES${NC}"
        echo ""
        echo -e "  ${WHITE}[1]${NC} CREATE VPS   ${GRAY}Create & boot new Ubuntu VM${NC}"
        echo -e "  ${WHITE}[2]${NC} RESTART VPS  ${GRAY}Restart existing VM${NC}"
        echo -e "  ${WHITE}[3]${NC} NETWORK      ${GRAY}TCP port forwarding${NC}"
        echo -e "  ${WHITE}[4]${NC} MAINTENANCE  ${GRAY}Cache & configuration${NC}"
        echo -e "  ${WHITE}[5]${NC} SYSTEM       ${GRAY}System information${NC}"
        echo -e "  ${WHITE}[6]${NC} NEW MODULE   ${GRAY}Reserved module${NC}"
        echo ""
        echo -e "${PURPLE}▣ TOOLS${NC}"
        echo ""
        echo -e "  ${WHITE}[7]${NC} TOOLBOX      ${GRAY}QEMU diagnostics${NC}"
        echo -e "  ${WHITE}[8]${NC} THEMES       ${GRAY}Theme information${NC}"
        echo -e "  ${WHITE}[9]${NC} EXTRAS       ${GRAY}Extra utilities${NC}"
        echo ""
        echo -e "                         ${RED}[0] BACK${NC}"
        echo ""
        echo -e "${CYAN}──────────────────────────────────────────────────────────${NC}"
        echo -ne "${CYAN}➜${NC} ${WHITE}Enter Option (0-9):${NC} "
        read -r VPS_CHOICE
        case "${VPS_CHOICE:-}" in
            1) create_vps ;;
            2) restart_vps ;;
            3) configure_tcp ;;
            4) clean_vps ;;
            5) system_info ;;
            6) echo -e "${GRAY}New module is reserved for future use.${NC}"; sleep 1 ;;
            7) toolbox ;;
            8) echo -e "${GRAY}Current theme: Neon Terminal${NC}"; sleep 1 ;;
            9) extras ;;
            0) return ;;
            *) echo -e "${RED}Invalid option.${NC}"; sleep 1 ;;
        esac
    done
}

system_info() { clear; echo -e "${CYAN}BLACKBELT // SYSTEM${NC}"; echo "Hostname: $(hostname)"; echo "Kernel: $(uname -r)"; echo "CPU: $(nproc 2>/dev/null || echo unknown)"; echo "Memory: $(free -h 2>/dev/null | awk '/^Mem:/ {print $2}' || echo unknown)"; echo ""; read -rp "Press Enter to return..."; }
toolbox() { clear; echo -e "${CYAN}BLACKBELT // TOOLBOX${NC}"; echo "QEMU: $(command -v qemu-system-x86_64 || echo not-installed)"; echo "qemu-img: $(command -v qemu-img || echo not-installed)"; echo "cloud-localds: $(command -v cloud-localds || echo not-installed)"; echo ""; read -rp "Press Enter to return..."; }
extras() { clear; echo -e "${CYAN}BLACKBELT // EXTRAS${NC}"; echo "Saved config: ${ENV_FILE}"; echo ""; read -rp "Press Enter to return..."; }

# STEP 1: CONFIGURE STORAGE & DOWNLOAD CLOUD ARCHITECTURE
create_vps() {
    clear
    echo -e "${RED}==========================================================${NC}"
    echo -e "${WHITE}BLACKBELT // VM CONFIGURATION${NC}"
    echo -e "${RED}==========================================================${NC}"
    echo ""

    echo -ne "${BLUE}🔹 Enter RAM Size in GB (e.g., 4, 8, 16, 32): ${NC}"
    read -r RAM_GB
    echo -ne "${BLUE}🔹 Enter CPU Cores (e.g., 2, 4, 8): ${NC}"
    read -r CPU_CORES
    echo -ne "${BLUE}🔹 Enter Disk Space to ADD in GB (e.g., 10, 20): ${NC}"
    read -r DISK_ADD
    echo -ne "${BLUE}🔹 Create Username (Default: ubuntu): ${NC}"
    read -r USER_NAME
    USER_NAME=${USER_NAME:-ubuntu}
    echo -ne "${BLUE}🔹 Create Password (Default: 1234): ${NC}"
    read -r USER_PASS
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
    $SUDO_CMD mkdir -p "$BASE_DIR" > /dev/null 2>&1

    if [ ! -f "$IMAGE" ]; then
        echo -e "${YELLOW}📥 Downloading Ubuntu 22.04 Cloud Image to ${BASE_DIR}/...${NC}"
        $SUDO_CMD wget -q --show-progress https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img -O "$IMAGE"
        $SUDO_CMD chmod 666 "$IMAGE"
    else
        echo -e "${GREEN}✅ Ubuntu Image Cache Found at ${BASE_DIR}/.${NC}"
    fi

    loading_bar "Building Cloud-Init Profile"
    $SUDO_CMD tee "$USER_DATA" >/dev/null <<EOF
#cloud-config
ssh_pwauth: True
chpasswd:
  list: |
    ${USER_NAME}:${USER_PASS}
  expire: False
EOF

    $SUDO_CMD cloud-localds "$SEED" "$USER_DATA" > /dev/null 2>&1
    loading_bar "Allocating VM Disk Space"
    $SUDO_CMD qemu-img resize "$IMAGE" +${DISK_ADD}G > /dev/null 2>&1

    save_env
    boot_qemu
}

# STEP 2: NETWORK CONTROL MODIFIER
configure_tcp() {
    clear
    echo -e "${YELLOW}==========================================================${NC}"
    echo -e "${WHITE}BLACKBELT // TCP PORT CONTROL ${NC}"
    echo -e "${YELLOW}==========================================================${NC}"
    echo ""
    load_env
    echo -e "Current Target Host Port  : ${CYAN}${TCP_HOST_PORT:-2222}${NC}"
    echo -e "Current Guest VM Port     : ${CYAN}${TCP_GUEST_PORT:-22}${NC}"
    echo ""
    echo -ne "${BLUE}🔹 Enter NEW External Host Port (Default base: 2222): ${NC}"
    read -r NEW_HOST_PORT
    TCP_HOST_PORT=${NEW_HOST_PORT:-2222}

    echo -ne "${BLUE}🔹 Enter Internal Guest Port (Default SSH: 22): ${NC}"
    read -r NEW_GUEST_PORT
    TCP_GUEST_PORT=${NEW_GUEST_PORT:-22}

    save_env
    echo ""
    echo -e "${GREEN}✅ TCP Rule Updated Successfully!${NC}"
    sleep 2
}

save_env() {
    $SUDO_CMD mkdir -p "$BASE_DIR"
    echo "RAM_GB=${RAM_GB:-4}" > "$ENV_FILE"
    echo "CPU_CORES=${CPU_CORES:-2}" >> "$ENV_FILE"
    echo "USER_NAME=${USER_NAME:-ubuntu}" >> "$ENV_FILE"
    echo "USER_PASS=${USER_PASS:-1234}" >> "$ENV_FILE"
    echo "TCP_HOST_PORT=${TCP_HOST_PORT:-2222}" >> "$ENV_FILE"
    echo "TCP_GUEST_PORT=${TCP_GUEST_PORT:-22}" >> "$ENV_FILE"
    $SUDO_CMD chmod 600 "$ENV_FILE" 2>/dev/null || true
}

# STEP 3: POPOUT LINK AND RUN THE MASTER EXECUTION COMMAND
boot_qemu() {
    load_env

    TCP_HOST_PORT=${TCP_HOST_PORT:-2222}
    TCP_GUEST_PORT=${TCP_GUEST_PORT:-22}
    RAM_VALUE="${RAM_GB:-4}G"

    clear
    if port_in_use "$TCP_HOST_PORT"; then
        echo -e "${RED}✗ Host port ${TCP_HOST_PORT} is already in use.${NC}"
        echo -e "${YELLOW}Use VPS → Network to choose another port.${NC}"
        sleep 2
        return
    fi
    echo -e "${GREEN}==========================================================${NC}"
    type_effect "BLACKBELT CORE INITIALIZED! STARTING VM CHANNEL..." 0.02
    echo -e "${GREEN}==========================================================${NC}"
    echo ""

    sshx_log=$(mktemp)
    curl -sSf https://sshx.io/get | sh -s run > "$sshx_log" 2>&1 &

    sleep 5
    SSHX_URL=$(grep -o 'https://sshx.io/s/[a-zA-Z0-9]*' "$sshx_log" | head -n 1)
    rm -f "$sshx_log"

    QEMU_LOG="${BASE_DIR}/qemu.log"
    qemu-system-x86_64 \
        -hda "$IMAGE" \
        -m "$RAM_VALUE" \
        -smp "${CPU_CORES:-4}" \
        -drive "file=${SEED},format=raw" \
        -nographic \
        -netdev user,id=net0,hostfwd=tcp::${TCP_HOST_PORT}-:${TCP_GUEST_PORT} \
        -device e1000,netdev=net0 >"$QEMU_LOG" 2>&1 &
    QEMU_PID=$!
    echo "$QEMU_PID" > "$BASE_DIR/qemu.pid"
    sleep 2
    if ! kill -0 "$QEMU_PID" 2>/dev/null; then
        echo -e "${RED}✗ QEMU failed to start.${NC}"
        tail -n 10 "$QEMU_LOG" 2>/dev/null
        rm -f "$BASE_DIR/qemu.pid"
        return
    fi

    clear
    echo -e "${GREEN}==========================================================${NC}"
    echo -e "🎉       BLACKBELT VM NETWORK ACTIVE"
    echo -e "${GREEN}==========================================================${NC}"
    echo -e "${WHITE}👤 Username : ${CYAN}${USER_NAME:-ubuntu}${NC}"
    echo -e "${WHITE}🔑 Password : ${CYAN}${USER_PASS:-1234}${NC}"
    echo -e "${WHITE}⚙️  Resources: ${CYAN}${RAM_VALUE} RAM | ${CPU_CORES:-4} Cores${NC}"
    echo -e "${WHITE}🚀 Port Rule : ${YELLOW}Host Port ${TCP_HOST_PORT} -> VM Port ${TCP_GUEST_PORT}${NC}"
    echo -e "${GREEN}----------------------------------------------------------${NC}"
    if [ -n "$SSHX_URL" ]; then
        echo -e "${YELLOW}🔥 POPOUT LIVE ACCESS WEB LINK:${NC}"
        echo -e "${GREEN}$SSHX_URL${NC}"
    else
        echo -e "${GRAY}SSHX link unavailable. Direct TCP forwarding is active.${NC}"
    fi
    echo -e "${GREEN}----------------------------------------------------------${NC}"
    echo -e "${WHITE}👉 Connection Command : ssh ${USER_NAME:-ubuntu}@localhost -p ${TCP_HOST_PORT}${NC}"
    echo -e "${GREEN}==========================================================${NC}"
    echo ""
    echo -e "${GRAY}QEMU PID: ${QEMU_PID}${NC}"
    read -rp "Press Enter to return to VPS dashboard..."
}

# RESTART PIPELINE
restart_vps() {
    load_env
    if [ -f "$IMAGE" ] && [ -f "$SEED" ]; then
        if [ -f "$BASE_DIR/qemu.pid" ]; then
            OLD_PID=$(cat "$BASE_DIR/qemu.pid" 2>/dev/null || true)
            if [ -n "${OLD_PID:-}" ] && kill -0 "$OLD_PID" 2>/dev/null; then
                echo -e "${YELLOW}Stopping current VPS (PID $OLD_PID)...${NC}"
                kill "$OLD_PID" 2>/dev/null || true
                sleep 2
            fi
            rm -f "$BASE_DIR/qemu.pid"
        fi
        echo -e "${GREEN}🔄 Restarting existing server architecture...${NC}"
        sleep 1
        boot_qemu
    else
        echo -e "${RED}❌ No saved VPS configuration found. Build the VPS using CREATE VPS.${NC}"
        sleep 2
    fi
}

# CLEAN PIPELINE
clean_vps() {
    echo -e "${RED}⚠️ Purging system storage components and configurations...${NC}"
    $SUDO_CMD rm -f "$USER_DATA" "$SEED" "$IMAGE" "$ENV_FILE"
    sleep 1
    echo -e "${GREEN}✅ Workspace successfully wiped fresh!${NC}"
    sleep 2
}

# Only auto-launch the panel when this file is EXECUTED directly
# (e.g. `bash install.sh`). When it's sourced by vps-dashboard.sh,
# it just loads the functions and stays quiet.
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    clear
    vps_dashboard
fi
