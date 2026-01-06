```markdown
# 🚀 cPanel Auto Account Creator

![HTML5](https://img.shields.io/badge/HTML5-E34F26?style=for-the-badge&logo=html5&logoColor=white)
![JavaScript](https://img.shields.io/badge/JavaScript-F7DF1E?style=for-the-badge&logo=javascript&logoColor=black)
![WHM](https://img.shields.io/badge/WHM-FF6C37?style=for-the-badge&logo=cpanel&logoColor=white)
![LocalStorage](https://img.shields.io/badge/LocalStorage-0088CC?style=for-the-badge)

Aplikasi web single-file untuk membuat akun cPanel otomatis melalui WHM API dengan sistem login dan penyimpanan history permanen.

## ✨ Fitur Utama

### 🔐 **Keamanan & Autentikasi**
- ✅ Sistem login dengan password protection
- ✅ Hash password untuk keamanan
- ✅ Session management
- ✅ Log aktivitas user
- ✅ Ganti password & username

### 🚀 **Pembuatan Akun cPanel**
- ✅ Auto create account via WHM API
- ✅ Multiple package templates (Starter, Professional, Business)
- ✅ Validasi input real-time
- ✅ Password strength indicator
- ✅ Test connection WHM

### 📊 **Dashboard & Monitoring**
- ✅ Statistik real-time (total, success, failed accounts)
- ✅ Recent activity timeline
- ✅ Storage usage monitor
- ✅ Last login tracking

### 💾 **Penyimpanan Data**
- ✅ **History permanen** di localStorage
- ✅ Tidak hilang meski browser ditutup
- ✅ Export data ke JSON
- ✅ Auto-save setiap 5 menit

## 📸 Screenshots

### Login Screen
```

🔐 cPanel Auto Creator Username:[admin] Password:[••••••••]
[Login]

```

### Dashboard
```

📊 Dashboard Total:12 | Success: 10 | Failed: 2 | Last: 2 jam lalu Recent Activity: ✅example.com - user123 - 5 menit lalu

```

## 🛠️ Instalasi

### **Persyaratan**
1. **WHM/cPanel Server** dengan akses root
2. **API Token** dari WHM
3. **Browser modern** (Chrome/Firefox/Edge)
4. **Koneksi internet** ke server WHM

### **Langkah 1: Generate API Token**
1. Login ke WHM sebagai root
2. Buka **Development** → **Manage API Tokens**
3. Klik **Generate Token**
4. Beri nama: `AutoCreateAPI`
5. Set permissions:
   - `createacct` (Create Account)
   - `listaccts` (List Accounts)
   - `accountsummary` (Account Summary)
6. Copy token yang dihasilkan

### **Langkah 2: Konfigurasi File**
1. **Download** file HTML
2. **Buka file** dengan text editor
3. **Ubah konfigurasi default** (opsional):
   ```javascript
   // Line ~50
   whmUrl: 'https://server-anda.com:2087',
   whmUser: 'root',
   whmToken: 'API_TOKEN_ANDA',
