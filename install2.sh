#!/bin/bash

echo "╭────────────────────────────────────────────╮"
echo "│     ⚙️  Auto Detect - han.vscodepack   │"
echo "╰────────────────────────────────────────────╯"
echo ""

# Detect OS
OS=$(uname)
if [[ "$OS" == "Darwin" ]]; then
    OSName="macOS"
elif [[ "$OS" == "Linux" ]]; then
    OSName="Linux"
elif [[ "$OS" == "MINGW"* || "$OS" == "CYGWIN"* ]]; then
    OSName="Windows"
else
    OSName="Unknown"
fi

echo "Detected OS: $OSName"

# Check VSCode CLI
if ! command -v code &> /dev/null; then
    case "$OSName" in
        Linux)
            echo "❌ VSCode not found. Install: sudo pacman -S code or your package manager"
            ;;
        macOS)
            echo "❌ VSCode not found. Install: brew install --cask visual-studio-code"
            ;;
        Windows)
            echo "❌ VSCode not found. Make sure 'code' is in PATH"
            ;;
    esac
    exit 1
fi

echo "📦 Checking extensions from han.vscodepack..."
sleep 0.5

# Read extensions file
while IFS= read -r ext; do
    # skip empty lines and comments
    [[ "$ext" =~ ^#.*$ || -z "$ext" ]] && continue

    if code --list-extensions | grep -qx "$ext"; then
        echo "✅ $ext already installed. Skipping..."
    else
        echo "📥 Installing $ext..."
        code --install-extension "$ext"
        sleep 0.1
    fi
done < "./han.vscodepack"

echo ""
echo "🎉 Ritual complete. Your IDE is fully enchanted."

echo ""
echo "📝 RECOMMENDED SETTINGS:"
cat <<'EOF'
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