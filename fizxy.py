import os, requests, json, uuid

# File buat nyimpen data login pembeli di Termux
CONFIG_FILE = "config.json"

def load_config():
    if os.path.exists(CONFIG_FILE):
        with open(CONFIG_FILE, "r") as f:
            try: return json.load(f)
            except: return {}
    return {}

def save_config(key, ps_link, webhook):
    with open(CONFIG_FILE, "w") as f:
        json.dump({"key": key, "ps_link": ps_link, "webhook": webhook}, f)

# 1. Persiapan
print("\033[93m[*] Menyiapkan Lingkungan...\033[0m")
try:
    import requests
except ImportError:
    os.system("pip install requests")

# 2. Ambil Data
config = load_config()
print("\n\033[92m--- FIZXY TOOLS AUTO INSTALLER ---\033[0m")

if config.get("key") and config.get("ps_link"):
    print("\033[94m[*] Data tersimpan ditemukan. Gunakan data lama? (Y/n)\033[0m")
    pilihan = input(">> ").lower()
    if pilihan == 'n':
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

# 3. HWID & Panel URL
HWID = str(uuid.getnode())
URL_GET = "http://n3.panelbot.id:2400/get_script"

try:
    print("[*] Verifikasi ke Server...")
    r = requests.post(URL_GET, json={"key": KEY, "hwid": HWID})
    
    if r.status_code == 200:
        # Berhasil! Simpan data
        save_config(KEY, PS_LINK, WEBHOOK)
        
        script_content = r.json()['script']
        home_path = "/data/data/com.termux/files/home/"
        
        # Simpan script dari panel ke run.sh
        with open(f"{home_path}run.sh", "w") as f:
            f.write(script_content)
            
        print("\033[92m[V] Akses Diterima! Menjalankan Roblox Manager...\033[0m")
        os.system(f"chmod +x {home_path}run.sh")
        
        # EKSEKUSI: Kirim Link PS ($1) dan Webhook ($2) ke run.sh
        os.system(f"su -c 'sh {home_path}run.sh \"{PS_LINK}\" \"{WEBHOOK}\"'")       
        
    else:
        if os.path.exists(CONFIG_FILE): os.remove(CONFIG_FILE)
        print("\033[91m[X] Akses Ditolak! Key salah atau limit device penuh.\033[0m")
except Exception as e:
    print(f"\033[91m[!] Error: Gagal konek ke panel. Pastikan panel nyala.\033[0m")
