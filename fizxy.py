import os
import json
import uuid
import urllib.request
import urllib.error

CONFIG_FILE = "config.json"

def load_config():
    if os.path.exists(CONFIG_FILE):
        try:
            with open(CONFIG_FILE, "r") as f:
                return json.load(f)
        except:
            return {}
    return {}

def save_config(key, ps_link, webhook):
    with open(CONFIG_FILE, "w") as f:
        json.dump({
            "key": key,
            "ps_link": ps_link,
            "webhook": webhook
        }, f)

print("\033[93m[*] Menyiapkan Lingkungan...\033[0m")

config = load_config()

print("\n\033[92m--- FIZXY TOOLS AUTO INSTALLER ---\033[0m")

if config.get("key") and config.get("ps_link"):
    print("\033[94m[*] Data tersimpan ditemukan. Gunakan data lama? (Y/n)\033[0m")
    pilihan = input(">> ").lower()

    if pilihan == "n":
        KEY = input("Masukkan License Key Baru: ")
        PS_LINK = input("Masukkan Link Private Server Baru: ")
        WEBHOOK = input("Masukkan Discord Webhook Baru (Kosongkan jika tidak pakai): ")
    else:
        KEY = config["key"]
        PS_LINK = config["ps_link"]
        WEBHOOK = config.get("webhook", "")
else:
    KEY = input("Masukkan License Key: ")
    PS_LINK = input("Masukkan Link Private Server Lu: ")
    WEBHOOK = input("Masukkan Discord Webhook (Kosongkan jika tidak pakai): ")

HWID = str(uuid.getnode())
URL_GET = "http://n3.panelbot.id:2400/get_script"

try:
    print("[*] Verifikasi ke Server...")

    payload = json.dumps({
        "key": KEY,
        "hwid": HWID
    }).encode("utf-8")

    req = urllib.request.Request(
        URL_GET,
        data=payload,
        headers={"Content-Type": "application/json"}
    )

    response = urllib.request.urlopen(req)

    if response.status == 200:

        save_config(KEY, PS_LINK, WEBHOOK)

        result = json.loads(response.read().decode("utf-8"))
        script_content = result["script"]

        home_path = "/data/data/com.termux/files/home/"
        run_file = f"{home_path}run.sh"

        if os.path.exists(run_file):
            os.remove(run_file)

        with open(run_file, "w") as f:
            f.write(script_content)

        print("\033[92m[V] Akses Diterima! Menjalankan Roblox Manager...\033[0m")

        os.system(f"chmod +x {run_file}")
        os.system(f"su -c 'sh {run_file} \"{PS_LINK}\" \"{WEBHOOK}\"'")

    else:
        if os.path.exists(CONFIG_FILE):
            os.remove(CONFIG_FILE)

        print("\033[91m[X] Akses Ditolak! Key salah atau limit device penuh.\033[0m")

except urllib.error.URLError:
    print("\033[91m[!] Error: Gagal konek ke panel. Pastikan panel nyala.\033[0m")
