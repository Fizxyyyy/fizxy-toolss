#!/bin/bash
set +o history
set +x

trap "pkill -f com.roblox.client; exit" SIGINT SIGTERM

# --- REMOTE KILL SWITCH ---
STATUS_URL="https://raw.githubusercontent.com/Fizxyyyy/fizxy-toolss/main/status.txt"
CHECK_STATUS=$(curl -sL "$STATUS_URL" | tr -d '[:space:]')

if [ "$CHECK_STATUS" = "OFF" ]; then
    echo -e "\033[91m      MAAF: MASA TRIAL SUDAH HABIS      \033[0m"
    exit 1
fi

URL_API="http://n3.panelbot.id:2400/verify"
CONFIG_FILE="$HOME/.fizxy_config"

# Load Config
if [ -f "$CONFIG_FILE" ]; then
    source "$CONFIG_FILE"
    echo -e "\033[93m[!] Data lama ditemukan.\033[0m"
    echo -n "📁 Pakai data lama? (y/n): "
    read REUSE
    if [[ "$REUSE" != "y" ]]; then rm "$CONFIG_FILE"; unset KEY PS WH; fi
fi

if [ ! -f "$CONFIG_FILE" ]; then
    echo -e "\033[1mMasukan Key:\033[0m"; echo -n " > "; read KEY
    echo -e "\033[1mMasukan Link PS Mu:\033[0m"; echo -n " > "; read PS
    echo -e "\033[1mMasukan URL Webhook (Opsional):\033[0m"; echo -n " > "; read WH
    echo "KEY='$KEY'"; echo "PS='$PS'"; echo "WH='$WH'" > "$CONFIG_FILE"
fi

HWID=$(getprop ro.serialno)
echo -e "\033[94m[*] Mengautentikasi dengan Server...\033[0m"

RAW_DATA=$(curl -sL -X POST -d "key=$KEY&hwid=$HWID" "$URL_API")

if [[ "$RAW_DATA" == "INVALID" || -z "$RAW_DATA" ]]; then
    echo -e "\033[91m[X] ERROR: Key Salah atau Server Down!\033[0m"
    exit 1
else
    echo -e "\033[92m[V] LISENSI VALID! Memuat Fitur...\033[0m"
    # SOLUSI
    eval "$(echo "$RAW_DATA")" "$PS" "$WH"
fi
