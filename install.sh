#!/system/bin/sh

echo "=== FIZXY ROBLOX TOOLS ==="

CONFIG="$HOME/.fizxy_config"

if [ -f "$CONFIG" ]; then
. "$CONFIG"
echo "[✓] Config ditemukan"
else
read -p "Masukkan License Key: " KEY
read -p "Masukkan Link Private Server: " PS
read -p "Masukkan Discord Webhook (optional): " WEBHOOK

echo "KEY=\"$KEY\"" > "$CONFIG"
echo "PS=\"$PS\"" >> "$CONFIG"
echo "WEBHOOK=\"$WEBHOOK\"" >> "$CONFIG"
fi

HWID=$(cat /proc/sys/kernel/random/uuid)
URL="http://n3.panelbot.id:2400/get_script"

echo "[*] Verifikasi ke server..."

RESPONSE=$(curl -s -X POST "$URL" \
-H "Content-Type: application/json" \
-d "{\"key\":\"$KEY\",\"hwid\":\"$HWID\"}")

SCRIPT=$(echo "$RESPONSE" | sed 's/.*"script":"//;s/"}.*//' | sed 's/\\n/\n/g')

if [ -z "$SCRIPT" ]; then
echo "[X] Key tidak valid atau server error"
exit
fi

echo "[*] Mengambil script terbaru..."

SCRIPT_PATH="$HOME/script_roblox.sh"

echo "$SCRIPT" > "$SCRIPT_PATH"
chmod +x "$SCRIPT_PATH"

echo "[✓] Script terbaru siap"

# jalankan pakai path full
su -c "sh $SCRIPT_PATH \"$PS\" \"$WEBHOOK\""
