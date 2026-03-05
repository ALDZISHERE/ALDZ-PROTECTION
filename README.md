# ALDZ PROTECTION VPS v1.0
**Package Keamanan Komprehensif untuk VPS Owner Panel & Bot**

## 🚀 FITUR UTAMA
- ✅ **Anti Deface** - Monitoring integritas file real-time dengan auto-restore
- ✅ **Verifikasi 4 Langkah** - SSH Key + Google Authenticator + Port Knocking + IP Whitelist
- ✅ **Anti Bypass** - Firewall stateful dengan konfigurasi ketat
- ✅ **Anti Hijack & Injection** - Deteksi dan blokir upaya injeksi kode
- ✅ **Anti Botnet** - Blokir koneksi ke C2 server yang dikenal
- ✅ **Anti Ubah Password** - Kunci file `/etc/shadow` dan `/etc/passwd`
- ✅ **Panel & Bot Friendly** - Tidak mengganggu operasional panel

## 📋 PERSYARATAN
- Ubuntu 20.04 / 22.04 LTS
- RAM 1GB+ (Rekomendasi 2GB)
- Akses Root

## ⚡ INSTALASI CEPAT
```bash
# 1. Upload folder ini ke /root/
# 2. Beri izin execute
chmod +x /root/ALDZ-PROTECTION-VPS/install.sh
chmod +x /root/ALDZ-PROTECTION-VPS/scripts/*.sh
chmod +x /root/ALDZ-PROTECTION-VPS/tools/*

# 3. Jalankan instalasi
cd /root/ALDZ-PROTECTION-VPS
./install.sh