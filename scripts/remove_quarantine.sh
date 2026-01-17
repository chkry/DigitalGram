#!/bin/bash
#
# Remove macOS quarantine attribute from DigitalGram
# This allows the app to run without Gatekeeper warnings
#

set -e

APP_PATH="/Applications/DigitalGram.app"
DMG_APP_PATH="./DigitalGram.app"

echo "🔓 DigitalGram Quarantine Remover"
echo "=================================="
echo ""

# Check if app exists in Applications
if [ -d "$APP_PATH" ]; then
    echo "✓ Found DigitalGram in Applications folder"
    echo "  Removing quarantine attribute..."
    xattr -cr "$APP_PATH"
    echo "✓ Quarantine attribute removed!"
    echo ""
    echo "DigitalGram can now be opened normally from Applications."
    
# Check if app exists in current directory (mounted DMG)
elif [ -d "$DMG_APP_PATH" ]; then
    echo "✓ Found DigitalGram in current directory"
    echo "  Removing quarantine attribute..."
    xattr -cr "$DMG_APP_PATH"
    echo "✓ Quarantine attribute removed!"
    echo ""
    echo "You can now drag DigitalGram to Applications and open it."
    
else
    echo "❌ DigitalGram.app not found!"
    echo ""
    echo "Please ensure DigitalGram is installed in one of these locations:"
    echo "  • /Applications/DigitalGram.app"
    echo "  • Current directory (if DMG is mounted)"
    echo ""
    echo "Usage:"
    echo "  1. Mount the DigitalGram DMG"
    echo "  2. cd to the mounted volume or Applications folder"
    echo "  3. Run this script again"
    exit 1
fi

echo ""
echo "Done! 🎉"
