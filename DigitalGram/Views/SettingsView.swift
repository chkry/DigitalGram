import SwiftUI
import SQLite3
import UniformTypeIdentifiers

enum AppTheme: String, CaseIterable, Codable {
    case dracula = "Dracula"
    case monokai = "Monokai"
    case tokyoNight = "Tokyo Night"
    case catppuccin = "Catppuccin Mocha"
    case synthwave = "Synthwave '84"
    case githubDark = "GitHub Dark"
    case nord = "Nord"
    case materialOcean = "Material Ocean"
    case gruvbox = "Gruvbox"
    case roseGarden = "Rose Garden"
    case earthyOlive = "Earthy Olive"
    
    var displayName: String {
        return self.rawValue
    }
    
    var lightBackground: Color {
        switch self {
        case .dracula: return Color(red: 0xF8/255, green: 0xF8/255, blue: 0xF2/255)
        case .monokai: return Color(red: 0xFC/255, green: 0xF4/255, blue: 0xDC/255)
        case .tokyoNight: return Color(red: 0xD5/255, green: 0xD6/255, blue: 0xDB/255)
        case .catppuccin: return Color(red: 0xEF/255, green: 0xF1/255, blue: 0xF5/255)
        case .synthwave: return Color(red: 0x2A/255, green: 0x2D/255, blue: 0x3E/255)
        case .githubDark: return Color(red: 0xFF/255, green: 0xFF/255, blue: 0xFF/255)
        case .nord: return Color(red: 0xEC/255, green: 0xEF/255, blue: 0xF4/255)
        case .materialOcean: return Color(red: 0xEE/255, green: 0xF1/255, blue: 0xF8/255)
        case .gruvbox: return Color(red: 0xFB/255, green: 0xF1/255, blue: 0xC7/255)
        case .roseGarden: return Color(red: 0xE2/255, green: 0xDD/255, blue: 0xD7/255)
        case .earthyOlive: return Color(red: 0xE2/255, green: 0xDD/255, blue: 0xD7/255)
        }
    }
    
    var lightCodeBackground: Color {
        switch self {
        case .dracula: return Color(red: 0xF5/255, green: 0xF5/255, blue: 0xF5/255)
        case .monokai: return Color(red: 0xF5/255, green: 0xE7/255, blue: 0xC3/255)
        case .tokyoNight: return Color(red: 0xC8/255, green: 0xCA/255, blue: 0xD0/255)
        case .catppuccin: return Color(red: 0xE6/255, green: 0xE9/255, blue: 0xEF/255)
        case .synthwave: return Color(red: 0x24/255, green: 0x28/255, blue: 0x36/255)
        case .githubDark: return Color(red: 0xF6/255, green: 0xF8/255, blue: 0xFA/255)
        case .nord: return Color(red: 0xE5/255, green: 0xE9/255, blue: 0xF0/255)
        case .materialOcean: return Color(red: 0xE4/255, green: 0xE7/255, blue: 0xF2/255)
        case .gruvbox: return Color(red: 0xEB/255, green: 0xDB/255, blue: 0xB2/255)
        case .roseGarden: return Color(red: 0xD8/255, green: 0xCE/255, blue: 0xC5/255)
        case .earthyOlive: return Color(red: 0xD8/255, green: 0xCE/255, blue: 0xC5/255)
        }
    }
    
    var lightLinkColor: Color {
        switch self {
        case .dracula: return Color(red: 0xFF/255, green: 0x79/255, blue: 0xC6/255)
        case .monokai: return Color(red: 0xF9/255, green: 0x26/255, blue: 0x72/255)
        case .tokyoNight: return Color(red: 0x7A/255, green: 0xA2/255, blue: 0xF8/255)
        case .catppuccin: return Color(red: 0x89/255, green: 0xB4/255, blue: 0xFA/255)
        case .synthwave: return Color(red: 0xFF/255, green: 0x71/255, blue: 0xCE/255)
        case .githubDark: return Color(red: 0x00/255, green: 0x5C/255, blue: 0xC5/255)
        case .nord: return Color(red: 0x88/255, green: 0xC0/255, blue: 0xD0/255)
        case .materialOcean: return Color(red: 0x82/255, green: 0xAA/255, blue: 0xFF/255)
        case .gruvbox: return Color(red: 0x45/255, green: 0x85/255, blue: 0x88/255)
        case .roseGarden: return Color(red: 0xD4/255, green: 0xB2/255, blue: 0xA7/255)
        case .earthyOlive: return Color(red: 0xA6/255, green: 0xB3/255, blue: 0x74/255)
        }
    }
    
    var lightAccent: Color {
        switch self {
        case .dracula: return Color(red: 0xBD/255, green: 0x93/255, blue: 0xF9/255)
        case .monokai: return Color(red: 0xFD/255, green: 0x97/255, blue: 0x1F/255)
        case .tokyoNight: return Color(red: 0x9E/255, green: 0xCE/255, blue: 0x6A/255)
        case .catppuccin: return Color(red: 0xF5/255, green: 0xC2/255, blue: 0xE7/255)
        case .synthwave: return Color(red: 0xFF/255, green: 0xDA/255, blue: 0x00/255)
        case .githubDark: return Color(red: 0x28/255, green: 0xA7/255, blue: 0x45/255)
        case .nord: return Color(red: 0xBF/255, green: 0x61/255, blue: 0x6A/255)
        case .materialOcean: return Color(red: 0xC7/255, green: 0x92/255, blue: 0xEA/255)
        case .gruvbox: return Color(red: 0xCC/255, green: 0x24/255, blue: 0x1D/255)
        case .roseGarden: return Color(red: 0xA3/255, green: 0x8F/255, blue: 0x85/255)
        case .earthyOlive: return Color(red: 0x3A/255, green: 0x2D/255, blue: 0x28/255)
        }
    }
    
    var darkBackground: Color {
        switch self {
        case .dracula: return Color(red: 0x28/255, green: 0x2A/255, blue: 0x36/255)
        case .monokai: return Color(red: 0x27/255, green: 0x28/255, blue: 0x22/255)
        case .tokyoNight: return Color(red: 0x1A/255, green: 0x1B/255, blue: 0x26/255)
        case .catppuccin: return Color(red: 0x1E/255, green: 0x1E/255, blue: 0x2E/255)
        case .synthwave: return Color(red: 0x26/255, green: 0x21/255, blue: 0x35/255)
        case .githubDark: return Color(red: 0x0D/255, green: 0x11/255, blue: 0x17/255)
        case .nord: return Color(red: 0x2E/255, green: 0x34/255, blue: 0x40/255)
        case .materialOcean: return Color(red: 0x0F/255, green: 0x11/255, blue: 0x18/255)
        case .gruvbox: return Color(red: 0x28/255, green: 0x28/255, blue: 0x28/255)
        case .roseGarden: return Color(red: 0x1A/255, green: 0x18/255, blue: 0x16/255)
        case .earthyOlive: return Color(red: 0x1A/255, green: 0x18/255, blue: 0x16/255)
        }
    }
    
