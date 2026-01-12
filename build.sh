#!/bin/bash

# DigitalGram Build Script
# This script builds and optionally runs the DigitalGram app

set -e

# Check if Xcode is installed
if ! xcode-select -p &> /dev/null || [[ $(xcode-select -p) == *"CommandLineTools"* ]]; then
    echo "❌ Error: Full Xcode application is required to build this app."
    echo ""
    echo "📥 Please install Xcode from the Mac App Store:"
    echo "   https://apps.apple.com/app/xcode/id497799835"
    echo ""
    echo "After installation, run:"
    echo "   sudo xcode-select --switch /Applications/Xcode.app"
    echo ""
    echo "Alternatively, open DigitalGram.xcodeproj directly in Xcode and press ⌘+R to run."
    exit 1
fi

echo "🔨 Building DigitalGram..."

# Build the project
xcodebuild -project DigitalGram.xcodeproj \
           -scheme DigitalGram \
           -configuration Release \
           -derivedDataPath ./build \
           clean build

echo "✅ Build completed successfully!"
echo ""
echo "📦 App location: build/Build/Products/Release/DigitalGram.app"
echo ""

# Ask if user wants to run the app
read -p "Would you like to run DigitalGram now? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
    echo "🚀 Launching DigitalGram..."
    open build/Build/Products/Release/DigitalGram.app
fi
