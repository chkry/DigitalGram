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
            if sqlite3_step(statement) == SQLITE_DONE {
                #if DEBUG
                print("Table created successfully")
                #endif
            }
        } else {
            #if DEBUG
            let errorMessage = String(cString: sqlite3_errmsg(db)!)
            print("Error creating table: \(errorMessage)")
            #endif
        }
        
        sqlite3_finalize(statement)
    }
    
    func saveEntry(_ entry: JournalEntry) {
        let dateString = dateFormatter.string(from: entry.date)
        let timestampString = dateFormatter.string(from: entry.timestamp)
        
        let insertQuery = """
        INSERT OR REPLACE INTO journal_entries (id, date, timestamp, markdown_content)
        VALUES (?, ?, ?, ?);
        """
        
        var statement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, insertQuery, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_text(statement, 1, (entry.id as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 2, (dateString as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 3, (timestampString as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 4, (entry.markdownContent as NSString).utf8String, -1, nil)
            
            if sqlite3_step(statement) == SQLITE_DONE {
                #if DEBUG
                print("Entry saved successfully")
                #endif
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
        
        let query = "SELECT id, date, timestamp, markdown_content FROM journal_entries ORDER BY timestamp DESC;"
        var statement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
            while sqlite3_step(statement) == SQLITE_ROW {
                let id = String(cString: sqlite3_column_text(statement, 0))
                let date = String(cString: sqlite3_column_text(statement, 1))
                let timestamp = String(cString: sqlite3_column_text(statement, 2))
                let content = String(cString: sqlite3_column_text(statement, 3))
                
                let entry = JournalEntry(id: id, dateString: date, timestampString: timestamp, markdownContent: content)
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
        let deleteQuery = "DELETE FROM journal_entries WHERE id = ?;"
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
}
