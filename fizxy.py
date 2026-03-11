import os, requests, subprocess, sys

# 1. Install bahan otomatis
print("\033[93m[*] Menyiapkan Bahan (tsu & requests)...\033[0m")
os.system("pkg update -y && pkg install tsu -y && pip install requests")

print("\n\033[92m--- FIZXY TOOLS AUTO INSTALLER ---\033[0m")
KEY = input("Masukkan License Key: ")
PS_LINK = input("Masukkan Link Private Server Lu: ")

# 2. Ambil ID Cloud (HWID)
def get_hwid():
    try:
        # Pake cara ini lebih aman buat Termux (Gak butuh izin secure settings)
        import uuid
        return str(uuid.getnode())
    except:
        return "UNKNOWN_DEVICE"

HWID = get_hwid()
# Alamat panel lu (Sesuai screenshot n3:2400)
URL_GET = "http://n3.panelbot.id:2400/get_script"

try:
    print("[*] Verifikasi ke Server...")
    # Tarik script langsung dari panel lu
    r = requests.post(URL_GET, json={"key": KEY, "hwid": HWID})
    
    if r.status_code == 200:
        script_content = r.json()['script']
        
        # Simpan sementara di termux pembeli
        with open("run.sh", "w") as f:
            f.write(script_content)
            
        print("\033[92m[V] Akses Diterima! Menjalankan Roblox Manager...\033[0m")
        # Jalanin script bash lu dengan Link PS sebagai input ($1)
                # Cara panggil tsu yang bener buat jalanin script
        os.system(f"tsu -c 'sh run.sh {PS_LINK}'") 
    else:
        print("\033[91m[X] Akses Ditolak! Key salah atau limit device penuh.\033[0m")
except Exception as e:
    print(f"\033[91m[!] Error: Gagal konek ke panel. Pastikan panel nyala.\033[0m")
  
