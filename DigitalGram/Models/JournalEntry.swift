import Foundation

struct JournalEntry: Identifiable, Hashable, Codable {
    let id: String  // UUID as string for SQLite
    let date: Date  // Date portion (for daily grouping)
    let timestamp: Date  // Full timestamp
    var markdownContent: String
    
    init(id: String = UUID().uuidString, date: Date = Date(), timestamp: Date = Date(), markdownContent: String = "") {
        self.id = id
        // Strip time component from date for daily grouping
        self.date = Calendar.current.startOfDay(for: date)
        self.timestamp = timestamp
        self.markdownContent = markdownContent
    }
    
    // Create from database row
    init(id: String, dateString: String, timestampString: String, markdownContent: String) {
        self.id = id
        
        let dateFormatter = ISO8601DateFormatter()
        self.timestamp = dateFormatter.date(from: timestampString) ?? Date()
        self.date = dateFormatter.date(from: dateString) ?? Date()
        self.markdownContent = markdownContent
    }
    
    // Hashable conformance (optimized)
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: JournalEntry, rhs: JournalEntry) -> Bool {
        lhs.id == rhs.id
    }
}
