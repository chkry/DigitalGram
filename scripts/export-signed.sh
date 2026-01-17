#!/bin/bash

# Advanced Export Script with Code Signing
# Use this if you have an Apple Developer ID certificate

set -e

echo "🔐 Exporting DigitalGram with Code Signing..."
echo ""

# Check for code signing identity
IDENTITIES=$(security find-identity -v -p codesigning 2>/dev/null | grep "Developer ID Application" || true)

if [ -z "$IDENTITIES" ]; then
    echo "⚠️  No Developer ID certificate found."
    echo ""
    echo "Options:"
    echo "  1. Use ./export.sh for unsigned export"
    echo "  2. Get a Developer ID from developer.apple.com"
    echo ""
    exit 1
fi

echo "Available signing identities:"
echo "$IDENTITIES"
echo ""

# Get the first identity
IDENTITY=$(echo "$IDENTITIES" | head -n 1 | sed 's/.*"\(.*\)".*/\1/')
echo "Using identity: $IDENTITY"
echo ""

# Build
echo "🔨 Building Release version..."
xcodebuild -project DigitalGram.xcodeproj \
           -scheme DigitalGram \
           -configuration Release \
           -derivedDataPath ./build \
           CODE_SIGN_IDENTITY="$IDENTITY" \
           clean build

APP_PATH="build/Build/Products/Release/DigitalGram.app"

# Verify signature
echo "✅ Verifying code signature..."
codesign --verify --deep --strict "$APP_PATH"
codesign -dv "$APP_PATH"

# Create distribution
DIST_DIR="dist"
mkdir -p "$DIST_DIR"
cp -R "$APP_PATH" "$DIST_DIR/"

echo ""
echo "✅ Signed app ready at: $DIST_DIR/DigitalGram.app"
echo ""

# Create signed DMG
DMG_NAME="DigitalGram-1.0-Signed.dmg"
DMG_PATH="$DIST_DIR/$DMG_NAME"

echo "💿 Creating signed DMG..."
rm -f "$DMG_PATH"

hdiutil create -volname "DigitalGram" \
               -srcfolder "$DIST_DIR/DigitalGram.app" \
               -ov \
               -format UDZO \
               "$DMG_PATH"

# Sign the DMG
echo "🔐 Signing DMG..."
codesign --force --sign "$IDENTITY" "$DMG_PATH"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✨ Signed Export Complete!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "📁 Signed DMG: $DMG_PATH"
echo ""
echo "Next steps for App Store-level distribution:"
echo "  1. Notarize the app: xcrun notarytool submit"
echo "  2. Staple the notarization: xcrun stapler staple"
echo ""
