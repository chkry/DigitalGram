# DigitalGram 2.0 - Markdown & SQLite Update

## 🎉 What's New

Your DigitalGram app has been completely upgraded with powerful new features!

### ✨ Major Changes

#### 1. **Markdown Editor**
- Full markdown syntax support
- Live preview mode (toggle between edit/preview)
- Syntax toolbar with quick buttons:
  - **B** - Bold text
  - *I* - Italic text
  - • - Bullet lists
  - ☑ - Task checkboxes
  - 📷 - Insert images

#### 2. **SQLite Database Storage**
- Replaced JSON with SQLite for better performance
- Structured schema with proper indexing
- Database fields:
  - `id` - Unique entry identifier
  - `date` - Entry date (for daily grouping)
  - `timestamp` - Full timestamp (precise time)
  - `markdown_content` - Your markdown text

#### 3. **Image Support**
- Embed images directly in your journal
- Images stored in `images/` folder next to database
- Markdown syntax: `![description](./images/filename.jpg)`
- Click 📷 button to easily insert images

#### 4. **Settings Panel**
- Configure storage location
- Change where database and images are saved
- Open storage folder directly in Finder
- Reset to default location

#### 5. **Excel Export**
- Export to Excel (.xlsx) format
- In addition to CSV export
- Both formats include all entry data

---

## 📝 How to Use Markdown

### Basic Formatting
```markdown
**Bold text**
*Italic text*
```

### Headers
```markdown
# Big Header
## Medium Header
### Small Header
```

### Lists
```markdown
- Bullet point
- Another item
  - Nested item
```

### Task Lists
```markdown
- [ ] Unchecked task
- [x] Completed task
```

### Images
1. Click the 📷 button
2. Select an image file
3. It will be inserted as: `![name](./images/file.jpg)`

---

## 🗄️ Database Structure

### Location
Default: `~/Documents/DigitalGram/`

### Files
```
DigitalGram/
├── journal.db          # SQLite database
└── images/             # Embedded images
    ├── uuid_photo1.jpg
    └── uuid_photo2.png
```

### Schema
```sql
CREATE TABLE journal_entries (
    id TEXT PRIMARY KEY,
    date TEXT NOT NULL,
    timestamp TEXT NOT NULL,
    markdown_content TEXT NOT NULL
);
```

---

## 🔄 Migration from Old Version

If you were using the previous version with JSON storage:

### Your old data is safe!
The old `journal_entries.json` file is still in `~/Documents/DigitalGram/`

### To migrate (manual):
1. Open the old JSON file
2. Copy the content
3. Paste into a new markdown entry in the updated app

*Note: Automatic migration is not included as data formats differ significantly*

---

## ⚙️ Settings

Access settings by clicking the ⚙️ icon in the app.

### Storage Location
- **Default**: `~/Documents/DigitalGram`
- **Custom**: Choose any folder on your Mac
- Changes apply immediately
- Database reopens at new location

### Opening Storage Folder
Click "Open in Finder" to view your database and images.

---

## 📤 Export Options

### Excel Export (.xlsx)
- Full spreadsheet format
- All entries with metadata
- Opens in Excel, Numbers, Google Sheets

### CSV Export (.csv)
- Plain text format
- Compatible with any spreadsheet app
- Easy to import elsewhere

Both formats include:
- Entry ID
- Date
- Timestamp  
- Markdown Content

---

## 🎨 Markdown Preview

Toggle between editor and preview mode:
- **Editor**: Write and edit markdown
- **Preview**: See rendered output
- Click the document icon to switch

Preview shows:
- Formatted text (bold, italic)
- Headers in different sizes
- Bullet lists with proper styling
- Task checkboxes (interactive display)
- Embedded images

---

## 🖼️ Working with Images

### Adding Images
1. Write your journal entry
2. Click the 📷 button (or use markdown syntax)
3. Select image file (PNG, JPEG, GIF, HEIC)
4. Image is copied to storage folder
5. Markdown link is inserted

### Image Format
```markdown
![My Photo](./images/abc123_photo.jpg)
```

### Supported Formats
- PNG (.png)
- JPEG (.jpg, .jpeg)
- GIF (.gif)
- HEIC (.heic) - Apple Photos format

---

## 🔒 Privacy & Security

- **100% Local**: All data stored on your Mac only
- **No Cloud**: Nothing sent to external servers
- **No Tracking**: No analytics or telemetry
- **Your Data**: You control where it's stored

---

## 🛠️ Technical Details

### Technologies
- **Language**: Swift 5.0
- **UI**: SwiftUI
- **Database**: SQLite3
- **Storage**: Local file system

### Requirements
- macOS 13.0 or later
- ~2 MB disk space (plus your journal data)

### Performance
- Instant startup
- Fast search (indexed database)
- Efficient storage
- Low memory usage

---

## 📚 Tips & Tricks

### Daily Workflow
1. Click menu bar icon
2. Start typing (auto-saves as you go)
3. Use markdown for formatting
4. Add images when needed
5. Preview to check formatting

### Organization
- One entry per day
- Use headers (##) for sections
- Task lists for todos
- Images for memories

### Backup
- Database file: `journal.db`
- Copy to external drive or cloud
- Images folder: `images/`
- Both needed for full backup

---

## 🆘 Troubleshooting

### Database won't open
- Check storage path in settings
- Ensure folder exists and is writable
- Try resetting to default location

### Images not showing
- Verify image file exists in `images/` folder
- Check markdown syntax: `![](./images/file.jpg)`
- Ensure file extension matches

### Export fails
- Close other apps using the file
- Choose different save location
- Check disk space available

---

## 🚀 What's Next?

Planned features for future updates:
- Search across all entries
- Tags and categories
- Calendar view
- Dark mode customization
- iCloud sync (optional)
- Encryption support

---

## 📞 Questions?

Check the main README.md for:
- Installation instructions
- Build instructions
- Distribution guide

Enjoy your upgraded journaling experience! 📔✨
