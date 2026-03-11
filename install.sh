#!/system/bin/sh

echo "=== FIZXY ROBLOX TOOLS ==="

read -p "Masukkan License Key: " KEY
read -p "Masukkan Link Private Server: " PS
read -p "Masukkan Discord Webhook (optional): " WEBHOOK

HWID=$(cat /proc/sys/kernel/random/uuid)

URL="http://n3.panelbot.id:2400/get_script"

echo "[*] Verifikasi ke server..."

RESPONSE=$(curl -s -X POST $URL \
-H "Content-Type: application/json" \
-d "{\"key\":\"$KEY\",\"hwid\":\"$HWID\"}")

SCRIPT=$(echo "$RESPONSE" | sed -n 's/.*"script":"\(.*\)".*/\1/p' | sed 's/\\n/\n/g')

if [ -z "$SCRIPT" ]; then
echo "[X] Key tidak valid atau server error"
exit
fi

echo "$SCRIPT" > run.sh
chmod +x run.sh

echo "[✓] Akses diterima, menjalankan script..."

su -c "sh run.sh \"$PS\" \"$WEBHOOK\""