    var darkCodeBackground: Color {
        switch self {
        case .dracula: return Color(red: 0x21/255, green: 0x22/255, blue: 0x2C/255)
        case .monokai: return Color(red: 0x1E/255, green: 0x1F/255, blue: 0x1C/255)
        case .tokyoNight: return Color(red: 0x16/255, green: 0x17/255, blue: 0x21/255)
        case .catppuccin: return Color(red: 0x18/255, green: 0x18/255, blue: 0x25/255)
        case .synthwave: return Color(red: 0x1F/255, green: 0x1B/255, blue: 0x2D/255)
        case .githubDark: return Color(red: 0x16/255, green: 0x1B/255, blue: 0x22/255)
        case .nord: return Color(red: 0x3B/255, green: 0x42/255, blue: 0x52/255)
        case .materialOcean: return Color(red: 0x17/255, green: 0x1C/255, blue: 0x28/255)
        case .gruvbox: return Color(red: 0x1D/255, green: 0x20/255, blue: 0x21/255)
        case .roseGarden: return Color(red: 0x2A/255, green: 0x28/255, blue: 0x26/255)
        case .earthyOlive: return Color(red: 0x2A/255, green: 0x28/255, blue: 0x26/255)
        }
    }
    
    var darkLinkColor: Color {
        switch self {
        case .dracula: return Color(red: 0xFF/255, green: 0x79/255, blue: 0xC6/255)
        case .monokai: return Color(red: 0xF9/255, green: 0x26/255, blue: 0x72/255)
        case .tokyoNight: return Color(red: 0x7A/255, green: 0xA2/255, blue: 0xF8/255)
        case .catppuccin: return Color(red: 0x89/255, green: 0xB4/255, blue: 0xFA/255)
        case .synthwave: return Color(red: 0xFF/255, green: 0x71/255, blue: 0xCE/255)
        case .githubDark: return Color(red: 0x58/255, green: 0xA6/255, blue: 0xFF/255)
        case .nord: return Color(red: 0x88/255, green: 0xC0/255, blue: 0xD0/255)
        case .materialOcean: return Color(red: 0x82/255, green: 0xAA/255, blue: 0xFF/255)
        case .gruvbox: return Color(red: 0x83/255, green: 0xA5/255, blue: 0x98/255)
        case .roseGarden: return Color(red: 0xE5/255, green: 0xC8/255, blue: 0xC0/255)
        case .earthyOlive: return Color(red: 0xB8/255, green: 0xC8/255, blue: 0x94/255)
        }
    }
    
    var darkAccent: Color {
        switch self {
        case .dracula: return Color(red: 0xBD/255, green: 0x93/255, blue: 0xF9/255)
        case .monokai: return Color(red: 0xFD/255, green: 0x97/255, blue: 0x1F/255)
        case .tokyoNight: return Color(red: 0x9E/255, green: 0xCE/255, blue: 0x6A/255)
        case .catppuccin: return Color(red: 0xF5/255, green: 0xC2/255, blue: 0xE7/255)
        case .synthwave: return Color(red: 0xFF/255, green: 0xDA/255, blue: 0x00/255)
        case .githubDark: return Color(red: 0x56/255, green: 0xD3/255, blue: 0x64/255)
        case .nord: return Color(red: 0xBF/255, green: 0x61/255, blue: 0x6A/255)
        case .materialOcean: return Color(red: 0xC7/255, green: 0x92/255, blue: 0xEA/255)
        case .gruvbox: return Color(red: 0xFB/255, green: 0x49/255, blue: 0x34/255)
        case .roseGarden: return Color(red: 0xC8/255, green: 0xB8/255, blue: 0xA8/255)
        case .earthyOlive: return Color(red: 0xD8/255, green: 0xCE/255, blue: 0xC5/255)
        }
    }
    
    var previewColors: [Color] {
        [lightBackground, lightCodeBackground, lightLinkColor, lightAccent]
    }
}

struct SettingsView: View {
    @State private var storagePath: String
    @State private var showingFolderPicker = false
    @State private var showingMigrationAlert = false
    @State private var migrationMessage = ""
    @State private var importExportMessage = ""
    @State private var showingImportExportAlert = false
    @State private var databaseOperationMessage = ""
    @State private var showingDatabaseOperationAlert = false
    @State private var availableDatabases: [String] = []
    @State private var selectedDatabase: String = "journal.db"
    @State private var showingDeleteConfirmation = false
    @State private var databaseToDelete: String = ""
    @State private var showingRenameDialog = false
    @State private var databaseToRename: String = ""
    @State private var newDatabaseName: String = ""
    @State private var showingCreateDialog = false
    @State private var createDatabaseName: String = ""
    @State private var showingImportDialog = false
    @AppStorage("appTheme") private var themeRawValue: String = AppTheme.earthyOlive.rawValue
    @Environment(\.dismiss) var dismiss
    
    var closeAction: (() -> Void)?
    
    init(closeAction: (() -> Void)? = nil) {
        self.closeAction = closeAction
        _storagePath = State(initialValue: AppSettings.shared.storagePath)
        _selectedDatabase = State(initialValue: AppSettings.shared.currentDatabase)
        _availableDatabases = State(initialValue: [])
    }
    
