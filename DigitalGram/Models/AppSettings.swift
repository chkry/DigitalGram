import Foundation

class AppSettings: Codable {
    var storagePath: String
    var currentDatabase: String
    
    static var shared: AppSettings = AppSettings.load()
    
    init(storagePath: String, currentDatabase: String = "journal.db") {
        self.storagePath = storagePath
        self.currentDatabase = currentDatabase
    }
    
    static func load() -> AppSettings {
        if let data = UserDefaults.standard.data(forKey: "AppSettings"),
           let settings = try? JSONDecoder().decode(AppSettings.self, from: data) {
            return settings
        }
        
        // Default to Documents/DigitalGram
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let defaultPath = documentsPath.appendingPathComponent("DigitalGram").path
        return AppSettings(storagePath: defaultPath, currentDatabase: "journal.db")
    }
    
    func save() {
        if let data = try? JSONEncoder().encode(self) {
            UserDefaults.standard.set(data, forKey: "AppSettings")
        }
        // Update the shared instance
        AppSettings.shared = self
    }
}
