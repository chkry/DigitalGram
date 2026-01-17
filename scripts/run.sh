#!/bin/bash

# Quick run script for development

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
    echo "🎯 Quick Option: Open the project in Xcode now:"
    echo "   open DigitalGram.xcodeproj"
    echo "   Then press ⌘+R to build and run"
    exit 1
fi

echo "🚀 Running DigitalGram in debug mode..."

xcodebuild -project DigitalGram.xcodeproj \
           -scheme DigitalGram \
           -configuration Debug \
           -derivedDataPath ./build \
           build

open build/Build/Products/Debug/DigitalGram.app
