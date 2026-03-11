#!/bin/bash
# Loader Fizxy Tools v2 - Stabilized Input

URL_API="http://n3.panelbot.id:2400/verify"

clear
echo -e "\033[92m--- FIZXY TOOLS AUTO INSTALLER ---\033[0m"

# Input Data menggunakan /dev/tty agar tidak terlewati curl
printf "Masukkan License Key: "
read KEY < /dev/tty
printf "Link Private Server: "
read PS < /dev/tty
printf "Webhook Discord (Opsional): "
read WH < /dev/tty

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
    echo "$RESPONSE" | bash -s -- "$PS" "$WH"
fi
