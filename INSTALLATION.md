# DigitalGram Installation Guide

## macOS Security Notice

When you first open DigitalGram, macOS may block it with a message saying **"DigitalGram cannot be opened because it is from an unidentified developer."**

This is normal for apps not distributed through the Mac App Store. Here's how to safely open DigitalGram:

## Installation Methods

### Method 1: Right-Click to Open (Recommended)

1. **Mount the DMG** - Double-click `DigitalGram-1.1.dmg`
2. **Drag DigitalGram** to your Applications folder
3. **Right-click** (or Control+click) on DigitalGram.app in Applications
4. Select **"Open"** from the menu
5. Click **"Open"** in the security dialog that appears
6. The app will now open and can be launched normally going forward

### Method 2: System Settings

1. Try to open DigitalGram normally (it will be blocked)
2. Go to **System Settings → Privacy & Security**
3. Scroll down to the **Security** section
4. You'll see a message: *"DigitalGram was blocked from use because it is not from an identified developer"*
5. Click **"Open Anyway"**
6. Click **"Open"** in the confirmation dialog

### Method 3: Remove Quarantine (Advanced)

If you're comfortable with Terminal:

1. Open **Terminal**
2. Run this command:
   ```bash
   xattr -cr /Applications/DigitalGram.app
   ```
3. Open DigitalGram normally

## Why Does This Happen?

DigitalGram is an open-source app that isn't signed with an Apple Developer certificate. macOS Gatekeeper blocks it by default as a security precaution. Once you explicitly allow it using one of the methods above, macOS will remember your choice.

## Is It Safe?

Yes! DigitalGram is open source - you can review the code at [github.com/chkry](https://github.com/chkry). The app:
- Stores all data locally on your Mac
- Doesn't connect to the internet
- Doesn't collect any personal information
- Is built from publicly available source code

## Troubleshooting

**"The app is damaged and can't be opened"**
- This happens when the quarantine attribute is set
- Use Method 3 (Remove Quarantine) above

**Still having issues?**
- Make sure you're on macOS 12.0 or later
- Try redownloading the DMG file
- Contact: ChakradharReddyPakala@gmail.com
