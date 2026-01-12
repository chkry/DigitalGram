import Foundation

struct JournalEntry: Identifiable, Hashable, Codable {
    let id: String  // date string in YYYY-MM-DD format (primary key)
    let date: Date  // Date object for display and grouping
    var markdownContent: String
    let created: String  // ISO8601 timestamp string
    let updated: String  // ISO8601 timestamp string
    
    init(date: Date = Date(), markdownContent: String = "") {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        self.id = String(format: "%04d-%02d-%02d", components.year!, components.month!, components.day!)
        self.date = calendar.startOfDay(for: date)
        self.markdownContent = markdownContent
        
        let dateFormatter = ISO8601DateFormatter()
        let now = dateFormatter.string(from: Date())
        self.created = now
        self.updated = now
    }
    
    // Create from existing entry with updated content
    init(id: String, date: Date, created: String, markdownContent: String) {
        self.id = id
        self.date = date
        self.markdownContent = markdownContent
        self.created = created
        
        let dateFormatter = ISO8601DateFormatter()
        self.updated = dateFormatter.string(from: Date())
    }
    
    // Create from database row
    init(dateString: String, year: Int, month: Int, day: Int, created: String, updated: String, markdownContent: String) {
        self.id = dateString
        
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = day
        self.date = Calendar.current.date(from: components) ?? Date()
        
        self.created = created
        self.updated = updated
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