```

Langkah 3: Menjalankan Aplikasi

1. Simpan file sebagai cpanel-auto.html
2. Buka file di browser:
   · Chrome: Ctrl + O → pilih file
   · Firefox: Ctrl + O → pilih file
   · Edge: Ctrl + O → pilih file
3. Login dengan:
   · Username: admin
   · Password: admin123
4. Ubah password di tab Settings (wajib)

📖 Panduan Penggunaan

1. Konfigurasi WHM

```
Tab: ⚙️ WHM Config
1. Isi WHM Server URL: https://serveranda.com:2087
2. Isi WHM Username: root
3. Tempel API Token dari WHM
4. Klik [Test Connection] untuk verifikasi
5. Klik [Save WHM Config]
```

2. Buat Akun Baru

```
Tab: ➕ Buat Account
1. Domain: example.com
2. Username: user123 (max 8 karakter)
3. Password: Password123!
4. Email: admin@example.com
5. Pilih Package: Starter
6. Klik [🚀 Buat Account]
```

3. Lihat History

```
Tab: 📋 History
- Tampilkan semua akun yang dibuat
- Filter by status (success/failed)
- View detail API response
- Export ke JSON
```

4. Pengaturan Aplikasi

```
Tab: 🔧 Settings
- Ganti password default
- Ganti username
- Set auto-save interval
- Export semua data
- Reset aplikasi
```

🔧 Konfigurasi Package

Default Packages (JSON Format)

```json
{
  "starter": {
    "disk": "1024",
    "bw": "10240",
    "maxftp": 10,
    "maxsql": 10
  },
  "professional": {
    "disk": "5120",
    "bw": "51200",
    "maxftp": 20,
    "maxsql": 20
  },
  "business": {
    "disk": "10240",
    "bw": "102400",
    "maxftp": 30,
    "maxsql": 30
  }
}
```

📁 Struktur Data

LocalStorage Keys

```javascript
cpanel_user_data       // User credentials
cpanel_whm_config      // WHM configuration
cpanel_history         // Account creation history
cpanel_app_settings    // Application settings
cpanel_login_history   // Login history (50 terakhir)
```

Data yang Tersimpan

· ✅ User login info (hashed)
· ✅ WHM API credentials
· ✅ Semua history pembuatan akun
· ✅ Settings aplikasi
· ✅ Login history

🚨 Troubleshooting

Error: "Connection Failed"

```
✅ Cek: WHM Server URL (port 2087)
✅ Cek: API Token masih valid
✅ Cek: Firewall allow port 2087
✅ Cek: WHM → Manage API Tokens → Token aktif
```

Error: "Invalid Credentials"

```
✅ Cek: Username & password default
✅ Cek: User sudah dibuat di Settings
✅ Cek: localStorage tidak terblokir
```

Error: "API Token Exposed"

```
⚠️ PERINGATAN: File ini mengekspos API Token di client-side
✅ Hanya untuk penggunaan internal/testing
✅ Jangan deploy ke public server
✅ Gunakan di localhost/network internal
```

📝 Catatan Penting

⚠️ Keamanan

· Hanya untuk testing/internal use
· API Token terekspos di JavaScript
· Jangan deploy ke production
· Gunakan di lingkungan yang aman

💾 Penyimpanan Data

· Data tersimpan di browser localStorage
· Clear browser data = hilang semua history
· Backup data dengan export ke JSON
· Auto-save setiap 5 menit

🌐 Network Requirements

· Browser bisa akses WHM server (port 2087)
· CORS enabled di server WHM
· HTTPS untuk koneksi aman

🔄 Update & Maintenance

Backup Data

1. Buka tab Settings
2. Klik Export All Data
3. Simpan file JSON di lokasi aman

Reset Aplikasi

1. Buka tab Settings
2. Klik Reset Application
3. Konfirmasi reset
4. Semua data akan dihapus

Migrasi Data

1. Export data dari browser lama
2. Buka aplikasi di browser baru
3. Import data manual (coming soon)

🤝 Kontribusi

Laporkan Bug

1. Cek Troubleshooting section
2. Buka Console (F12) untuk error detail
3. Screenshot error message
4. Deskripsi langkah reproduksi

Request Fitur

· Multi-user support
· Database backend
· Email notifications
· Bulk account creation
· Report generation

📄 Lisensi

Disclaimer

```
Aplikasi ini hanya untuk tujuan testing dan penggunaan internal.
Penggunaan di production environment tidak direkomendasikan.
Penulis tidak bertanggung jawab atas kerusakan atau kehilangan data.
```

Development Notes

· Single HTML file - no installation required
· Pure JavaScript (no frameworks)
· localStorage for data persistence
· Responsive design

🔗 Link Penting

· WHM API Documentation
· Generate API Token Guide
· cPanel API Reference

🏆 Credits

Dibuat dengan ❤️ untuk administrator server

Versi

· v1.0.0 - Initial release
· Status: Development/Testing
· Browser Support: Chrome 80+, Firefox 75+, Edge 80+

---

💡 Tips Penggunaan

1. Selalu backup data sebelum reset
2. Ganti password default segera setelah login pertama
3. Test connection sebelum membuat account
4. Export history secara berkala
5. Gunakan di localhost untuk keamanan maksimal

🚀 Quick Start

```bash
# 1. Download file HTML
# 2. Edit konfigurasi WHM
# 3. Buka di browser
# 4. Login: admin/admin123
# 5. Buat account cPanel!
```

---

⭐ Jika aplikasi ini membantu, beri star di repository!

```

Copy seluruh kode di atas dan simpan sebagai `README.md` di folder project Anda.
