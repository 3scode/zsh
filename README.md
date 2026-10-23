# Backup `.zshrc` — Tampilan Shell

Repositori ini berisi backup konfigurasi Zsh yang **fokus ke tampilan shell**: theme, prompt, warna, ikon, dan tampilan completion. Tidak ada konfigurasi tool development di dalamnya.

Panduan ini mencakup pemasangan di **Linux**, **WSL (Windows)**, dan **Windows native**.

---

## Isi `.zshrc`

| Bagian | Fungsi |
|---|---|
| PATH | Menambahkan `~/.local/bin` agar Oh My Posh ketemu |
| Oh My Zsh | Base config, tema `robbyrussell` sebagai fallback |
| Oh My Posh | Prompt utama, theme `emodipt-extend` (cache lokal + fallback URL) |
| eza | Alias `ls/l/la/ll/lt` dengan warna dan ikon |
| Mouse tracking | Mematikan escape sequence mouse agar terminal bersih |
| Completion | Warna `LS_COLORS`, menu `select`, `cd` hanya direktori |
| fzf-tab | Menu completion dengan preview `eza` |

**Yang sengaja dihapus:** nvm, bun, Android SDK, `JAVA_HOME`, Maestro, broot, x-cmd, uv, API key, dan alias proyek (`nv`, `clean-next`).

