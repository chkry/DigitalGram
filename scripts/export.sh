#!/bin/bash

# DigitalGram Export Script
# Creates a distributable .app bundle and optionally a .dmg installer

set -e

echo "📦 Exporting DigitalGram for distribution..."
echo ""

# Check if Xcode is installed
if ! xcode-select -p &> /dev/null || [[ $(xcode-select -p) == *"CommandLineTools"* ]]; then
    echo "❌ Error: Full Xcode application is required."
    echo "Please install Xcode from the Mac App Store first."
    exit 1
fi

# Clean previous builds
echo "🧹 Cleaning previous builds..."
rm -rf build/

# Build Release version
echo "🔨 Building Release version..."
xcodebuild -project DigitalGram.xcodeproj \
           -scheme DigitalGram \
           -configuration Release \
           -derivedDataPath ./build \
           clean build

APP_PATH="build/Build/Products/Release/DigitalGram.app"

if [ ! -d "$APP_PATH" ]; then
    echo "❌ Build failed - app not found"
    exit 1
fi

echo "✅ Build successful!"
echo ""

# Create distribution folder
DIST_DIR="dist"
mkdir -p "$DIST_DIR"

# Copy app to distribution folder
echo "📋 Copying app to distribution folder..."
cp -R "$APP_PATH" "$DIST_DIR/"

echo ""
echo "✅ Standalone app ready at: $DIST_DIR/DigitalGram.app"
echo ""

# Ask if user wants to create DMG
read -p "Would you like to create a DMG installer? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo ""
    echo "💿 Creating DMG installer..."
    
    DMG_NAME="DigitalGram-1.0.dmg"
    DMG_PATH="$DIST_DIR/$DMG_NAME"
    
    # Remove old DMG if exists
    rm -f "$DMG_PATH"
    
    # Create DMG
    hdiutil create -volname "DigitalGram" \
                   -srcfolder "$DIST_DIR/DigitalGram.app" \
                   -ov \
                   -format UDZO \
                   "$DMG_PATH"
    
    echo ""
    echo "✅ DMG created: $DMG_PATH"
    echo ""
    echo "📊 DMG Size: $(du -h "$DMG_PATH" | cut -f1)"
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✨ Export Complete!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "📁 Distribution files are in: $DIST_DIR/"
echo ""
echo "To distribute:"
echo "  • Share the .app file directly, or"
echo "  • Share the .dmg installer"
echo ""
echo "⚠️  Note: The app is NOT code-signed."
echo "   Recipients will need to right-click → Open"
echo "   on first launch to bypass Gatekeeper."
echo ""
echo "💡 For proper distribution, consider:"
echo "   1. Join Apple Developer Program (\$99/year)"
echo "   2. Get a Developer ID certificate"
echo "   3. Code sign and notarize the app"
echo ""
