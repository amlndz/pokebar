#!/bin/zsh
# Compila en modo release y empaqueta PokeBar.app en el directorio actual.
set -euo pipefail
cd "$(dirname "$0")"

swift build -c release

APP="PokeBar.app"
rm -rf "$APP"
mkdir -p "$APP/Contents/MacOS" "$APP/Contents/Resources"

cp .build/release/PokeBar "$APP/Contents/MacOS/PokeBar"
cp -R .build/release/PokeBar_PokeBar.bundle "$APP/Contents/Resources/"

cat > "$APP/Contents/Info.plist" <<'PLIST'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleExecutable</key>
    <string>PokeBar</string>
    <key>CFBundleIdentifier</key>
    <string>com.local.pokebar</string>
    <key>CFBundleName</key>
    <string>PokeBar</string>
    <key>CFBundlePackageType</key>
    <string>APPL</string>
    <key>CFBundleShortVersionString</key>
    <string>1.0</string>
    <key>LSMinimumSystemVersion</key>
    <string>13.0</string>
    <key>LSUIElement</key>
    <true/>
</dict>
</plist>
PLIST

codesign --force --sign - "$APP"

echo "Listo: $(pwd)/$APP"
echo "Ábrela con: open $APP"