Konfigurasi versi lengkap masih ada di commit `0b613c2` — lihat [bagian 8](#8-konfigurasi-lengkap-versi-lama).

---

## Kompatibilitas

| Lingkungan | Status | Catatan |
|---|---|---|
| Linux native (Debian/Ubuntu/Arch/Fedora) | ✅ Penuh | Paling sesuai |
| WSL2 (Debian/Ubuntu) | ✅ Penuh | **Disarankan** untuk pengguna Windows |
| Windows + MSYS2 | ✅ Hampir penuh | Butuh eza/oh-my-posh versi Windows |
| Windows + Cygwin | ⚠️ Terbatas | Beberapa tool harus manual |
| Windows PowerShell / CMD | ❌ | Zsh tidak tersedia native |

> Git Bash **tidak bisa** memuat `.zshrc` karena shell-nya bash. Gunakan WSL2 atau MSYS2.

---

## Dependensi

| Kebutuhan | Fungsi | Cara pasang |
|---|---|---|
| `zsh` | Shell | Paket distro |
| Oh My Zsh | Framework config | Installer resmi |
| `zsh-autosuggestions` | Saran perintah saat mengetik | Git clone ke plugin OMZ |
| `eza` | `ls` berwarna + ikon | Paket distro / winget / scoop |
| Nerd Font | Glyph ikon | Nerd Fonts |
| Oh My Posh | Prompt | Installer resmi |
| `fzf` | Fuzzy finder untuk fzf-tab | Paket distro |
| `fzf-tab` | Menu completion | Git clone |

---

## 0. Ambil file dari repo

```bash
git clone https://github.com/3scode/backup.git ~/backup
cd ~/backup
```

Backup config lama sebelum menimpa:

```bash
[ -f ~/.zshrc ] && cp ~/.zshrc ~/.zshrc.bak.$(date +%Y%m%d)
```

---

## 1. Linux (native)

### 1.1 Paket dasar

**Debian / Ubuntu:**

```bash
sudo apt update
sudo apt install -y zsh git curl fzf eza
```

Kalau `eza` tidak tersedia di repo distro:

```bash
sudo mkdir -p /etc/apt/keyrings
wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc \
  | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" \
  | sudo tee /etc/apt/sources.list.d/gierens.list
sudo apt update && sudo apt install -y eza
```

**Arch:**

```bash
sudo pacman -S --needed zsh git curl fzf eza
```

**Fedora:**

```bash
sudo dnf install -y zsh git curl fzf eza
```

### 1.2 Oh My Zsh

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

Installer membuat `~/.zshrc` baru — nanti ditimpa file dari repo.

### 1.3 Plugin & prompt

```bash
# zsh-autosuggestions (sesuai plugins=(zsh-autosuggestions))
git clone https://github.com/zsh-users/zsh-autosuggestions \
  "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"

# fzf-tab (dibaca dari ~/.zsh/fzf-tab)
git clone --depth=1 https://github.com/Aloxaf/fzf-tab ~/.zsh/fzf-tab

# Oh My Posh ke ~/.local/bin
curl -s https://ohmyposh.dev/install.sh | bash -s -- -d ~/.local/bin
```

Opsional — simpan theme Oh My Posh supaya prompt tidak butuh internet:

```bash
mkdir -p ~/.config/oh-my-posh
curl -fsSL https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/emodipt-extend.omp.json \
  -o ~/.config/oh-my-posh/emodipt-extend.omp.json
```

### 1.4 Pasang `.zshrc`

```bash
cp ~/backup/.zshrc ~/.zshrc
```

Atau symlink agar perubahan langsung ter-track git:

```bash
ln -sf ~/backup/.zshrc ~/.zshrc
```

### 1.5 Jadikan zsh default

```bash
chsh -s "$(which zsh)"
```

Logout/login, atau langsung `exec zsh`.

---

## 2. Windows via WSL2 (disarankan)

### 2.1 Install WSL

PowerShell (Admin):

```powershell
wsl --install -d Debian
# atau: wsl --install -d Ubuntu
wsl --set-default Debian
```

Buka distro dari Start Menu, lalu ikuti **semua langkah Linux** di atas.

### 2.2 Khusus WSL

- Simpan file di home Linux (`~/`), bukan `/mnt/c/...` — lebih cepat dan permission-nya benar.
- **Nerd Font** dipasang di sisi Windows:

  ```powershell
  winget install --id DEVCOM.JetBrainsMonoNerdFont
  ```

  Set font di Windows Terminal: Settings → Profil distro → Appearance → Font face.

- **Hindari editor Windows** yang menyisipkan CRLF. Kalau terlanjur:

  ```bash
  sed -i 's/\r$//' ~/.zshrc
  git config --global core.autocrlf input
  ```

- Utilitas Windows dari WSL:

  ```bash
  clip.exe < file.txt     # copy ke clipboard Windows
  explorer.exe .          # buka folder WSL di Explorer
  ```

---

## 3. Windows native (MSYS2 / Cygwin)

Zsh tidak bisa jalan di PowerShell/CMD. Alternatif native: MSYS2.

### 3.1 MSYS2

```powershell
winget install MSYS2.MSYS2
```

Buka **MSYS2 UCRT64**:

```bash
pacman -Syu          # tutup & buka ulang kalau diminta
pacman -S --needed zsh git curl fzf unzip
```

Install tool versi Windows:

```powershell
winget install JanDeDobbeleer.OhMyPosh
winget install eza-community.eza
# alternatif eza: scoop install eza
```

Buat profil Windows Terminal dengan command line:

```
C:\msys64\usr\bin\zsh.exe -l
```

Home MSYS2 ada di `C:\msys64\home\<user>`; cek dengan `echo $HOME`.

### 3.2 Penyesuaian

| Bagian | Di Linux/WSL | Di Windows native |
|---|---|---|
| PATH | `~/.local/bin` | Oh My Posh dari `winget` sudah ada di PATH — bagian ini boleh dibiarkan |
| eza | paket distro | `winget`/`scoop`, lalu pastikan `eza` bisa dipanggil dari zsh |
| fzf-tab | `~/.zsh/fzf-tab` | Clone dengan path yang sama di home MSYS2 |
| Nerd Font | font terminal Linux | Install di Windows, set di Windows Terminal |
| fzf | paket distro | `pacman -S fzf` |

Kalau `oh-my-posh` belum terdeteksi, cek dengan `which oh-my-posh` di zsh. Kalau kosong, tambahkan folder instalasinya ke PATH atau install ulang lewat Scoop.

### 3.3 Cygwin (alternatif)

Install lewat `setup-x86_64.exe`, centang `zsh`, `git`, `curl`, `fzf`. Tool seperti `eza` dan Oh My Posh dipasang dari versi Windows, lalu pastikan ada di PATH. Dukungan paling terbatas dari ketiga opsi.

---

## 4. Kustomisasi tampilan

### Ganti theme Oh My Posh

Ganti URL/nama file theme di bagian **Prompt: Oh My Posh**. Daftar theme: <https://ohmyposh.dev/docs/themes>.

### Ganti theme Oh My Zsh

Ubah `ZSH_THEME="robbyrussell"`. Theme ini hanya terlihat kalau Oh My Posh tidak terpasang.

### Tanpa Oh My Posh

Hapus/komentari blok Oh My Posh, prompt otomatis kembali ke tema Oh My Zsh.

### Tanpa eza

Komentari blok alias eza; `ls` kembali ke perintah bawaan.

---

## 5. Verifikasi

```bash
exec zsh
echo $ZSH_THEME              # robbyrussell
alias | grep eza             # alias tampilan muncul
which eza oh-my-posh fzf     # semua ketemu
zsh -i -c exit               # tidak ada error saat startup
```

Cek tampilan: `ls` harus keluar ikon dan warna, prompt menampilkan segmen Oh My Posh, dan `cd` + Tab memunculkan preview direktori.

---

## 6. Troubleshooting

| Gejala | Penyebab | Solusi |
|---|---|---|
| Ikon jadi kotak `□` | Font bukan Nerd Font | Install Nerd Font, set di terminal |
| Prompt masih `robbyrussell` | Oh My Posh tidak terpasang / tidak di PATH | Cek `which oh-my-posh`, install ulang |
| `command not found: eza` | eza belum ada | Install eza, atau komentari blok alias |
| `plugin 'zsh-autosuggestions' not found` | Plugin belum di-clone | Clone ke `$ZSH_CUSTOM/plugins/` |
| fzf-tab tidak muncul | Folder `~/.zsh/fzf-tab` belum ada | Clone repo fzf-tab |
| `compinit: insecure directories` | Permission folder zsh | `compaudit \| xargs chmod go-w` |
| Error aneh setelah edit di Windows | Line ending CRLF | `sed -i 's/\r$//' ~/.zshrc` |
| `/mnt/c` lambat di WSL | Project di filesystem Windows | Pindahkan ke `~/` |
| Prompt lambat / rusak offline | Theme diambil dari URL | Cache theme lokal (langkah 1.3) |

---

## 7. Update backup

```bash
cd ~/backup
cp ~/.zshrc .zshrc        # lewati kalau pakai symlink
git add .zshrc README.md
git commit -m "Update zshrc tampilan"
git push
```

---

## 8. Konfigurasi lengkap versi lama

Versi lama (dengan nvm, bun, Android SDK, Maestro, broot, x-cmd) masih tersimpan di history:

```bash
git show 0b613c2:.zshrc > ~/.zshrc.full
```

Atau ambil bagian tertentu saja:

```bash
git show 0b613c2:.zshrc | grep -A2 "Android SDK"
```

> **Keamanan:** versi lama memuat `EXA_API_KEY` plaintext yang pernah di-push. Kalau repo publik, **revoke/rotate key tersebut**. Jangan pernah commit secret ke repo.
