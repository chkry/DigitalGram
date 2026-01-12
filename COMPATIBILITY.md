# macOS Compatibility Guide

## Supported Versions

DigitalGram is designed to be compatible with:

- ✅ **macOS 12.0 Monterey** (Minimum deployment target)
- ✅ **macOS 13.0 Ventura**
- ✅ **macOS 14.0 Sonoma**
- ✅ **macOS 15.0 Sequoia**
- ✅ **macOS 16.0 Tahoe** (Future-ready)

## Compatibility Features

### 1. Deployment Target
- **Minimum**: macOS 12.0
- Ensures the app runs on the last 3-4 major versions of macOS
- Forward-compatible with future versions

### 2. API Version Checks

#### File Type Handling
```swift
// Uses UTType with fallback for older systems
if #available(macOS 11.0, *) {
    savePanel.allowedContentTypes = [.commaSeparatedText]
} else {
    savePanel.allowedFileTypes = ["csv"]
}
```

#### Date Formatting
- Replaced `ISO8601Format()` (macOS 13.0+) with `ISO8601DateFormatter()` (macOS 10.12+)
- Ensures date formatting works across all supported versions

#### System Symbols
- Uses SF Symbols with emoji fallback
- Ensures icons display properly on all versions

### 3. Database Compatibility

#### SQLite Features
- **WAL Mode**: Write-Ahead Logging for better concurrency
- **Foreign Keys**: Enabled by default
- **Thread Safety**: Database queue ensures safe concurrent access

#### Security-Scoped Bookmarks
- Properly handles sandboxed file access
- Compatible with macOS security features
- Graceful fallback to default paths

### 4. SwiftUI Compatibility

#### View Modifiers
- All SwiftUI features used are available on macOS 12.0+
- No deprecated APIs used
- Future-proof implementations

#### Async/Await
- Uses Task-based concurrency (macOS 12.0+)
- Proper debouncing for auto-save
- Thread-safe operations

### 5. AppKit Integration

#### Menu Bar
- NSStatusBar properly configured
- Popover behavior compatible across versions
- Event monitoring works on all supported versions

#### File Panels
- NSOpenPanel with version-specific features
- NSSavePanel with UTType fallbacks
- Sheet modal presentation for better UX

## Testing Recommendations

### Pre-Release Testing
Test the app on:
1. **macOS 12.0** - Minimum supported version
2. **macOS 13.0** - Ventura features
3. **macOS 14.0** - Sonoma features
4. **Latest Beta** - Future compatibility

### Key Features to Test
- [ ] Database creation and migration
- [ ] Image insertion and preview
- [ ] Export to CSV/Excel
- [ ] Import from CSV
- [ ] Multi-database switching
- [ ] Settings persistence
- [ ] Dark mode toggle
- [ ] Auto-save functionality

## Known Limitations

### macOS 12.0 Specific
- Some newer SwiftUI animations may have subtle differences
- File type icons may vary slightly

### Future Considerations

#### For macOS 16.0+ (Tahoe)
- Monitor beta releases for API changes
- Test with Xcode betas
- Update deprecated APIs as needed

#### API Monitoring
Keep track of:
- SwiftUI view lifecycle changes
- AppKit deprecations
- SQLite version updates
- Security framework changes

## Build Configuration

### Xcode Settings
```
MACOSX_DEPLOYMENT_TARGET = 12.0
SWIFT_VERSION = 5.0
ENABLE_HARDENED_RUNTIME = YES
ENABLE_APP_SANDBOX = YES
```

### Entitlements
- ✅ User Selected Files (Read/Write)
- ✅ File Access (Read/Write)
- ✅ Photo Library Access
- ✅ Documents Folder Access

## Troubleshooting

### Common Issues

#### "App can't be opened" on older macOS
- Ensure deployment target is set to 12.0
- Check code signing configuration
- Verify entitlements are correct

#### Database errors
- Check file permissions
- Verify storage path exists
- Ensure SQLite is properly initialized

#### Image insertion fails
- Check photo library permissions
- Verify security-scoped bookmarks
- Ensure images directory exists

## Update Strategy

### Version Updates
1. Test on beta releases
2. Update deprecated APIs
3. Add version checks for new features
4. Maintain backward compatibility

### Deprecation Handling
- Monitor Xcode warnings
- Replace deprecated APIs promptly
- Add version checks for new alternatives
- Keep fallbacks for older versions

## Resources

- [Apple Platform Availability](https://developer.apple.com/support/macos/)
- [SwiftUI Compatibility](https://developer.apple.com/documentation/swiftui)
- [SQLite Documentation](https://www.sqlite.org/docs.html)
- [App Sandbox Guide](https://developer.apple.com/library/archive/documentation/Security/Conceptual/AppSandboxDesignGuide/)

## Version History

- **v1.0** - Initial release
  - macOS 12.0+ support
  - Full feature compatibility
  - Future-ready architecture

---

**Last Updated**: January 12, 2026
**Minimum macOS**: 12.0 Monterey
**Tested on**: macOS 12.0, 13.0, 14.0, 15.0
