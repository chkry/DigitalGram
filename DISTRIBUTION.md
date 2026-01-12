# Distribution Guide - DigitalGram

This guide explains how to export and distribute the DigitalGram app to other Macs.

## 🚀 Quick Export (For Personal Use or Testing)

### Step 1: Run the Export Script
```bash
./export.sh
```

This will:
- Build the Release version
- Create a `dist/` folder with `DigitalGram.app`
- Optionally create a DMG installer

### Step 2: Share the Files

You can distribute either:
- **DigitalGram.app** - The standalone app (in `dist/` folder)
- **DigitalGram-1.0.dmg** - DMG installer (easier for users)

### ⚠️ Important: First Launch on Other Macs

Since the app is **not code-signed**, users will need to:

1. **First time only**: Right-click the app → Select "Open"
2. Click "Open" in the security dialog
3. After this, they can double-click normally

Alternatively, users can run in Terminal:
```bash
xattr -cr /path/to/DigitalGram.app
```

---

## 🔐 Professional Distribution (Code-Signed)

For wider distribution, you should code-sign the app.

### Prerequisites

1. **Apple Developer Account** ($99/year)
   - Sign up at [developer.apple.com](https://developer.apple.com)

2. **Developer ID Certificate**
   - Download from Apple Developer portal
   - Install in Keychain Access

### Export with Code Signing

```bash
./export-signed.sh
```

This will:
- Build and sign the app with your Developer ID
- Create a signed DMG
- Verify the signature

### Optional: Notarization (Recommended)

For the best user experience, notarize the app:

```bash
# 1. Submit for notarization
xcrun notarytool submit dist/DigitalGram-1.0-Signed.dmg \
  --apple-id "your-email@example.com" \
  --team-id "YOUR_TEAM_ID" \
  --password "app-specific-password"

# 2. Wait for approval (usually 5-15 minutes)

# 3. Staple the notarization ticket
xcrun stapler staple dist/DigitalGram-1.0-Signed.dmg
```

---

## 📦 Distribution Methods

### Method 1: Direct Download
- Upload the DMG to your website, GitHub Releases, or cloud storage
- Users download and drag to Applications folder

### Method 2: GitHub Releases
```bash
# Tag the version
git tag v1.0
git push origin v1.0

# Upload dist/DigitalGram-1.0.dmg to GitHub Releases
```

### Method 3: Share via Cloud Storage
- Upload to Dropbox, Google Drive, etc.
- Share the download link

---

## 📂 What Users Receive

### Option A: .app File
```
DigitalGram.app
```
Users drag this to their Applications folder.

### Option B: .dmg Installer
```
DigitalGram-1.0.dmg
```
Users:
1. Double-click the DMG
2. Drag DigitalGram.app to Applications
3. Eject the DMG

---

## 🔍 Verification

### Check if app is signed:
```bash
codesign -dv dist/DigitalGram.app
```

### Check if app is notarized:
```bash
spctl -a -vv dist/DigitalGram.app
```

### Test the DMG:
```bash
open dist/DigitalGram-1.0.dmg
```

---

## 🛠️ Manual Export (Without Scripts)

If you prefer to do it manually in Xcode:

1. Open `DigitalGram.xcodeproj`
2. Select **Product → Archive**
3. In Organizer, click **Distribute App**
4. Choose **Copy App**
5. Save the .app file

Then create DMG:
```bash
hdiutil create -volname "DigitalGram" \
               -srcfolder DigitalGram.app \
               -ov -format UDZO \
               DigitalGram.dmg
```

---

## 🔒 Security Notes

### Unsigned Apps (Personal Distribution)
- Works fine for personal use or small groups
- Users see a security warning on first launch
- Requires right-click → Open

### Signed Apps (Public Distribution)
- No security warnings
- Users can double-click to open
- Requires Apple Developer account

### Notarized Apps (Best Practice)
- Apple has verified the app is malware-free
- Seamless installation experience
- Required for macOS 10.15+ for best UX

---

## 📊 File Sizes

Typical sizes:
- **DigitalGram.app**: ~1-2 MB
- **DigitalGram.dmg**: ~500 KB - 1 MB (compressed)

---

## 🐛 Troubleshooting

### "App is damaged and can't be opened"
This happens with unsigned apps. Users should:
```bash
xattr -cr /Applications/DigitalGram.app
```

### Build fails during export
- Make sure Xcode is fully installed
- Check that you're using the correct scheme
- Verify Info.plist and entitlements are correct

### Code signing fails
- Verify certificate is installed in Keychain
- Check certificate is valid (not expired)
- Ensure Xcode is using the correct team

---

## 📝 Checklist for Distribution

- [ ] Build succeeds without errors
- [ ] Test the app on your Mac
- [ ] Export using `./export.sh`
- [ ] Test the exported .app
- [ ] (Optional) Test the .dmg installer
- [ ] (Optional) Code sign with `./export-signed.sh`
- [ ] (Optional) Notarize the app
- [ ] Upload to distribution platform
- [ ] Provide installation instructions to users

---

## 🆘 Support

If users have issues installing:
1. Verify they're running macOS 13.0 or later
2. Try the right-click → Open method
3. Check System Preferences → Security & Privacy
4. Consider providing a signed/notarized version
