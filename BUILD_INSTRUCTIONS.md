# DigitalGram Build & Distribution Instructions

## App Icon

The app icon is a custom-designed book icon generated from scratch. The icon files are located in:
```
DigitalGram/Assets.xcassets/AppIcon.appiconset/
```

### Regenerating Icons

If you need to modify the icon design:

1. Edit `generate_icon.py` to customize colors, shapes, etc.
2. Run the script:
```bash
python3 generate_icon.py
```

This will regenerate all icon sizes (16x16 through 1024x1024, including @2x retina versions).

## Building for Distribution

### Creating a DMG

To create a distributable DMG with drag-and-drop installation:

```bash
./create_dmg.sh
```

This script will:
1. Build the app in Release configuration
2. Create a DMG with the app and an Applications folder symlink
3. Set up the DMG window with proper icon positioning
4. Compress the final DMG

The output will be `DigitalGram-1.0.0.dmg` in the project root.

### DMG Features

- **Drag & Drop Installation**: Users can drag DigitalGram.app to the Applications folder
- **Custom Icon**: The app displays the book icon in Finder, the Dock, and the DMG
- **Optimized Size**: The DMG is compressed for minimal file size (~324KB)

## Manual Build (Without DMG)

To build the app manually for testing:

```bash
xcodebuild -scheme DigitalGram -configuration Release build
```

The app will be located at:
```
build/Build/Products/Release/DigitalGram.app
```

## Requirements

- Xcode 15.0 or later
- macOS 12.0 or later (deployment target)
- Python 3 with Pillow (for icon generation)

## Version Management

To update the version:
1. Open the project in Xcode
2. Select the DigitalGram target
3. Update the version in General → Identity → Version
4. Update VERSION in `create_dmg.sh` to match

## Distribution

Once you have the DMG:
1. Test installation on a clean macOS system
2. The app can be distributed directly or notarized for Gatekeeper
3. For distribution outside the App Store, consider notarization:
   ```bash
   xcrun notarytool submit DigitalGram-1.0.0.dmg --wait
   ```

## App Icon Design

The book icon features:
- **Blue gradient book cover** (SF Blue color scheme)
- **Page layers** with white/off-white pages showing depth
- **Orange bookmark ribbon** for visual interest
- **Drop shadow** for depth perception
- **Rounded corners** following macOS design guidelines

The icon is designed to be clear and recognizable at all sizes from 16x16 to 1024x1024 pixels.
