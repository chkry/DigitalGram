import SwiftUI
import SQLite3
import UniformTypeIdentifiers

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
            // Header
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
            
            Divider()
            
            ScrollView {
                VStack(spacing: 20) {
                    // Storage Settings
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
                    
                    // Database Management
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
                                                    
                                                    VStack(alignment: .leading, spacing: 2) {
                                                        Text(extractBaseName(from: dbName))
                                                            .font(.system(size: 13))
                                                        if let timestamp = extractTimestamp(from: dbName) {
                                                            Text(timestamp)
                                                                .font(.system(size: 10))
                                                                .foregroundColor(.secondary)
                                                        }
                                                    }
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
                                        if selectedDatabase != "journal.db" && !selectedDatabase.isEmpty {
                                            databaseToDelete = selectedDatabase
                                            showingDeleteConfirmation = true
                                        }
                                    }) {
                                        Image(systemName: "minus")
                                            .frame(width: 20, height: 20)
                                    }
                                    .buttonStyle(.borderless)
                                    .disabled(selectedDatabase == "journal.db" || selectedDatabase.isEmpty)
                                    .help("Delete selected database")
                                    
                                    Divider()
                                        .frame(width: 20)
                                    
                                    Button(action: {
                                        if !selectedDatabase.isEmpty {
                                            databaseToRename = selectedDatabase
                                            newDatabaseName = selectedDatabase.replacingOccurrences(of: ".db", with: "")
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
        .frame(width: 600, height: 700)
        .onAppear {
            loadAvailableDatabases()
            
            // Listen for database renames
            NotificationCenter.default.addObserver(
                forName: NSNotification.Name("DatabaseRenamed"),
                object: nil,
                queue: .main
            ) { notification in
                if let newName = notification.object as? String {
                    self.selectedDatabase = newName
                    self.loadAvailableDatabases()
                }
            }
        }
        .alert("Database Migration", isPresented: $showingMigrationAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(migrationMessage)
        }
        .alert("Import/Export", isPresented: $showingImportExportAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(importExportMessage)
        }
        .alert("Database", isPresented: $showingDatabaseOperationAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(databaseOperationMessage)
        }
        .alert("Delete Database", isPresented: $showingDeleteConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                deleteDatabase(databaseToDelete)
            }
        } message: {
            Text("Are you sure you want to delete '\(databaseToDelete)'?\n\nThis action cannot be undone. All journal entries in this database will be permanently deleted.")
        }
        .alert("Rename Database", isPresented: $showingRenameDialog) {
            TextField("New name", text: $newDatabaseName)
            Button("Cancel", role: .cancel) { }
            Button("Rename") {
                renameDatabase(from: databaseToRename, to: newDatabaseName)
            }
        } message: {
            Text("Enter a new name for '\(databaseToRename)'")
        }
        .alert("Create Database", isPresented: $showingCreateDialog) {
            TextField("Database name", text: $createDatabaseName)
            Button("Cancel", role: .cancel) { }
            Button("Create") {
                createNewDatabase(createDatabaseName)
            }
        } message: {
            Text("Enter a name for the new database")
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
        var csv = "Entry ID,Date,Timestamp,Markdown Content\n"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        
        let timestampFormatter = DateFormatter()
        timestampFormatter.dateStyle = .medium
        timestampFormatter.timeStyle = .medium
        
        for entry in entries.sorted(by: { $0.timestamp > $1.timestamp }) {
            let dateString = dateFormatter.string(from: entry.date)
            let timestampString = timestampFormatter.string(from: entry.timestamp)
            let escapedContent = "\"\(entry.markdownContent.replacingOccurrences(of: "\"", with: "\"\""))\""
            
            csv += "\(entry.id),\(dateString),\(timestampString),\(escapedContent)\n"
        }
        
        return csv
    }
    
    private func generateExcel(entries: [JournalEntry]) -> Data {
        var xml = """
        <?xml version="1.0"?>
        <?mso-application progid="Excel.Sheet"?>
        <Workbook xmlns="urn:schemas-microsoft-com:office:spreadsheet"
         xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet">
         <Worksheet ss:Name="Journal Entries">
          <Table>
           <Row>
            <Cell><Data ss:Type="String">Entry ID</Data></Cell>
            <Cell><Data ss:Type="String">Date</Data></Cell>
            <Cell><Data ss:Type="String">Timestamp</Data></Cell>
            <Cell><Data ss:Type="String">Markdown Content</Data></Cell>
           </Row>
        """
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        
        let timestampFormatter = DateFormatter()
        timestampFormatter.dateStyle = .medium
        timestampFormatter.timeStyle = .medium
        
        for entry in entries.sorted(by: { $0.timestamp > $1.timestamp }) {
            let dateString = dateFormatter.string(from: entry.date)
            let timestampString = timestampFormatter.string(from: entry.timestamp)
            let escapedContent = entry.markdownContent
                .replacingOccurrences(of: "&", with: "&amp;")
                .replacingOccurrences(of: "<", with: "&lt;")
                .replacingOccurrences(of: ">", with: "&gt;")
            
            xml += """
               <Row>
                <Cell><Data ss:Type="String">\(entry.id)</Data></Cell>
                <Cell><Data ss:Type="String">\(dateString)</Data></Cell>
                <Cell><Data ss:Type="String">\(timestampString)</Data></Cell>
                <Cell><Data ss:Type="String">\(escapedContent)</Data></Cell>
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
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        
        let timestampFormatter = DateFormatter()
        timestampFormatter.dateStyle = .medium
        timestampFormatter.timeStyle = .medium
        
        // Skip header row
        for line in lines.dropFirst() {
            guard !line.isEmpty else { continue }
            
            // Parse CSV line (handle quoted fields)
            let fields = parseCSVLine(line)
            guard fields.count >= 4 else { continue }
            
            let id = fields[0]
            guard let date = dateFormatter.date(from: fields[1]),
                  let timestamp = timestampFormatter.date(from: fields[2]) else {
                continue
            }
            
            let markdownContent = fields[3]
            
            let entry = JournalEntry(
                id: id,
                date: date,
                timestamp: timestamp,
                markdownContent: markdownContent
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
                .filter { $0.pathExtension == "db" }
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
    
    private func generateTimestampedName(baseName: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd_HH-mm-ss"
        let timestamp = dateFormatter.string(from: Date())
        
        // Remove .db extension if present
        let nameWithoutExtension = baseName.hasSuffix(".db") ? String(baseName.dropLast(3)) : baseName
        
        return "\(nameWithoutExtension)_\(timestamp).db"
    }
    
    private func extractBaseName(from fileName: String) -> String {
        // Remove .db extension
        let nameWithoutExtension = fileName.hasSuffix(".db") ? String(fileName.dropLast(3)) : fileName
        
        // Remove timestamp pattern _YYYY-MM-DD_HH-MM-SS if present
        let pattern = "_\\d{4}-\\d{2}-\\d{2}_\\d{2}-\\d{2}-\\d{2}$"
        if let regex = try? NSRegularExpression(pattern: pattern),
           let match = regex.firstMatch(in: nameWithoutExtension, range: NSRange(nameWithoutExtension.startIndex..., in: nameWithoutExtension)) {
            let range = Range(match.range, in: nameWithoutExtension)
            if let range = range {
                return String(nameWithoutExtension[..<range.lowerBound])
            }
        }
        
        return nameWithoutExtension
    }
    
    private func extractTimestamp(from fileName: String) -> String? {
        let nameWithoutExtension = fileName.hasSuffix(".db") ? String(fileName.dropLast(3)) : fileName
        let pattern = "_(\\d{4})-(\\d{2})-(\\d{2})_(\\d{2})-(\\d{2})-(\\d{2})$"
        
        if let regex = try? NSRegularExpression(pattern: pattern),
           let match = regex.firstMatch(in: nameWithoutExtension, range: NSRange(nameWithoutExtension.startIndex..., in: nameWithoutExtension)) {
            let range = Range(match.range, in: nameWithoutExtension)
            if let range = range {
                let timestampStr = String(nameWithoutExtension[range])
                // Format: _YYYY-MM-DD_HH-MM-SS -> "Updated: DD/MM/YYYY HH:MM"
                let components = timestampStr.dropFirst().split(separator: "_")
                if components.count == 2 {
                    let dateParts = components[0].split(separator: "-")
                    let timeParts = components[1].split(separator: "-")
                    if dateParts.count == 3 && timeParts.count == 3 {
                        return "Updated: \(dateParts[2])/\(dateParts[1])/\(dateParts[0]) \(timeParts[0]):\(timeParts[1])"
                    }
                }
            }
        }
        
        return nil
    }
    
    private func createNewDatabase(_ name: String) {
        let baseName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        if baseName.isEmpty {
            databaseOperationMessage = "Database name cannot be empty."
            showingDatabaseOperationAlert = true
            return
        }
        
        // Generate timestamped filename
        let dbName = generateTimestampedName(baseName: baseName)
        
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
            let createTableQuery = """
            CREATE TABLE IF NOT EXISTS journal_entries (
                id TEXT PRIMARY KEY,
                date TEXT NOT NULL,
                timestamp TEXT NOT NULL,
                markdown_content TEXT NOT NULL
            );
            CREATE INDEX IF NOT EXISTS idx_date ON journal_entries(date);
            CREATE INDEX IF NOT EXISTS idx_timestamp ON journal_entries(timestamp);
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
        
        // Filter for .db files
        if #available(macOS 11.0, *) {
            if let dbType = UTType(filenameExtension: "db") {
                panel.allowedContentTypes = [dbType]
            }
        } else {
            panel.allowedFileTypes = ["db"]
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
    
    private func handleDatabaseImport(panel: NSOpenPanel, response: NSApplication.ModalResponse) {
        guard response == .OK, let sourceURL = panel.url else { return }
        
        let fileManager = FileManager.default
        let storageURL = URL(fileURLWithPath: storagePath)
        
        // Get base name from original file and add timestamp
        let originalFileName = sourceURL.lastPathComponent
        let baseName = extractBaseName(from: originalFileName)
        let fileName = generateTimestampedName(baseName: baseName)
        let destinationURL = storageURL.appendingPathComponent(fileName)
        
        do {
            // Start accessing security-scoped resource
            let sourceAccess = sourceURL.startAccessingSecurityScopedResource()
            defer {
                if sourceAccess {
                    sourceURL.stopAccessingSecurityScopedResource()
                }
            }
            
            // Copy the database file
            try fileManager.copyItem(at: sourceURL, to: destinationURL)
            
            // Refresh the database list
            loadAvailableDatabases()
            
            databaseOperationMessage = "Database '\(fileName)' imported successfully."
            showingDatabaseOperationAlert = true
            
        } catch {
            databaseOperationMessage = "Failed to import database: \(error.localizedDescription)"
            showingDatabaseOperationAlert = true
        }
    }
    
    private func deleteDatabase(_ dbName: String) {
        if dbName == "journal.db" {
            databaseOperationMessage = "Cannot delete the default database."
            showingDatabaseOperationAlert = true
            return
        }
        
        let storageURL = URL(fileURLWithPath: storagePath)
        let dbPath = storageURL.appendingPathComponent(dbName)
        
        do {
            try FileManager.default.removeItem(at: dbPath)
            
            // Switch to journal.db if we deleted the current database
            if selectedDatabase == dbName {
                selectedDatabase = "journal.db"
                switchDatabase(to: "journal.db")
            }
            
            loadAvailableDatabases()
            
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
        
        // Add .db extension if not present
        if !dbName.hasSuffix(".db") {
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

#Preview {
    SettingsView()
}
