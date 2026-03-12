#!/bin/bash
# Loader Fizxy Tools v7 - Premium Aesthetic UI

# Auto Kill proses pas exit
trap "pkill -f com.roblox.client; exit" SIGINT SIGTERM

# --- REMOTE KILL SWITCH ---
STATUS_URL="https://raw.githubusercontent.com/Fizxyyyy/fizxy-toolss/main/status.txt"
CHECK_STATUS=$(curl -s "$STATUS_URL")

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
NC='\033[0m' # No Color

clear
# ASCII Art FIZXY - Font Tebal Abu-abu
echo -e "${GREY}${BOLD}"
echo "  ███████╗██╗███████╗██╗  ██╗██╗   ██╗"
echo "  ██╔════╝██║╚══███╔╝╚██╗██╔╝╚██╗ ██╔╝"
echo "  █████╗  ██║  ███╔╝  ╚███╔╝  ╚████╔╝ "
echo "  ██╔══╝  ██║ ███╔╝   ██╔██╗   ╚██╔╝  "
echo "  ██║     ██║███████╗██╔╝ ██╗   ██║   "
echo "  ╚═╝     ╚═╝╚══════╝╚═╝  ╚═╝   ╚═╝   "
echo -e "${NC}"
echo -e "${BOLD}         TOOLS PREMIUM          ${NC}"
echo -e "${GREY}------------------------------------------${NC}"

# Fungsi Load Config
if [ -f "$CONFIG_FILE" ]; then
    source "$CONFIG_FILE"
    echo -e "${YELLOW}[!] Data lama ditemukan.${NC}"
    echo -e " 🔑 Key: ${GREY}$KEY${NC}"
    echo ""
    echo -n "📁 Pakai data yang sebelumnya? (y/n): "
    read REUSE
    if [[ "$REUSE" != "y" ]]; then
        rm "$CONFIG_FILE"
    fi
fi

# Input Data jika file config tidak ada
if [ ! -f "$CONFIG_FILE" ]; then
    echo -e "${BOLD}Masukan Key:${NC}"
    echo -n " > "
    read KEY
    
    echo -e "${BOLD}Masukan Link PS Mu:${NC}"
    echo -n " > "
    read PS
    
    echo -e "${BOLD}Masukan URL Webhook (Opsional boleh di pakai boleh engga) :${NC}"
    echo -n " > "
    read WH
    
    # Simpan ke file config
    echo "KEY='$KEY'" > "$CONFIG_FILE"
    echo "PS='$PS'" >> "$CONFIG_FILE"
    echo "WH='$WH'" >> "$CONFIG_FILE"
fi

# AMBIL HWID
HWID=$(getprop ro.serialno)

echo ""
echo -e "${BLUE}[*] Menghubungkan ke Server...${NC}"

# KIRIM KE PANEL
RESPONSE=$(curl -s -X POST -d "key=$KEY&hwid=$HWID" $URL_API)

if [[ "$RESPONSE" == "INVALID" ]]; then
    echo -e "${RED}[X] ERROR: Key Salah!${NC}"
    rm "$CONFIG_FILE"
    exit 1
elif [[ "$RESPONSE" == "LIMIT" ]]; then
    echo -e "${RED}[X] ERROR: Slot Device Penuh!${NC}"
    exit 1
else
    echo -e "${GREEN}[V] BERHASIL: Lisensi Aktif!${NC}"
    echo -e "${GREY}[*] Menjalankan Manager... (CTRL+C untuk berhenti)${NC}"
    sleep 2
    # Eksekusi Script Asli
    echo "$RESPONSE" | bash -s -- "$PS" "$WH"
fi