    var body: some View {
        VStack(spacing: 0) {
            settingsHeader
            Divider()
            
            ScrollView {
                VStack(spacing: 20) {
                    themeSection
                    storageSection
                    databaseSection
                    exportImportSection
                }
                .padding(.vertical)
            }
            
            Divider()
            
            // Footer
            HStack {
                Image(systemName: "info.circle")
                    .foregroundColor(.secondary)
                Text("Changes are applied immediately")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Spacer()
            }
            .padding()
            .background(Color(NSColor.windowBackgroundColor))
        }
        .frame(minWidth: 600, minHeight: 400)
        .onAppear {
            loadAvailableDatabases()
        }
        .alert("Migrate Data", isPresented: $showingMigrationAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(migrationMessage)
        }
        .alert("Import/Export", isPresented: $showingImportExportAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(importExportMessage)
        }
        .alert("Database Operation", isPresented: $showingDatabaseOperationAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(databaseOperationMessage)
        }
        .alert("Create New Database", isPresented: $showingCreateDialog) {
            TextField("Database Name", text: $createDatabaseName)
            Button("Cancel", role: .cancel) { }
            Button("Create") {
                createNewDatabase(createDatabaseName)
            }
        } message: {
            Text("Enter a name for the new database")
        }
        .alert("Delete Database", isPresented: $showingDeleteConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                deleteDatabase(databaseToDelete)
            }
        } message: {
            Text("Are you sure you want to delete '\(databaseToDelete)'? This action cannot be undone.")
        }
        .alert("Rename Database", isPresented: $showingRenameDialog) {
            TextField("New Name", text: $newDatabaseName)
            Button("Cancel", role: .cancel) { }
            Button("Rename") {
                renameDatabase(from: databaseToRename, to: newDatabaseName)
            }
        } message: {
            Text("Enter a new name for '\(databaseToRename)'")
        }
    }
    
    private var settingsHeader: some View {
        HStack {
            Text("Settings")
                .font(.title2)
                .bold()
            Spacer()
            Button("Done") {
                if let closeAction = closeAction {
                    closeAction()
                } else {
                    dismiss()
                }
            }
            .keyboardShortcut(.defaultAction)
        }
        .padding()
        .background(Color(NSColor.windowBackgroundColor))
    }
    
    private var themeSection: some View {
        GroupBox {
            VStack(alignment: .leading, spacing: 16) {
                Label("Theme", systemImage: "paintpalette")
                    .font(.headline)
                
                Text("Choose your color theme")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(AppTheme.allCases, id: \.self) { theme in
                            ThemeButton(theme: theme, isSelected: themeRawValue == theme.rawValue) {
                                themeRawValue = theme.rawValue
                            }
                        }
                    }
                }
                .frame(height: 280)
            }
            .padding(16)
        }
        .padding(.horizontal)
    }
    
    private var storageSection: some View {
        GroupBox {
            VStack(alignment: .leading, spacing: 16) {
                Label("Storage Location", systemImage: "folder")
                    .font(.headline)
                
                Text("Database and images are stored here:")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text(storagePath)
                            .font(.system(.body, design: .monospaced))
                            .foregroundColor(.primary)
                            .padding(8)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color(NSColor.textBackgroundColor))
                            .cornerRadius(4)
                    }
                    
                    HStack(spacing: 12) {
                        Button("Change Location...") {
                            chooseFolderPath()
                        }
                        
                        Button("Open in Finder") {
                            NSApp.activate(ignoringOtherApps: true)
                            NSWorkspace.shared.open(URL(fileURLWithPath: storagePath))
                        }
                        
                        Button("Reset to Default") {
                            resetToDefault()
                        }
                    }
                    .buttonStyle(.bordered)
                }
            }
            .padding(16)
        }
        .padding(.horizontal)
    }
    
    private var databaseSection: some View {
        GroupBox {
            VStack(alignment: .leading, spacing: 16) {
                Label("Databases", systemImage: "cylinder.split.1x2")
                    .font(.headline)
                
                Text("Manage multiple journal databases")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                HStack(alignment: .top, spacing: 12) {
                    // Database List
                    VStack(spacing: 0) {
                        List {
                            ForEach(availableDatabases, id: \.self) { dbName in
                                Button(action: {
                                    selectedDatabase = dbName
                                    switchDatabase(to: dbName)
                                }) {
                                    HStack {
                                        Image(systemName: dbName == selectedDatabase ? "cylinder.fill" : "cylinder")
                                            .foregroundColor(dbName == selectedDatabase ? .accentColor : .secondary)
                                            .font(.system(size: 14))
                                        
                                        Text(dbName)
                                            .font(.system(size: 13))
                                        
                                        Spacer()
                                    }
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .frame(height: 150)
                        .cornerRadius(6)
                    }
                    .frame(maxWidth: .infinity)
                    
                    // Add/Remove Buttons
                    VStack(spacing: 8) {
                        Button(action: {
                            createDatabaseName = ""
                            showingCreateDialog = true
                        }) {
                            Image(systemName: "plus")
                                .frame(width: 20, height: 20)
                        }
                        .buttonStyle(.borderless)
                        .help("Create new database")
                        
                        Button(action: {
                            importDatabase()
                        }) {
                            Image(systemName: "square.and.arrow.down")
                                .frame(width: 20, height: 20)
                        }
                        .buttonStyle(.borderless)
                        .help("Import existing database")
                        
                        Button(action: {
                            exportDatabase()
                        }) {
                            Image(systemName: "square.and.arrow.up")
                                .frame(width: 20, height: 20)
                        }
                        .buttonStyle(.borderless)
                        .disabled(selectedDatabase.isEmpty)
                        .help("Export selected database")
                        
                        Divider()
                            .frame(width: 20)
                        
                        Button(action: {
                            if !selectedDatabase.isEmpty {
                                databaseToDelete = selectedDatabase
                                showingDeleteConfirmation = true
                            }
                        }) {
                            Image(systemName: "minus")
                                .frame(width: 20, height: 20)
                        }
                        .buttonStyle(.borderless)
                        .disabled(selectedDatabase.isEmpty)
                        .help("Delete selected database")
                        
                        Divider()
                            .frame(width: 20)
                        
                        Button(action: {
                            if !selectedDatabase.isEmpty {
                                databaseToRename = selectedDatabase
                                newDatabaseName = selectedDatabase.replacingOccurrences(of: ".db", with: "").replacingOccurrences(of: ".sqlite", with: "")
                                showingRenameDialog = true
                            }
                        }) {
                            Image(systemName: "pencil")
                                .frame(width: 20, height: 20)
                        }
                        .buttonStyle(.borderless)
                        .disabled(selectedDatabase.isEmpty)
                        .help("Rename selected database")
                    }
                    .padding(.top, 4)
                }
                
                Text("Currently active: \(selectedDatabase)")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            .padding(16)
        }
        .padding(.horizontal)
    }
    
    private var exportImportSection: some View {
        VStack(spacing: 20) {
            // Import & Export
            GroupBox {
                VStack(alignment: .leading, spacing: 16) {
                    Label("Import & Export", systemImage: "arrow.up.arrow.down.circle")
                        .font(.headline)
                    
                    Text("Backup or restore your journal entries")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    VStack(spacing: 12) {
                        // Export Section
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Export")
                                .font(.subheadline)
                                .fontWeight(.medium)
                            
                            HStack(spacing: 12) {
                                Button(action: exportToCSV) {
                                    HStack {
                                        Image(systemName: "doc.text")
                                        Text("Export as CSV")
                                    }
                                    .frame(maxWidth: .infinity)
                                }
                                .buttonStyle(.bordered)
                                
                                Button(action: exportToExcel) {
                                    HStack {
                                        Image(systemName: "tablecells")
                                        Text("Export as Excel")
                                    }
                                    .frame(maxWidth: .infinity)
                                }
                                .buttonStyle(.bordered)
                            }
                        }
                        
                        Divider()
                        
                        // Import Section
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Import")
                                .font(.subheadline)
                                .fontWeight(.medium)
                            
                            Button(action: importFromCSV) {
                                HStack {
                                    Image(systemName: "square.and.arrow.down")
                                    Text("Import from CSV")
                                }
                                .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(.bordered)
                            .tint(.accentColor)
                            
                            Text("Import will merge entries. Existing entries with the same ID will be updated.")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                }
                .padding(16)
            }
            .padding(.horizontal)
            
            // Database Info
            GroupBox {
                VStack(alignment: .leading, spacing: 12) {
                    Label("Database Information", systemImage: "cylinder")
                        .font(.headline)
                    
                    VStack(spacing: 8) {
                        InfoRow(label: "Type:", value: "SQLite")
                        InfoRow(label: "Current DB:", value: selectedDatabase)
                        InfoRow(label: "Images:", value: "images/")
                        InfoRow(label: "Total DBs:", value: "\(availableDatabases.count)")
                    }
                    
                    Divider()
                        .padding(.vertical, 4)
                    
                    Text("All journal entries and images are stored locally on your Mac. No data is synced to the cloud.")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(16)
            }
            .padding(.horizontal)
            
            // About & Feedback
            GroupBox {
                VStack(alignment: .leading, spacing: 16) {
                    Label("About", systemImage: "info.circle")
                        .font(.headline)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Author")
                                .font(.subheadline)
                                .fontWeight(.medium)
                            Text("Chakradhar Reddy Pakala")
                                .font(.body)
                        }
                        
                        Divider()
                        
                        VStack(alignment: .leading, spacing: 8) {
                            HStack(spacing: 8) {
                                Image(systemName: "link.circle")
                                    .foregroundColor(.secondary)
                                    .frame(width: 20)
                                Button("github.com/chkry") {
                                    if let url = URL(string: "https://github.com/chkry") {
                                        NSWorkspace.shared.open(url)
                                    }
                                }
                                .buttonStyle(.plain)
                                .foregroundColor(.accentColor)
                            }
                            
                            HStack(spacing: 8) {
                                Image(systemName: "link.circle")
                                    .foregroundColor(.secondary)
                                    .frame(width: 20)
                                Button("linkedin.com/in/chkry") {
                                    if let url = URL(string: "https://linkedin.com/in/chkry") {
                                        NSWorkspace.shared.open(url)
                                    }
                                }
                                .buttonStyle(.plain)
                                .foregroundColor(.accentColor)
                            }
                            
                            HStack(spacing: 8) {
                                Image(systemName: "globe")
                                    .foregroundColor(.secondary)
                                    .frame(width: 20)
                                Button("www.chakrireddy.com") {
                                    if let url = URL(string: "https://www.chakrireddy.com") {
                                        NSWorkspace.shared.open(url)
                                    }
                                }
                                .buttonStyle(.plain)
                                .foregroundColor(.accentColor)
                            }
                        }
                        
                        Divider()
                        
                        VStack(alignment: .leading, spacing: 8) {
                            HStack(spacing: 4) {
                                Image(systemName: "envelope.circle.fill")
                                    .foregroundColor(.accentColor)
                                Text("Feedback & Feature Requests")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                            }
                            
                            HStack(spacing: 8) {
                                Text("Send your suggestions to:")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                Button("ChakradharReddyPakala@gmail.com") {
                                    if let url = URL(string: "mailto:ChakradharReddyPakala@gmail.com?subject=DigitalGram%20Feedback") {
                                        NSWorkspace.shared.open(url)
                                    }
                                }
                                .buttonStyle(.plain)
                                .foregroundColor(.accentColor)
                                .font(.caption)
                            }
                            
                            Text("Your feedback helps make DigitalGram better!")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                                .italic()
                        }
                    }
                }
                .padding(16)
            }
            .padding(.horizontal)
        }
    }
    
    private func chooseFolderPath() {
        let panel = NSOpenPanel()
        panel.canChooseFiles = false
        panel.canChooseDirectories = true
        panel.allowsMultipleSelection = false
        panel.canCreateDirectories = true
        panel.message = "Choose where to store your journal data"
        panel.prompt = "Select"
        
        // Get the current window to present as sheet modal
        if let window = NSApp.keyWindow {
            panel.beginSheetModal(for: window) { response in
                self.handleFolderSelection(panel: panel, response: response)
            }
        } else {
            // Fallback to runModal if no window available
            NSApp.activate(ignoringOtherApps: true)
            let response = panel.runModal()
            handleFolderSelection(panel: panel, response: response)
        }
    }
    
    private func handleFolderSelection(panel: NSOpenPanel, response: NSApplication.ModalResponse) {
        if response == .OK, let url = panel.url {
            // Start accessing security-scoped resource
            let gotAccess = url.startAccessingSecurityScopedResource()
            
            if gotAccess {
                // Store bookmark for persistent access
                do {
                    let bookmarkData = try url.bookmarkData(options: .withSecurityScope, includingResourceValuesForKeys: nil, relativeTo: nil)
                    UserDefaults.standard.set(bookmarkData, forKey: "StorageBookmark")
                } catch {
                    #if DEBUG
                    print("Failed to create bookmark: \(error)")
                    #endif
                }
            }
            
            storagePath = url.path
            saveSettings()
            
            // Don't stop accessing yet - we need it for migration
            if gotAccess {
                url.stopAccessingSecurityScopedResource()
            }
        }
    }
    
    private func resetToDefault() {
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        storagePath = documentsPath.appendingPathComponent("DigitalGram").path
        saveSettings()
    }
    
    private func saveSettings() {
        let oldPath = AppSettings.shared.storagePath
        let newPath = storagePath
        
        // If path changed, migrate the database and images
        if oldPath != newPath {
            let fileManager = FileManager.default
            let oldURL = URL(fileURLWithPath: oldPath)
            let newURL = URL(fileURLWithPath: newPath)
            
            do {
                // Create new directory if it doesn't exist
                if !fileManager.fileExists(atPath: newPath) {
                    try fileManager.createDirectory(at: newURL, withIntermediateDirectories: true)
                }
                
                var migratedDatabases = 0
                var errors: [String] = []
                
                // Migrate all .db files
                do {
                    let contents = try fileManager.contentsOfDirectory(at: oldURL, includingPropertiesForKeys: nil)
                    let dbFiles = contents.filter { $0.pathExtension == "db" }
                    
                    for dbFile in dbFiles {
                        let fileName = dbFile.lastPathComponent
                        let newDBPath = newURL.appendingPathComponent(fileName)
                        
                        if fileManager.fileExists(atPath: newDBPath.path) {
                            try fileManager.removeItem(at: newDBPath)
                        }
                        try fileManager.moveItem(at: dbFile, to: newDBPath)
                        migratedDatabases += 1
                    }
                } catch {
                    errors.append("Database migration: \(error.localizedDescription)")
                }
                
                // Move images directory
                let oldImagesPath = oldURL.appendingPathComponent("images")
                let newImagesPath = newURL.appendingPathComponent("images")
                
                do {
                    if fileManager.fileExists(atPath: oldImagesPath.path) {
                        if fileManager.fileExists(atPath: newImagesPath.path) {
                            try fileManager.removeItem(at: newImagesPath)
                        }
                        try fileManager.moveItem(at: oldImagesPath, to: newImagesPath)
                    }
                } catch {
                    errors.append("Images migration: \(error.localizedDescription)")
                }
                
                if errors.isEmpty {
                    migrationMessage = "Successfully moved \(migratedDatabases) database(s) and images to new location."
                } else {
                    migrationMessage = "Migration completed with errors:\n" + errors.joined(separator: "\n")
                }
                showingMigrationAlert = true
                
            } catch {
                migrationMessage = "Error migrating data: \(error.localizedDescription)\n\nOld location: \(oldPath)\nNew location: \(newPath)"
                showingMigrationAlert = true
                #if DEBUG
                print("Migration error: \(error)")
                #endif
            }
        }
        
        // Save new settings
        AppSettings.shared.storagePath = storagePath
        AppSettings.shared.save()
        
        // Reopen database with new path
        StorageManager.shared.reopenDatabase()
    }
    
    private func exportToCSV() {
        let storageManager = StorageManager.shared
        let entries = storageManager.loadEntries()
        
        let savePanel = NSSavePanel()
        // UTType.commaSeparatedText is available on macOS 11.0+
        if #available(macOS 11.0, *) {
            savePanel.allowedContentTypes = [.commaSeparatedText]
        } else {
            savePanel.allowedFileTypes = ["csv"]
        }
        let timestamp = ISO8601DateFormatter().string(from: Date())
        savePanel.nameFieldStringValue = "digitalgram_export_\(timestamp).csv"
        savePanel.message = "Export journal entries to CSV"
        
        if let window = NSApp.keyWindow {
            savePanel.beginSheetModal(for: window) { response in
                self.handleCSVExport(savePanel: savePanel, response: response, entries: entries)
            }
        } else {
            NSApp.activate(ignoringOtherApps: true)
            let response = savePanel.runModal()
            handleCSVExport(savePanel: savePanel, response: response, entries: entries)
        }
    }
    
    private func handleCSVExport(savePanel: NSSavePanel, response: NSApplication.ModalResponse, entries: [JournalEntry]) {
        if response == .OK, let url = savePanel.url {
            do {
                let csvContent = generateCSV(entries: entries)
                try csvContent.write(to: url, atomically: true, encoding: .utf8)
                importExportMessage = "Successfully exported \(entries.count) entries to CSV."
                showingImportExportAlert = true
            } catch {
                importExportMessage = "Export failed: \(error.localizedDescription)"
                showingImportExportAlert = true
            }
        }
    }
    
    private func exportToExcel() {
        let storageManager = StorageManager.shared
        let entries = storageManager.loadEntries()
        
        let savePanel = NSSavePanel()
        // Handle UTType for better compatibility
        if #available(macOS 11.0, *) {
            if let xlsxType = UTType(filenameExtension: "xlsx") {
                savePanel.allowedContentTypes = [xlsxType]
            }
        } else {
            savePanel.allowedFileTypes = ["xlsx"]
        }
        let timestamp = ISO8601DateFormatter().string(from: Date())
        savePanel.nameFieldStringValue = "digitalgram_export_\(timestamp).xlsx"
        savePanel.message = "Export journal entries to Excel"
        
        if let window = NSApp.keyWindow {
            savePanel.beginSheetModal(for: window) { response in
                self.handleExcelExport(savePanel: savePanel, response: response, entries: entries)
            }
        } else {
            NSApp.activate(ignoringOtherApps: true)
            let response = savePanel.runModal()
            handleExcelExport(savePanel: savePanel, response: response, entries: entries)
        }
    }
    
    private func handleExcelExport(savePanel: NSSavePanel, response: NSApplication.ModalResponse, entries: [JournalEntry]) {
        if response == .OK, let url = savePanel.url {
            do {
                let excelContent = generateExcel(entries: entries)
                try excelContent.write(to: url)
                importExportMessage = "Successfully exported \(entries.count) entries to Excel."
                showingImportExportAlert = true
            } catch {
                importExportMessage = "Export failed: \(error.localizedDescription)"
                showingImportExportAlert = true
            }
        }
    }
    
    private func importFromCSV() {
        let openPanel = NSOpenPanel()
        if #available(macOS 11.0, *) {
            openPanel.allowedContentTypes = [.commaSeparatedText]
        } else {
            openPanel.allowedFileTypes = ["csv"]
        }
        openPanel.allowsMultipleSelection = false
        openPanel.message = "Select a CSV file to import"
        openPanel.prompt = "Import"
        
        if let window = NSApp.keyWindow {
            openPanel.beginSheetModal(for: window) { response in
                self.handleCSVImport(openPanel: openPanel, response: response)
            }
        } else {
            NSApp.activate(ignoringOtherApps: true)
            let response = openPanel.runModal()
            handleCSVImport(openPanel: openPanel, response: response)
        }
    }
    
    private func handleCSVImport(openPanel: NSOpenPanel, response: NSApplication.ModalResponse) {
        if response == .OK, let url = openPanel.url {
            do {
                let csvContent = try String(contentsOf: url, encoding: .utf8)
                let importedCount = parseAndImportCSV(csvContent)
                importExportMessage = "Successfully imported \(importedCount) entries from CSV."
                showingImportExportAlert = true
            } catch {
                importExportMessage = "Import failed: \(error.localizedDescription)"
                showingImportExportAlert = true
            }
        }
    }
    
    private func generateCSV(entries: [JournalEntry]) -> String {
        var csv = "Date,Content,Created,Updated\n"
        
        for entry in entries.sorted(by: { $0.date > $1.date }) {
            let escapedContent = "\"\(entry.markdownContent.replacingOccurrences(of: "\"", with: "\"\""))\""
            
            csv += "\(entry.id),\(escapedContent),\(entry.created),\(entry.updated)\n"
        }
        
        return csv
    }
    
    private func generateExcel(entries: [JournalEntry]) -> Data {
        var xml = """
        <?xml version="1.0"?>
        <?mso-application progid="Excel.Sheet"?>
        <Workbook xmlns="urn:schemas-microsoft-com:office:spreadsheet"
         xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet">
         <Worksheet ss:Name="Diary">
          <Table>
           <Row>
            <Cell><Data ss:Type="String">Date</Data></Cell>
            <Cell><Data ss:Type="String">Content</Data></Cell>
            <Cell><Data ss:Type="String">Created</Data></Cell>
            <Cell><Data ss:Type="String">Updated</Data></Cell>
           </Row>
        """
        
        for entry in entries.sorted(by: { $0.date > $1.date }) {
            let escapedContent = entry.markdownContent
                .replacingOccurrences(of: "&", with: "&amp;")
                .replacingOccurrences(of: "<", with: "&lt;")
                .replacingOccurrences(of: ">", with: "&gt;")
            
            xml += """
               <Row>
                <Cell><Data ss:Type="String">\(entry.id)</Data></Cell>
                <Cell><Data ss:Type="String">\(escapedContent)</Data></Cell>
                <Cell><Data ss:Type="String">\(entry.created)</Data></Cell>
                <Cell><Data ss:Type="String">\(entry.updated)</Data></Cell>
               </Row>
            """
        }
        
        xml += """
          </Table>
         </Worksheet>
        </Workbook>
        """
        
        return xml.data(using: .utf8)!
    }
    
    private func parseAndImportCSV(_ csvContent: String) -> Int {
        let lines = csvContent.components(separatedBy: "\n")
        var importedCount = 0
        let storageManager = StorageManager.shared
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let iso8601Formatter = ISO8601DateFormatter()
        
        // Skip header row
        for line in lines.dropFirst() {
            guard !line.isEmpty else { continue }
            
            // Parse CSV line (handle quoted fields)
            let fields = parseCSVLine(line)
            guard fields.count >= 3 else { continue }
            
            // Expecting format: date,content,created[,updated]
            let dateString = fields[0]
            let content = fields[1]
            let created = fields.count > 2 ? fields[2] : iso8601Formatter.string(from: Date())
            
            // Parse date to get Date object
            guard let date = dateFormatter.date(from: dateString) else {
                continue
            }
            
            let entry = JournalEntry(
                date: date,
                markdownContent: content
            )
            
            storageManager.saveEntry(entry)
            importedCount += 1
        }
        
        return importedCount
    }
    
    private func parseCSVLine(_ line: String) -> [String] {
        var fields: [String] = []
        var currentField = ""
        var insideQuotes = false
        var i = line.startIndex
        
        while i < line.endIndex {
            let char = line[i]
            
            if char == "\"" {
                if insideQuotes && line.index(after: i) < line.endIndex && line[line.index(after: i)] == "\"" {
                    currentField.append("\"")
                    i = line.index(after: i)
                } else {
                    insideQuotes.toggle()
                }
            } else if char == "," && !insideQuotes {
                fields.append(currentField)
                currentField = ""
            } else {
                currentField.append(char)
            }
            
            i = line.index(after: i)
        }
        
        fields.append(currentField)
        return fields
    }
    
    private func loadAvailableDatabases() {
        let storageURL = URL(fileURLWithPath: storagePath)
        
        do {
            let contents = try FileManager.default.contentsOfDirectory(at: storageURL, includingPropertiesForKeys: nil)
            availableDatabases = contents
                .filter { $0.pathExtension == "db" || $0.pathExtension == "sqlite" }
                .map { $0.lastPathComponent }
                .sorted()
            
            // Ensure journal.db exists
            if !availableDatabases.contains("journal.db") {
                availableDatabases.append("journal.db")
                availableDatabases.sort()
            }
        } catch {
            print("Error loading databases: \(error)")
            availableDatabases = ["journal.db"]
        }
    }
    
    private func switchDatabase(to dbName: String) {
        AppSettings.shared.currentDatabase = dbName
        AppSettings.shared.save()
        StorageManager.shared.reopenDatabase()
        
        // Post notification to reload entries
        NotificationCenter.default.post(name: NSNotification.Name("DatabaseChanged"), object: nil)
    }
    
    private func sanitizeDatabaseName(_ name: String) -> String {
        // Remove .db or .sqlite extension if present
        var nameWithoutExtension = name
        if name.hasSuffix(".db") {
            nameWithoutExtension = String(name.dropLast(3))
        } else if name.hasSuffix(".sqlite") {
            nameWithoutExtension = String(name.dropLast(7))
        }
        
        // Return with .db extension (default)
        return "\(nameWithoutExtension).db"
    }

    
    private func createNewDatabase(_ name: String) {
        let baseName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        if baseName.isEmpty {
            databaseOperationMessage = "Database name cannot be empty."
            showingDatabaseOperationAlert = true
            return
        }
        
        // Use sanitized name without timestamp
        let dbName = sanitizeDatabaseName(baseName)
        
        // Check if already exists
        if availableDatabases.contains(dbName) {
            databaseOperationMessage = "Database '\(dbName)' already exists."
            showingDatabaseOperationAlert = true
            return
        }
        
        let storageURL = URL(fileURLWithPath: storagePath)
        let dbPath = storageURL.appendingPathComponent(dbName).path
        
        // Create empty database
        var db: OpaquePointer?
        if sqlite3_open(dbPath, &db) == SQLITE_OK {
            // Create android_metadata table
            let createMetadataQuery = """
            CREATE TABLE IF NOT EXISTS android_metadata (locale TEXT);
            INSERT INTO android_metadata VALUES ('en_US');
            """
            sqlite3_exec(db, createMetadataQuery, nil, nil, nil)
            
            // Create diary table
            let createTableQuery = """
            CREATE TABLE IF NOT EXISTS diary (
                date TEXT NOT NULL PRIMARY KEY,
                year INTEGER NOT NULL,
                month INTEGER NOT NULL,
                day INTEGER NOT NULL,
                content TEXT NOT NULL,
                created TEXT NOT NULL,
                updated TEXT
            );
            CREATE INDEX IF NOT EXISTS diary_idx_0 ON diary (year, month);
            """
            
            var statement: OpaquePointer?
            if sqlite3_prepare_v2(db, createTableQuery, -1, &statement, nil) == SQLITE_OK {
                sqlite3_step(statement)
            }
            sqlite3_finalize(statement)
            sqlite3_close(db)
            
            loadAvailableDatabases()
            selectedDatabase = dbName
            switchDatabase(to: dbName)
            
            databaseOperationMessage = "Database '\(dbName)' created successfully."
            showingDatabaseOperationAlert = true
        } else {
            databaseOperationMessage = "Failed to create database '\(dbName)'."
            showingDatabaseOperationAlert = true
        }
    }
    
    private func importDatabase() {
        let panel = NSOpenPanel()
        panel.canChooseFiles = true
        panel.canChooseDirectories = false
        panel.allowsMultipleSelection = false
        panel.message = "Select a database file to import"
        panel.prompt = "Import"
        
        // Filter for .db and .sqlite files
        if #available(macOS 11.0, *) {
            var allowedTypes: [UTType] = []
            if let dbType = UTType(filenameExtension: "db") {
                allowedTypes.append(dbType)
            }
            if let sqliteType = UTType(filenameExtension: "sqlite") {
                allowedTypes.append(sqliteType)
            }
            if !allowedTypes.isEmpty {
                panel.allowedContentTypes = allowedTypes
            }
        } else {
            panel.allowedFileTypes = ["db", "sqlite"]
        }
        
        if let window = NSApp.keyWindow {
            panel.beginSheetModal(for: window) { response in
                self.handleDatabaseImport(panel: panel, response: response)
            }
        } else {
            let response = panel.runModal()
            handleDatabaseImport(panel: panel, response: response)
        }
    }
    
    private func exportDatabase() {
        guard !selectedDatabase.isEmpty else { return }
        
        let panel = NSSavePanel()
        panel.canCreateDirectories = true
        panel.message = "Export '\(selectedDatabase)' to a new location"
        panel.prompt = "Export"
        panel.nameFieldStringValue = selectedDatabase
        
        // Filter for .db and .sqlite files
        if #available(macOS 11.0, *) {
            var allowedTypes: [UTType] = []
            if let dbType = UTType(filenameExtension: "db") {
                allowedTypes.append(dbType)
            }
            if let sqliteType = UTType(filenameExtension: "sqlite") {
                allowedTypes.append(sqliteType)
            }
            if !allowedTypes.isEmpty {
                panel.allowedContentTypes = allowedTypes
            }
        } else {
            panel.allowedFileTypes = ["db", "sqlite"]
        }
        
        // Ensure panel appears on top
        if let window = NSApp.keyWindow {
            panel.beginSheetModal(for: window) { response in
                self.handleDatabaseExport(panel: panel, response: response)
            }
        } else {
            // Activate app to bring window to front
            NSApp.activate(ignoringOtherApps: true)
            let response = panel.runModal()
            handleDatabaseExport(panel: panel, response: response)
        }
    }
    
    private func handleDatabaseImport(panel: NSOpenPanel, response: NSApplication.ModalResponse) {
        guard response == .OK, let sourceURL = panel.url else { return }
        
        let fileManager = FileManager.default
        let storageURL = URL(fileURLWithPath: storagePath)
        
        // Use the original filename without adding timestamp
        let fileName = sourceURL.lastPathComponent
        let destinationURL = storageURL.appendingPathComponent(fileName)
        
        do {
            // Start accessing security-scoped resource
            let sourceAccess = sourceURL.startAccessingSecurityScopedResource()
            defer {
                if sourceAccess {
                    sourceURL.stopAccessingSecurityScopedResource()
                }
            }
            
            // Check if database with same name already exists
            if fileManager.fileExists(atPath: destinationURL.path) {
                // Merge databases instead of replacing
                let result = mergeDatabases(sourceURL: sourceURL, destinationURL: destinationURL)
                databaseOperationMessage = result.message
                showingDatabaseOperationAlert = true
                
                // Refresh if needed
                if result.success {
                    NotificationCenter.default.post(name: NSNotification.Name("DatabaseChanged"), object: nil)
                }
            } else {
                // Copy the database file (no conflict)
                try fileManager.copyItem(at: sourceURL, to: destinationURL)
                
                // Refresh the database list
                loadAvailableDatabases()
                
                databaseOperationMessage = "Database '\(fileName)' imported successfully."
                showingDatabaseOperationAlert = true
            }
            
        } catch {
            databaseOperationMessage = "Failed to import database: \(error.localizedDescription)"
            showingDatabaseOperationAlert = true
        }
    }
    
    private func mergeDatabases(sourceURL: URL, destinationURL: URL) -> (success: Bool, message: String) {
        var sourceDB: OpaquePointer?
        var destDB: OpaquePointer?
        
        var imported = 0
        var skipped = 0
        var merged = 0
        
        // Open source database
        guard sqlite3_open(sourceURL.path, &sourceDB) == SQLITE_OK else {
            return (false, "Failed to open source database")
        }
        defer { sqlite3_close(sourceDB) }
        
        // Open destination database
        guard sqlite3_open(destinationURL.path, &destDB) == SQLITE_OK else {
            return (false, "Failed to open destination database")
        }
        defer { sqlite3_close(destDB) }
        
        // Read all entries from source database
        let query = "SELECT date, year, month, day, content, created, updated FROM diary ORDER BY date;"
        var statement: OpaquePointer?
        
        guard sqlite3_prepare_v2(sourceDB, query, -1, &statement, nil) == SQLITE_OK else {
            return (false, "Failed to read source database")
        }
        defer { sqlite3_finalize(statement) }
        
        while sqlite3_step(statement) == SQLITE_ROW {
            let date = String(cString: sqlite3_column_text(statement, 0))
            let year = sqlite3_column_int(statement, 1)
            let month = sqlite3_column_int(statement, 2)
            let day = sqlite3_column_int(statement, 3)
            let content = String(cString: sqlite3_column_text(statement, 4))
            let created = String(cString: sqlite3_column_text(statement, 5))
            let updated = sqlite3_column_text(statement, 6) != nil ? String(cString: sqlite3_column_text(statement, 6)) : created
            
            // Check if entry exists in destination
            let checkQuery = "SELECT content FROM diary WHERE date = ?;"
            var checkStmt: OpaquePointer?
            
            if sqlite3_prepare_v2(destDB, checkQuery, -1, &checkStmt, nil) == SQLITE_OK {
                sqlite3_bind_text(checkStmt, 1, (date as NSString).utf8String, -1, nil)
                
                if sqlite3_step(checkStmt) == SQLITE_ROW {
                    // Entry exists, check if content is different
                    let existingContent = String(cString: sqlite3_column_text(checkStmt, 0))
                    
                    if existingContent == content {
                        // Same content, skip
                        skipped += 1
                    } else {
                        // Different content, merge by appending
                        let separator = "\n\n---\n\n"
                        let mergedContent = existingContent + separator + content
                        
                        let updateQuery = "UPDATE diary SET content = ?, updated = ? WHERE date = ?;"
                        var updateStmt: OpaquePointer?
                        
                        if sqlite3_prepare_v2(destDB, updateQuery, -1, &updateStmt, nil) == SQLITE_OK {
                            sqlite3_bind_text(updateStmt, 1, (mergedContent as NSString).utf8String, -1, nil)
                            sqlite3_bind_text(updateStmt, 2, (updated as NSString).utf8String, -1, nil)
                            sqlite3_bind_text(updateStmt, 3, (date as NSString).utf8String, -1, nil)
                            
                            if sqlite3_step(updateStmt) == SQLITE_DONE {
                                merged += 1
                            }
                        }
                        sqlite3_finalize(updateStmt)
                    }
                } else {
                    // Entry doesn't exist, insert it
                    let insertQuery = "INSERT INTO diary (date, year, month, day, content, created, updated) VALUES (?, ?, ?, ?, ?, ?, ?);"
                    var insertStmt: OpaquePointer?
                    
                    if sqlite3_prepare_v2(destDB, insertQuery, -1, &insertStmt, nil) == SQLITE_OK {
                        sqlite3_bind_text(insertStmt, 1, (date as NSString).utf8String, -1, nil)
                        sqlite3_bind_int(insertStmt, 2, year)
                        sqlite3_bind_int(insertStmt, 3, month)
                        sqlite3_bind_int(insertStmt, 4, day)
                        sqlite3_bind_text(insertStmt, 5, (content as NSString).utf8String, -1, nil)
                        sqlite3_bind_text(insertStmt, 6, (created as NSString).utf8String, -1, nil)
                        sqlite3_bind_text(insertStmt, 7, (updated as NSString).utf8String, -1, nil)
                        
                        if sqlite3_step(insertStmt) == SQLITE_DONE {
                            imported += 1
                        }
                    }
                    sqlite3_finalize(insertStmt)
                }
            }
            sqlite3_finalize(checkStmt)
        }
        
        let message = "Merged: \(imported) new, \(merged) updated, \(skipped) skipped"
        return (true, message)
    }
    
    private func handleDatabaseExport(panel: NSSavePanel, response: NSApplication.ModalResponse) {
        guard response == .OK, let destinationURL = panel.url else { return }
        
        let fileManager = FileManager.default
        let storageURL = URL(fileURLWithPath: storagePath)
        let sourceURL = storageURL.appendingPathComponent(selectedDatabase)
        
        do {
            // Start accessing security-scoped resource for destination
            let destAccess = destinationURL.startAccessingSecurityScopedResource()
            defer {
                if destAccess {
                    destinationURL.stopAccessingSecurityScopedResource()
                }
            }
            
            // Remove existing file if it exists
            if fileManager.fileExists(atPath: destinationURL.path) {
                try fileManager.removeItem(at: destinationURL)
            }
            
            // Copy the database file to selected location
            try fileManager.copyItem(at: sourceURL, to: destinationURL)
            
            databaseOperationMessage = "Database '\(selectedDatabase)' exported successfully to:\n\(destinationURL.path)"
            showingDatabaseOperationAlert = true
            
        } catch {
            databaseOperationMessage = "Failed to export database: \(error.localizedDescription)"
            showingDatabaseOperationAlert = true
        }
    }
    
    private func deleteDatabase(_ dbName: String) {
        let storageURL = URL(fileURLWithPath: storagePath)
        let dbPath = storageURL.appendingPathComponent(dbName)
        
        do {
            try FileManager.default.removeItem(at: dbPath)
            
            loadAvailableDatabases()
            
            // If we deleted the current database or all databases, switch to journal.db
            if selectedDatabase == dbName || availableDatabases.isEmpty {
                // Create journal.db if it doesn't exist
                if !availableDatabases.contains("journal.db") {
                    createNewDatabase("journal")
                }
                selectedDatabase = "journal.db"
                switchDatabase(to: "journal.db")
            }
            
            databaseOperationMessage = "Database '\(dbName)' deleted successfully."
            showingDatabaseOperationAlert = true
        } catch {
            databaseOperationMessage = "Failed to delete database: \(error.localizedDescription)"
            showingDatabaseOperationAlert = true
        }
    }
    
    private func renameDatabase(from oldName: String, to newName: String) {
        var dbName = newName.trimmingCharacters(in: .whitespacesAndNewlines)
        if dbName.isEmpty {
            databaseOperationMessage = "Database name cannot be empty."
            showingDatabaseOperationAlert = true
            return
        }
        
// Add .db extension if not present (unless it already has .sqlite)
        if !dbName.hasSuffix(".db") && !dbName.hasSuffix(".sqlite") {
            dbName += ".db"
        }
        
        // Check if target name already exists
        if availableDatabases.contains(dbName) && dbName != oldName {
            databaseOperationMessage = "Database '\(dbName)' already exists."
            showingDatabaseOperationAlert = true
            return
        }
        
        let storageURL = URL(fileURLWithPath: storagePath)
        let oldPath = storageURL.appendingPathComponent(oldName)
        let newPath = storageURL.appendingPathComponent(dbName)
        
        do {
            try FileManager.default.moveItem(at: oldPath, to: newPath)
            
            // Update selected database if we renamed the current one
            if selectedDatabase == oldName {
                selectedDatabase = dbName
                AppSettings.shared.currentDatabase = dbName
                AppSettings.shared.save()
            }
            
            loadAvailableDatabases()
            StorageManager.shared.reopenDatabase()
            
            databaseOperationMessage = "Database renamed to '\(dbName)' successfully."
            showingDatabaseOperationAlert = true
        } catch {
            databaseOperationMessage = "Failed to rename database: \(error.localizedDescription)"
            showingDatabaseOperationAlert = true
        }
    }
}

struct InfoRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .foregroundColor(.secondary)
                .frame(width: 110, alignment: .leading)
            Text(value)
                .font(.system(.body, design: .monospaced))
            Spacer()
        }
    }
}

struct ThemeButton: View {
    let theme: AppTheme
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                HStack(spacing: 4) {
                    ForEach(0..<4, id: \.self) { index in
                        RoundedRectangle(cornerRadius: 4)
                            .fill(theme.previewColors[index])
                            .frame(width: 24, height: 24)
                    }
                }
                
                Text(theme.displayName)
                    .font(.body)
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.accentColor)
                }
            }
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(isSelected ? Color.accentColor.opacity(0.1) : Color.clear)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(isSelected ? Color.accentColor : Color.gray.opacity(0.3), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    SettingsView()
}
