Write-Host "╭────────────────────────────────────────────╮"
Write-Host "│     ⚙️  Auto Detect - han.vscodepack   │"
Write-Host "╰────────────────────────────────────────────╯"
Write-Host ""

# Detect OS
$OS = $PSVersionTable.OS
if ($IsWindows) { $OSName = "Windows" }
elseif ($IsMacOS) { $OSName = "macOS" }
elseif ($IsLinux) { $OSName = "Linux" }
else { $OSName = "Unknown" }

Write-Host "Detected OS: $OSName"

# Check VSCode
try {
    code --version | Out-Null
} catch {
    switch ($OSName) {
        "Linux" { Write-Host "❌ VSCode not found. Install: sudo pacman -S code" }
        "macOS" { Write-Host "❌ VSCode not found. Install: brew install --cask visual-studio-code" }
        "Windows" { Write-Host "❌ VSCode not found. Make sure 'code' is in PATH" }
    }
    exit
}

Write-Host "📦 Checking extensions from han.vscodepack..."
Start-Sleep -Milliseconds 500

# Read extensions file
$extensions = Get-Content -Path ".\han.vscodepack" | Where-Object { ($_ -notmatch '^#') -and ($_ -ne '') }

foreach ($ext in $extensions) {
    if (code --list-extensions | Select-String -Pattern "^$ext$") {
        Write-Host "✅ $ext already installed. Skipping..."
    } else {
        Write-Host "📥 Installing $ext..."
        code --install-extension $ext
        Start-Sleep -Milliseconds 100
    }
}

Write-Host ""
Write-Host "🎉 Ritual complete. Your IDE is fully enchanted."

Write-Host ""
Write-Host "📝 RECOMMENDED SETTINGS:"
@"
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
"@

Write-Host ""
Write-Host "🚀 Launch VS Code and embrace your full-stack destiny."