# DigitalGram - Daily Journal Menu Bar App

A simple macOS menu bar application for daily journaling with formatting options and CSV export.

## System Requirements

- **macOS 12.0 Monterey** or later
- Compatible with macOS 13 Ventura, 14 Sonoma, 15 Sequoia
- Future-ready for macOS 16 Tahoe

## Features

- **Menu Bar Interface**: Stays in your macOS menu bar for quick access
- **Markdown Editor**: 
  - Full markdown syntax support
  - Live preview mode with interactive elements
  - Bold, italic, headers, lists
  - Task lists with clickable checkboxes `- [ ]` and `- [x]`
  - Image embedding with resizable preview
- **Calendar Navigation**:
  - Navigate to previous/next days
  - Date picker to jump to any date
  - View and edit entries from any day
- **List View**:
  - See all journal entries in one scrollable list
  - Sorted by date (newest first)
  - Quick jump to any entry
- **SQLite Storage**: 
  - Efficient database storage
  - Schema: Entry ID, Date, Timestamp, Markdown Content
  - Images stored in configurable folder
  - Database migration when changing storage location
- **Auto-Save**: Automatically saves your journal entries as you type
- **Excel & CSV Export**: Export all journal entries to Excel (.xlsx) or CSV format
- **Configurable Storage**: Choose where to store your database and images
- **Daily Entries**: One entry per day with full timestamp tracking

## Installation

### Quick Start (Recommended)

1. Open Terminal and navigate to the MenuBarApp folder
2. Run the build script:
   ```bash
   ./build.sh
   ```
3. The app will be built and you can choose to launch it immediately

### Using Xcode

1. Double-click `DigitalGram.xcodeproj` to open in Xcode
2. Select your development team in Signing & Capabilities tab (if required)
3. Press ⌘+R to build and run

### Command Line Build

```bash
# Build the release version
xcodebuild -project DigitalGram.xcodeproj -scheme DigitalGram -configuration Release build

# Or use the quick run script for development
./run.sh
```

## Project Structure

```
MenuBarApp/
├── DigitalGramApp.swift              # Main app entry point
├── AppDelegate.swift             # Menu bar setup
├── Models/
│   └── JournalEntry.swift        # Data models
├── Views/
│   └── JournalEntryView.swift    # Main journal interface
├── ViewModels/
│   └── JournalViewModel.swift    # Business logic
├── Storage/
│   └── StorageManager.swift      # Local storage handler
└── Info.plist                    # App configuration
```

## How to Use

1. **Launch the app**: The app will appear in your menu bar with a book icon
2. **Click the icon**: Opens a popover with the journal entry interface
3. **Navigate Dates**:
   - Use ◀ ▶ arrows to move between days
   - Click the date to open calendar picker
   - Click the list icon to see all entries
4. **Write in Markdown**:
   - Type naturally or use markdown syntax
   - **Bold**: `**text**` or click B button
   - *Italic*: `*text*` or click I button
   - Bullet lists: `- item` or click • button
   - Task lists: `- [ ]` for unchecked, `- [x]` for checked
   - Headers: `# H1`, `## H2`, `### H3`
   - Images: Click 📷 button to insert images
5. **Preview Mode**: 
   - Click the preview button to see rendered markdown
   - Click checkboxes to toggle task completion
   - Use slider to resize images (50% - 200%)
6. **Auto-save**: Changes are automatically saved as you type
7. **Settings**: Click ⚙️ to configure storage location
8. **Export**: Click ↑ to export as Excel or CSV

## Markdown Examples

```markdown
# My Daily Journal

## Tasks for Today
- [ ] Morning meditation
- [x] Write journal entry
- [ ] Exercise

## Notes
This is **important** and this is *italic*.

![My Image](./images/photo.jpg)
```

## Storage

Journal entries are stored locally in a SQLite database:

**Default Location:**
```
~/Documents/DigitalGram/
├── journal.db          # SQLite database
└── images/             # Embedded images
```

**Database Schema:**
- `id` (TEXT): Unique entry identifier
- `date` (TEXT): Entry date (ISO8601)
- `timestamp` (TEXT): Full timestamp (ISO8601)
- `markdown_content` (TEXT): Markdown-formatted content

**Customize Storage:**
Click the Settings (⚙️) icon to change where data is stored.

## CSV Export Format

The exported CSV file contains:
- **Entry ID**: Unique identifier
- **Date**: Entry date
- **Timestamp**: Full date and time
- **Markdown Content**: Complete markdown text

## Excel Export Format

The exported Excel file (.xlsx) contains the same data in spreadsheet format with proper formatting.

## Requirements

- macOS 13.0 or later
- Xcode 14.0 or later (for development)

## Distribution

To export the app for installation on other Macs:

```bash
./export.sh
```

This creates:
- `dist/DigitalGram.app` - Standalone app
- `dist/DigitalGram-1.0.dmg` - DMG installer

See [DISTRIBUTION.md](DISTRIBUTION.md) for detailed instructions on:
- Creating distributable packages
- Code signing (for public distribution)
- Notarization
- Installation instructions for users

## Privacy

All data is stored locally on your device. No data is sent to external servers.

## License

Free to use and modify for personal projects.
