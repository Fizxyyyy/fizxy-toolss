#!/bin/bash
# Loader Fizxy Tools v3 - Force Input Mode

# Memaksa input dari terminal HP (Penting buat Redfinger)
exec < /dev/tty

URL_API="http://n3.panelbot.id:2400/verify"

clear
echo -e "\033[92m--- FIZXY TOOLS AUTO INSTALLER ---\033[0m"
echo -e "\033[90mFollow: fizxy_tools\033[0m"
echo ""

# Input Data
read -p "Masukkan License Key: " KEY
read -p "Link Private Server: " PS
read -p "Webhook Discord (Opsional): " WH

# Ambil ID Device
HWID=$(getprop ro.serialno)

echo ""
echo -e "\033[93m[*] Menghubungkan ke Server...\033[0m"

# Verifikasi ke Panel
RESPONSE=$(curl -s -X POST -d "key=$KEY&hwid=$HWID" $URL_API)

if [[ "$RESPONSE" == "INVALID" ]]; then
    echo -e "\033[91m[X] Key Salah! Silakan cek lagi di Bot Discord.\033[0m"
    exit 1
elif [[ "$RESPONSE" == "LIMIT" ]]; then
    echo -e "\033[91m[X] Slot Device Penuh! Maksimal 5 Redfinger.\033[0m"
    exit 1
elif [[ -z "$RESPONSE" ]]; then
    echo -e "\033[91m[X] Server Panel sedang Offline atau Maintenance.\033[0m"
    exit 1
else
    echo -e "\033[92m[V] License Terverifikasi!\033[0m"
    echo -e "\033[92m[*] Menjalankan Script Manager...\033[0m"
    sleep 2
    # Eksekusi script asli lu dari panel
    echo "$RESPONSE" | bash -s -- "$PS" "$WH"
fi
