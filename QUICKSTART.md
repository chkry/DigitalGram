# DigitalGram - Quick Start Guide

## ⚠️ Prerequisites

**You need full Xcode installed** (not just Command Line Tools):
1. Install from Mac App Store: [Download Xcode](https://apps.apple.com/app/xcode/id497799835)
2. After installation, run: `sudo xcode-select --switch /Applications/Xcode.app`

## 🚀 Run the App

### ⭐ Recommended: Open in Xcode (Easiest)
```bash
cd /Users/chkry/Documents/CODE/MenuBarApp
open DigitalGram.xcodeproj
```
Then press **⌘+R** to build and run

### Option 2: Build Script
```bash
./build.sh
```

### Option 3: Quick Run (Development)
```bash
./run.sh
```

## 📁 Project Structure

```
MenuBarApp/
├── DigitalGram.xcodeproj/         # Xcode project file
├── DigitalGram/                   # App source code
│   ├── DigitalGramApp.swift
│   ├── AppDelegate.swift
│   ├── Models/
│   │   └── JournalEntry.swift
│   ├── Views/
│   │   └── JournalEntryView.swift
│   ├── ViewModels/
│   │   └── JournalViewModel.swift
│   ├── Storage/
│   │   └── StorageManager.swift
│   ├── Assets.xcassets/
│   ├── Info.plist
│   └── DigitalGram.entitlements
├── build.sh                   # Build and run script
├── run.sh                     # Quick development run
└── README.md                  # Full documentation
```

## ✨ Features

- Menu bar app with book icon
- Daily journal with formatting (bullets, checkboxes)
- Auto-save to local storage
- Export to CSV

## 📦 Output

Built app will be at:
- Release: `build/Build/Products/Release/DigitalGram.app`
- Debug: `build/Build/Products/Debug/DigitalGram.app`

## 🔧 Troubleshooting

**Code signing error?**
- Open DigitalGram.xcodeproj in Xcode
- Go to Signing & Capabilities
- Select your Apple Developer team

**Build fails?**
- Make sure Xcode Command Line Tools are installed:
  ```bash
  xcode-select --install
  ```

**Can't run script?**
- Make scripts executable:
  ```bash
  chmod +x build.sh run.sh
  ```
