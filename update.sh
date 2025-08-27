#!/bin/bash

# Pastikan VSCode CLI tersedia
if ! command -v code &> /dev/null; then
  echo "❌ VSCode CLI (code) gak ketemu. Install dulu ya."
  exit 1
fi

# Fungsi untuk ngecek update ekstensi
check_for_updates() {
  echo "🔎 Mencari update ekstensi yang terinstall..."

  updates=()
  while IFS= read -r ext; do
    # skip empty or comment lines
    [[ -z "$ext" || "$ext" =~ ^# ]] && continue

    # VSCode CLI gak ada API resmi buat cek versi terbaru,
    # jadi di sini kita bakal coba reinstall tiap ekstensi dan lihat output
    # kalau "already installed" berarti gak ada update
    update_output=$(code --install-extension "$ext" 2>&1)
    if echo "$update_output" | grep -q "already installed"; then
      echo "✅ $ext - up to date"
    else
      echo "⚠️ Update tersedia untuk $ext"
      updates+=("$ext")
    fi
  done < <(code --list-extensions)

  if [ ${#updates[@]} -eq 0 ]; then
    echo "🎉 Semua ekstensi sudah versi terbaru!"
    return 1
  else
    echo "🛠️ Ekstensi yang perlu update:"
    printf '%s\n' "${updates[@]}"
    return 0
  fi
}

# Fungsi untuk tanya user kalo ada pre-release
prompt_prerelease() {
  read -p "⚠️ Ada update pre-release, install? (y/n): " answer
  [[ "$answer" =~ ^[Yy]$ ]]
}

# Update semua ekstensi yang perlu update
update_extensions() {
  echo "🚀 Mulai update ekstensi..."

  while IFS= read -r ext; do
    [[ -z "$ext" || "$ext" =~ ^# ]] && continue

    # Dummy check pre-release (kalo ada kata beta/alpha di nama)
    if [[ "$ext" =~ (beta|alpha) ]]; then
      if prompt_prerelease; then
        echo "🔄 Install pre-release $ext"
        code --install-extension "$ext" --pre-release
      else
        echo "⏭ Skip pre-release $ext"
      fi
    else
      echo "🔄 Install stable update $ext"
      code --install-extension "$ext"
    fi

    sleep 0.2
  done < <(code --list-extensions)

  echo "✅ Update selesai."
}

# Remove ekstensi
remove_extension() {
  echo "📦 List ekstensi terinstall:"
  code --list-extensions

  read -p "🗑️ Ketik nama ekstensi yang mau dihapus: " extname
  if code --list-extensions | grep -q "^$extname$"; then
    echo "🧹 Menghapus $extname ..."
    code --uninstall-extension "$extname"
    echo "✅ $extname sudah dihapus."
  else
    echo "❌ Ekstensi '$extname' gak ketemu."
  fi
}

case "$1" in
  update)
    if check_for_updates; then
      update_extensions
    fi
    ;;
  remove)
    remove_extension
    ;;
  *)
    echo "Usage: $0 {update|remove}"
    echo "  update - cek & update ekstensi"
    echo "  remove - uninstall ekstensi"
    ;;
esac
