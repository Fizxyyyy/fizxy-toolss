#!/bin/bash
# Loader Fizxy Tools v4 - User Friendly Interface

URL_API="http://n3.panelbot.id:2400/verify"

# Tampilkan Header Dulu
echo -e "\033[96m==========================================\033[0m"
echo -e "\033[92m        FIZXY TOOLS PREMIUM v1.0        \033[0m"
echo -e "\033[96m==========================================\033[0m"
echo -e "\033[93m[!] Pastikan Key lu valid dari Bot Discord\033[0m"
echo ""

# Baru paksa input di sini
exec < /dev/tty

# Input Data
read -p "🔑 Masukkan License Key: " KEY
read -p "🔗 Link Private Server : " PS
read -p "🛰️ Webhook (Enter jika tdk ada): " WH

# Ambil ID Device
HWID=$(getprop ro.serialno)

echo ""
echo -e "\033[94m[*] Sedang Memverifikasi ke Server...\033[0m"

# Verifikasi ke Panel
RESPONSE=$(curl -s -X POST -d "key=$KEY&hwid=$HWID" $URL_API)

if [[ "$RESPONSE" == "INVALID" ]]; then
    echo -e "\033[91m[X] ERROR: Key Salah atau Kadaluarsa!\033[0m"
    exit 1
elif [[ "$RESPONSE" == "LIMIT" ]]; then
    echo -e "\033[91m[X] ERROR: Slot Device Penuh (Max 5)!\033[0m"
    exit 1
elif [[ -z "$RESPONSE" ]]; then
    echo -e "\033[91m[X] ERROR: Gagal terhubung ke PanelBot.ID\033[0m"
    exit 1
else
    echo -e "\033[92m[V] BERHASIL: Lisensi Aktif!\033[0m"
    echo -e "\033[95m[*] Menjalankan Roblox Manager, mohon tunggu...\033[0m"
    sleep 2
    # Jalankan script asli dari RAM
    echo "$RESPONSE" | bash -s -- "$PS" "$WH"
fi
