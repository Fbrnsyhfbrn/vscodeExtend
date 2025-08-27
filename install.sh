#!/bin/bash

echo "╭────────────────────────────────────────────╮"
echo "│     ⚙️  Arch Dev Env Setup - han.vscodepack   │"
echo "╰────────────────────────────────────────────╯"
echo ""

# Check VS Code command availability
if ! command -v code &> /dev/null
then
    echo "❌ VSCode not found. Please install via pacman: sudo pacman -S code"
    exit 1
fi

echo "📦 Checking extensions from han.vscodepack..."
sleep 1

while read extension || [[ -n "$extension" ]]; do
    if [[ $extension == \#* || -z $extension ]]; then
        continue
    fi

    if code --list-extensions | grep -q "^$extension$"; then
        echo "✅ $extension already installed. Skipping..."
    else
        echo "📥 Installing $extension..."
        code --install-extension $extension
        sleep 0.1
    fi
done < han.vscodepack

echo ""
echo "🎉 Ritual complete. Your IDE is fully enchanted."

echo ""
echo "📝 RECOMMENDED SETTINGS:"
cat <<EOF

{
  "editor.fontFamily": "Fira Code",
  "editor.fontLigatures": true,
  "workbench.colorTheme": "Tokyo Night Storm",
  "workbench.iconTheme": "material-icon-theme",
  "editor.cursorBlinking": "expand",
  "editor.cursorSmoothCaretAnimation": true,
  "editor.smoothScrolling": true,
  "editor.minimap.enabled": true,
  "editor.guides.bracketPairs": "active"
}
EOF
 
echo ""
echo "🚀 Launch VS Code and embrace your full-stack destiny."
