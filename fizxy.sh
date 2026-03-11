#!/bin/bash
# Loader Fizxy Tools v6 - Auto Save & Stable

# --- FITUR TAMBAHAN: AUTO KILL PROSES PAS EXIT ---
trap "pkill -f com.roblox.client; exit" SIGINT SIGTERM

URL_API="http://n3.panelbot.id:2400/verify"
CONFIG_FILE="$HOME/.fizxy_config"

# Header
echo -e "\033[96m==========================================\033[0m"
echo -e "\033[92m        FIZXY TOOLS PREMIUM v1.0        \033[0m"
echo -e "\033[96m==========================================\033[0m"

# Fungsi Load Config
if [ -f "$CONFIG_FILE" ]; then
    source "$CONFIG_FILE"
    echo -e "\033[93m[!] Data lama ditemukan.\033[0m"
    echo -e " Key: \033[97m$KEY\033[0m"
    echo -e " Monitoring: \033[92mActive\033[0m"
    echo ""
    read -p "📁 Pakai data yang sebelumnya? (y/n): " REUSE
    if [[ "$REUSE" != "y" ]]; then
        rm "$CONFIG_FILE"
    fi
fi

# Input Data jika file config tidak ada
if [ ! -f "$CONFIG_FILE" ]; then
    echo -n " Masukkan License Key: "
    read KEY
    echo -n " Link Private Server : "
    read PS
    echo -n " Webhook Monitoring  : "
    read WH
    # Simpan ke file config
    echo "KEY='$KEY'" > "$CONFIG_FILE"
    echo "PS='$PS'" >> "$CONFIG_FILE"
    echo "WH='$WH'" >> "$CONFIG_FILE"
fi

# AMBIL HWID
HWID=$(getprop ro.serialno)

echo -e "\033[94m[*] Menghubungkan ke Server...\033[0m"

# KIRIM KE PANEL
RESPONSE=$(curl -s -X POST -d "key=$KEY&hwid=$HWID" $URL_API)

if [[ "$RESPONSE" == "INVALID" ]]; then
    echo -e "\033[91m[X] ERROR: Key Salah!\033[0m"
    rm "$CONFIG_FILE" # Hapus config kalau key salah
    exit 1
elif [[ "$RESPONSE" == "LIMIT" ]]; then
    echo -e "\033[91m[X] ERROR: Slot Device Penuh!\033[0m"
    exit 1
else
    echo -e "\033[92m[V] BERHASIL: Lisensi Aktif!\033[0m"
    echo -e "\033[95m[*] Menjalankan Manager... (Tekan CTRL+C buat Berhenti)\033[0m"
    
    # Eksekusi Script Asli Lu dengan argumen
    echo "$RESPONSE" | bash -s -- "$PS" "$WH"
fi
