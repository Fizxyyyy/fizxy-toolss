#!/bin/bash
# Loader Fizxy Tools v7.2 - Ultra Secure Edition
# Proteksi: Memory-Only Execution & Anti-Trace

# Matikan history & debugging agar kode tidak terintip
set +o history
set +x

# Auto Kill proses pas exit
trap "pkill -f com.roblox.client; exit" SIGINT SIGTERM

# --- REMOTE KILL SWITCH ---
STATUS_URL="https://raw.githubusercontent.com/Fizxyyyy/fizxy-toolss/main/status.txt"
CHECK_STATUS=$(curl -sL "$STATUS_URL" | tr -d '[:space:]')

if [ "$CHECK_STATUS" = "OFF" ]; then
    echo -e "\033[91m==========================================\033[0m"
    echo -e "\033[91m      MAAF: MASA TRIAL SUDAH HABIS      \033[0m"
    echo -e "\033[91m==========================================\033[0m"
    echo -e "\033[93mHubungi Fizxy untuk membeli lisensi resmi.\033[0m"
    exit 1
fi

URL_API="http://n3.panelbot.id:2400/verify"
CONFIG_FILE="$HOME/.fizxy_config"

# Warna
GREY='\033[90m'
BOLD='\033[1m'
GREEN='\033[92m'
BLUE='\033[94m'
YELLOW='\033[93m'
RED='\033[91m'
NC='\033[0m' 

clear
echo -e "${GREY}${BOLD}"
echo "  ███████╗██╗███████╗██╗  ██╗██╗   ██╗"
echo "  ██╔════╝██║╚══███╔╝╚██╗██╔╝╚██╗ ██╔╝"
echo "  █████╗  ██║  ███╔╝  ╚███╔╝  ╚████╔╝ "
echo "  ██╔══╝  ██║ ███╔╝   ██╔██╗   ╚██╔╝  "
echo "  ██║     ██║███████╗██╔╝ ██╗   ██║   "
echo "  ╚═╝     ╚═╝╚══════╝╚═╝  ╚═╝   ╚═╝   "
echo -e "${NC}"
echo -e "${BOLD}         TOOLS PREMIUM (SECURED)        ${NC}"
echo -e "${GREY}------------------------------------------${NC}"

# Fungsi Load Config
if [ -f "$CONFIG_FILE" ]; then
    source "$CONFIG_FILE"
    echo -e "${YELLOW}[!] Data lama ditemukan.${NC}"
    echo -e " 🔑 Key: ${GREY}${KEY:0:5}*****${NC}"
    echo ""
    echo -n "📁 Pakai data yang sebelumnya? (y/n): "
    read REUSE
    if [[ "$REUSE" != "y" ]]; then
        rm "$CONFIG_FILE"
        unset KEY PS WH
    fi
fi

if [ ! -f "$CONFIG_FILE" ]; then
    echo -e "${BOLD}Masukan Key:${NC}"; echo -n " > "; read KEY
    echo -e "${BOLD}Masukan Link PS Mu:${NC}"; echo -n " > "; read PS
    echo -e "${BOLD}Masukan URL Webhook (Opsional):${NC}"; echo -n " > "; read WH
    echo "KEY='$KEY'"; echo "PS='$PS'"; echo "WH='$WH'" > "$CONFIG_FILE"
fi

HWID=$(getprop ro.serialno)
echo -e "${BLUE}[*] Mengautentikasi dengan Server...${NC}"

# Ambil data ke variabel, jangan ke file!
RAW_DATA=$(curl -sL -X POST -d "key=$KEY&hwid=$HWID" "$URL_API")

if [[ "$RAW_DATA" == "INVALID" ]]; then
    echo -e "${RED}[X] ERROR: Key Salah atau Kadaluarsa!${NC}"
    rm -f "$CONFIG_FILE"
    exit 1
elif [[ "$RAW_DATA" == "LIMIT" ]]; then
    echo -e "${RED}[X] ERROR: Slot Device Penuh! (Max 5)${NC}"
    exit 1
elif [[ -z "$RAW_DATA" ]]; then
    echo -e "${RED}[X] ERROR: Server Tidak Merespon!${NC}"
    exit 1
else
    echo -e "${GREEN}[V] LISENSI VALID! Memuat Fitur...${NC}"
    sleep 1
    
    # EKSEKUSI AMAN: Langsung lempar ke bash tanpa simpan ke disk
    # Variabel dihapus segera setelah dijalankan
    ( 
      export PS WH
      echo "$RAW_DATA" | bash 
    )
    
    # Hapus jejak dari memori loader
    unset RAW_DATA
    unset KEY
    clear
fi
