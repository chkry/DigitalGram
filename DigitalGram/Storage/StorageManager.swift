import Foundation
import SQLite3

class StorageManager {
    static let shared = StorageManager()
    
    private var db: OpaquePointer?
    private let fileManager = FileManager.default
    private var bookmarkedURL: URL?
    private let dbQueue = DispatchQueue(label: "com.digitalgram.database", qos: .userInitiated)
    private let dateFormatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        return formatter
    }()
    
    private var databasePath: String {
        let settings = AppSettings.shared
        
        // Try to resolve bookmark first
        if let bookmarkData = UserDefaults.standard.data(forKey: "StorageBookmark") {
            var isStale = false
            if let url = try? URL(resolvingBookmarkData: bookmarkData, options: .withSecurityScope, relativeTo: nil, bookmarkDataIsStale: &isStale) {
                if url.startAccessingSecurityScopedResource() {
                    bookmarkedURL = url
                    return url.appendingPathComponent(settings.currentDatabase).path
                }
            }
        }
        
        // Fallback to default path
        let storageDir = URL(fileURLWithPath: settings.storagePath)
        
        // Create directory if it doesn't exist
        if !fileManager.fileExists(atPath: storageDir.path) {
            try? fileManager.createDirectory(at: storageDir, withIntermediateDirectories: true)
        }
        
        return storageDir.appendingPathComponent(settings.currentDatabase).path
    }
    
    var imagesDirectory: URL {
        // Use bookmarked URL if available
        if let bookmarkedURL = bookmarkedURL {
            let imagesDir = bookmarkedURL.appendingPathComponent("images")
            
            // Create images directory if it doesn't exist
            if !fileManager.fileExists(atPath: imagesDir.path) {
                try? fileManager.createDirectory(at: imagesDir, withIntermediateDirectories: true)
            }
            
            return imagesDir
        }
        
        // Fallback to default path
        let settings = AppSettings.shared
        let storageDir = URL(fileURLWithPath: settings.storagePath)
        let imagesDir = storageDir.appendingPathComponent("images")
        
        // Create images directory if it doesn't exist
        if !fileManager.fileExists(atPath: imagesDir.path) {
            try? fileManager.createDirectory(at: imagesDir, withIntermediateDirectories: true)
        }
        
        return imagesDir
    }
    
    private init() {
        openDatabase()
        createTable()
    }
    
    func reopenDatabase() {
        closeDatabase()
        openDatabase()
        createTable()
    }
    
    private func openDatabase() {
        let dbPath = databasePath
        
        // Ensure parent directory exists
        let parentDir = (dbPath as NSString).deletingLastPathComponent
        if !fileManager.fileExists(atPath: parentDir) {
            do {
                try fileManager.createDirectory(atPath: parentDir, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print("Error creating database directory: \\(error.localizedDescription)")
            }
        }
        
        if sqlite3_open(dbPath, &db) != SQLITE_OK {
            #if DEBUG
            print("Error opening database at: \(dbPath)")
            if let errorMessage = sqlite3_errmsg(db) {
                print("SQLite Error: \(String(cString: errorMessage))")
            }
            #endif
        } else {
            #if DEBUG
            print("Database opened at: \(dbPath)")
            #endif
            // Enable foreign keys and other pragma settings for better compatibility
            sqlite3_exec(db, "PRAGMA foreign_keys = ON;", nil, nil, nil)
            sqlite3_exec(db, "PRAGMA journal_mode = WAL;", nil, nil, nil)
            // Performance optimizations
            sqlite3_exec(db, "PRAGMA synchronous = NORMAL;", nil, nil, nil)
            sqlite3_exec(db, "PRAGMA cache_size = -2000;", nil, nil, nil) // 2MB cache
            sqlite3_exec(db, "PRAGMA temp_store = MEMORY;", nil, nil, nil)
        }
    }
    
    private func closeDatabase() {
        if db != nil {
            // Checkpoint the WAL file before closing to ensure all data is written to main db
            sqlite3_exec(db, "PRAGMA wal_checkpoint(TRUNCATE);", nil, nil, nil)
            sqlite3_close(db)
            db = nil
        }
        
        // Stop accessing security-scoped resource
        if let url = bookmarkedURL {
            url.stopAccessingSecurityScopedResource()
            bookmarkedURL = nil
        }
    }
    
    private func createTable() {
        // Create android_metadata table
        let createMetadataQuery = """
        CREATE TABLE IF NOT EXISTS android_metadata (locale TEXT);
        """
        
        var statement: OpaquePointer?
        if sqlite3_exec(db, createMetadataQuery, nil, nil, nil) == SQLITE_OK {
            // Insert default locale if table is empty
            let checkQuery = "SELECT COUNT(*) FROM android_metadata;"
            if sqlite3_prepare_v2(db, checkQuery, -1, &statement, nil) == SQLITE_OK {
                if sqlite3_step(statement) == SQLITE_ROW {
                    let count = sqlite3_column_int(statement, 0)
                    if count == 0 {
                        sqlite3_exec(db, "INSERT INTO android_metadata VALUES ('en_US');", nil, nil, nil)
                    }
                }
            }
            sqlite3_finalize(statement)
        }
        
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
        """
        
        if sqlite3_exec(db, createTableQuery, nil, nil, nil) == SQLITE_OK {
            #if DEBUG
            print("Diary table created successfully")
            #endif
        } else {
            #if DEBUG
            if let errorMessage = sqlite3_errmsg(db) {
                print("Error creating diary table: \(String(cString: errorMessage))")
            }
            #endif
        }
        
        // Create index
        let createIndexQuery = "CREATE INDEX IF NOT EXISTS diary_idx_0 ON diary (year, month);"
        if sqlite3_exec(db, createIndexQuery, nil, nil, nil) == SQLITE_OK {
            #if DEBUG
            print("Index created successfully")
            #endif
        }
    }
    
    func saveEntry(_ entry: JournalEntry) {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: entry.date)
        let dateString = String(format: "%04d-%02d-%02d", components.year!, components.month!, components.day!)
        
        let insertQuery = """
        INSERT OR REPLACE INTO diary (date, year, month, day, content, created, updated)
        VALUES (?, ?, ?, ?, ?, ?, ?);
        """
        
        var statement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, insertQuery, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_text(statement, 1, (dateString as NSString).utf8String, -1, nil)
            sqlite3_bind_int(statement, 2, Int32(components.year!))
            sqlite3_bind_int(statement, 3, Int32(components.month!))
            sqlite3_bind_int(statement, 4, Int32(components.day!))
            sqlite3_bind_text(statement, 5, (entry.markdownContent as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 6, (entry.created as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 7, (entry.updated as NSString).utf8String, -1, nil)
            
            if sqlite3_step(statement) == SQLITE_DONE {
                #if DEBUG
                print("Entry saved successfully")
                #endif
                // Checkpoint WAL file periodically to write data to main database
                sqlite3_exec(db, "PRAGMA wal_checkpoint(PASSIVE);", nil, nil, nil)
            } else {
                #if DEBUG
                let errorMessage = String(cString: sqlite3_errmsg(db)!)
                print("Error saving entry: \(errorMessage)")
                #endif
            }
        }
        
        sqlite3_finalize(statement)
    }
    
    func loadEntries() -> [JournalEntry] {
        var entries: [JournalEntry] = []
        entries.reserveCapacity(100) // Pre-allocate for typical usage
        
        let query = "SELECT date, year, month, day, content, created, updated FROM diary ORDER BY date DESC;"
        var statement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
            while sqlite3_step(statement) == SQLITE_ROW {
                let dateString = String(cString: sqlite3_column_text(statement, 0))
                let year = sqlite3_column_int(statement, 1)
                let month = sqlite3_column_int(statement, 2)
                let day = sqlite3_column_int(statement, 3)
                let content = String(cString: sqlite3_column_text(statement, 4))
                let created = String(cString: sqlite3_column_text(statement, 5))
                let updated = sqlite3_column_text(statement, 6) != nil ? String(cString: sqlite3_column_text(statement, 6)) : created
                
                let entry = JournalEntry(dateString: dateString, year: Int(year), month: Int(month), day: Int(day), created: created, updated: updated, markdownContent: content)
                entries.append(entry)
            }
        }
        
        sqlite3_finalize(statement)
        #if DEBUG
        print("Loaded \(entries.count) entries from database")
        #endif
        return entries
    }
    
    func deleteEntry(id: String) {
        // id is now the date string in YYYY-MM-DD format
        let deleteQuery = "DELETE FROM diary WHERE date = ?;";
        var statement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, deleteQuery, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_text(statement, 1, (id as NSString).utf8String, -1, nil)
            
            if sqlite3_step(statement) == SQLITE_DONE {
                #if DEBUG
                print("Entry deleted successfully")
                #endif
            }
        }
        
        sqlite3_finalize(statement)
    }
    
    func getStorageLocation() -> String {
        return databasePath
    }
    
    
    deinit {
        closeDatabase()
        // Stop accessing security-scoped resource
        bookmarkedURL?.stopAccessingSecurityScopedResource()
    }
    
    // Add method to manually checkpoint WAL file
    func checkpointDatabase() {
        if db != nil {
            sqlite3_exec(db, "PRAGMA wal_checkpoint(TRUNCATE);", nil, nil, nil)
        }
    }
}
