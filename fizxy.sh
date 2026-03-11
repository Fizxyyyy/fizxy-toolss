#!/bin/bash
# Loader Fizxy Tools v5 - Final Stable

URL_API="http://n3.panelbot.id:2400/verify"

# HEADER (Tanpa Clear)
echo -e "\033[96m==========================================\033[0m"
echo -e "\033[92m        FIZXY TOOLS PREMIUM v1.0        \033[0m"
echo -e "\033[96m==========================================\033[0m"
echo ""

# INPUT DATA SATU PER SATU
echo -n "🔑 Masukkan License Key: "
read KEY
echo -n "🔗 Link Private Server : "
read PS
echo -n "🛰️ Webhook (Opsional)  : "
read WH

# AMBIL HWID
HWID=$(getprop ro.serialno)

echo ""
echo -e "\033[94m[*] Menghubungkan ke Server...\033[0m"

# KIRIM KE PANEL
RESPONSE=$(curl -s -X POST -d "key=$KEY&hwid=$HWID" $URL_API)

if [[ "$RESPONSE" == "INVALID" ]]; then
    echo -e "\033[91m[X] ERROR: Key Salah!\033[0m"
    exit 1
elif [[ "$RESPONSE" == "LIMIT" ]]; then
    echo -e "\033[91m[X] ERROR: Slot Device Penuh!\033[0m"
    exit 1
elif [[ -z "$RESPONSE" ]]; then
    echo -e "\033[91m[X] ERROR: Server Tidak Merespon!\033[0m"
    exit 1
else
    echo -e "\033[92m[V] BERHASIL: Lisensi Aktif!\033[0m"
    echo -e "\033[95m[*] Menjalankan Manager...\033[0m"
    sleep 2
    # Eksekusi Script
    echo "$RESPONSE" | bash -s -- "$PS" "$WH"
fi
