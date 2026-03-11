#!/bin/bash
# Loader Fizxy Tools v2

URL_API="http://n3.panelbot.id:2400/verify"

clear
echo -e "\033[92m--- FIZXY TOOLS AUTO INSTALLER ---\033[0m"

# Input Data
read -p "Masukkan License Key: " KEY
read -p "Link Private Server: " PS
read -p "Webhook Discord (Opsional): " WH

# Ambil ID Device
HWID=$(getprop ro.serialno)

echo -e "\033[93m[*] Verifikasi License...\033[0m"

# Cek ke Panel
RESPONSE=$(curl -s -X POST -d "key=$KEY&hwid=$HWID" $URL_API)

if [[ "$RESPONSE" == "INVALID" ]]; then
    echo -e "\033[91m[X] Key Salah!\033[0m"
elif [[ "$RESPONSE" == "LIMIT" ]]; then
    echo -e "\033[91m[X] Slot Redfinger Penuh (Max 5)!\033[0m"
else
    echo -e "\033[92m[V] Berhasil! Menjalankan Roblox Manager...\033[0m"
    # Jalankan script roblox dari panel ke bash, kirim PS dan WH sebagai argumen
    echo "$RESPONSE" | bash -s -- "$PS" "$WH"
fi
