import os, requests, json, uuid

# File buat nyimpen data login pembeli di Termux mereka
CONFIG_FILE = "config.json"

def load_config():
    if os.path.exists(CONFIG_FILE):
        with open(CONFIG_FILE, "r") as f:
            return json.load(f)
    return {}

def save_config(key, ps_link):
    with open(CONFIG_FILE, "w") as f:
        json.dump({"key": key, "ps_link": ps_link}, f)

# 1. Persiapan Lingkungan
print("\033[93m[*] Menyiapkan Lingkungan...\033[0m")
# Cek apakah requests sudah ada, kalau belum baru install biar cepet
try:
    import requests
except ImportError:
    os.system("pip install requests")

# 2. Cek Data Lama
config = load_config()
print("\n\033[92m--- FIZXY TOOLS AUTO INSTALLER ---\033[0m")

if config.get("key") and config.get("ps_link"):
    print("\033[94m[*] Menggunakan data login yang tersimpan...\033[0m")
    KEY = config["key"]
    PS_LINK = config["ps_link"]
else:
    KEY = input("Masukkan License Key: ")
    PS_LINK = input("Masukkan Link Private Server Lu: ")

# 3. Ambil HWID
def get_hwid():
    try:
        return str(uuid.getnode())
    except:
        return "UNKNOWN_DEVICE"

HWID = get_hwid()
URL_GET = "http://n3.panelbot.id:2400/get_script"

try:
    print("[*] Verifikasi ke Server...")
    r = requests.post(URL_GET, json={"key": KEY, "hwid": HWID})
    
    if r.status_code == 200:
        # BERHASIL! Simpan data biar besok gak nanya lagi
        save_config(KEY, PS_LINK)
        
        script_content = r.json()['script']
        home_path = "/data/data/com.termux/files/home/"
        
        with open(f"{home_path}run.sh", "w") as f:
            f.write(script_content)
            
        print("\033[92m[V] Akses Diterima! Menjalankan Roblox Manager...\033[0m")
        os.system(f"chmod +x {home_path}run.sh")
        
        # Eksekusi pake cara sakti lu
        os.system(f"su -c 'sh {home_path}run.sh \"{PS_LINK}\"'")       
        
    else:
        # Kalau gagal, mungkin key dihapus owner, hapus config biar dia bisa input ulang
        if os.path.exists(CONFIG_FILE):
            os.remove(CONFIG_FILE)
        print("\033[91m[X] Akses Ditolak! Key salah atau limit device penuh.\033[0m")
except Exception as e:
    print(f"\033[91m[!] Error: Gagal konek ke panel. Pastikan panel nyala.\033[0m")
