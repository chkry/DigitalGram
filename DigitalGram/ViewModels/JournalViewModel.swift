import Foundation
import AppKit
import UniformTypeIdentifiers

class JournalViewModel: ObservableObject {
    @Published var entries: [JournalEntry] = []
    @Published var saveStatus: String = "Auto-saved"
    
    private let storageManager = StorageManager.shared
    private let calendar = Calendar.current
    
    init() {
        loadEntries()
    }
    
    func loadEntries() {
        entries = storageManager.loadEntries()
    }
    
    func getTodayEntry() -> JournalEntry? {
        return entries.first { entry in
            calendar.isDateInToday(entry.date)
        }
    }
    
    func getEntryForDate(_ date: Date) -> JournalEntry? {
        return entries.first { entry in
            calendar.isDate(entry.date, inSameDayAs: date)
        }
    }
    
    func saveEntry(id: String, markdownContent: String, forDate date: Date) {
        let now = Date()
        
        if let existingIndex = entries.firstIndex(where: { $0.id == id }) {
            // Update existing entry - preserve original date, update timestamp
            let updated = JournalEntry(
                id: id,
                date: entries[existingIndex].date,
                timestamp: now,
                markdownContent: markdownContent
            )
            entries[existingIndex] = updated
            storageManager.saveEntry(updated)
        } else {
            // Create new entry with selected date
            let newEntry = JournalEntry(
                id: id,
                date: date,
                timestamp: now,
                markdownContent: markdownContent
            )
            entries.insert(newEntry, at: 0)
            storageManager.saveEntry(newEntry)
        }
        
        updateSaveStatus()
    }
    
    func deleteEntry(id: String) {
        entries.removeAll { $0.id == id }
        storageManager.deleteEntry(id: id)
    }
    
    func exportToExcel() {
        let excelContent = generateExcel()
        
        let savePanel = NSSavePanel()
        if #available(macOS 11.0, *) {
            if let xlsxType = UTType(filenameExtension: "xlsx") {
                savePanel.allowedContentTypes = [xlsxType]
            }
        } else {
            savePanel.allowedFileTypes = ["xlsx"]
        }
        let timestamp = ISO8601DateFormatter().string(from: Date())
        savePanel.nameFieldStringValue = "digitalgram_export_\(timestamp).xlsx"
        
        if let window = NSApp.keyWindow {
            savePanel.beginSheetModal(for: window) { response in
                self.handleExcelExport(savePanel: savePanel, response: response, excelContent: excelContent)
            }
        } else {
            let response = savePanel.runModal()
            handleExcelExport(savePanel: savePanel, response: response, excelContent: excelContent)
        }
    }
    
    private func handleExcelExport(savePanel: NSSavePanel, response: NSApplication.ModalResponse, excelContent: Data) {
        if response == .OK, let url = savePanel.url {
            do {
                try excelContent.write(to: url)
                self.saveStatus = "Exported to Excel"
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.updateSaveStatus()
                }
            } catch {
                self.saveStatus = "Export failed"
                #if DEBUG
                print("Error exporting Excel: \(error)")
                #endif
            }
        }
    }
    
    func exportToCSV() {
        let csvContent = generateCSV()
        
        let savePanel = NSSavePanel()
        if #available(macOS 11.0, *) {
            savePanel.allowedContentTypes = [.commaSeparatedText]
        } else {
            savePanel.allowedFileTypes = ["csv"]
        }
        let timestamp = ISO8601DateFormatter().string(from: Date())
        savePanel.nameFieldStringValue = "digitalgram_export_\(timestamp).csv"
        
        if let window = NSApp.keyWindow {
            savePanel.beginSheetModal(for: window) { response in
                self.handleCSVExport(savePanel: savePanel, response: response, csvContent: csvContent)
            }
        } else {
            let response = savePanel.runModal()
            handleCSVExport(savePanel: savePanel, response: response, csvContent: csvContent)
        }
    }
    
    private func handleCSVExport(savePanel: NSSavePanel, response: NSApplication.ModalResponse, csvContent: String) {
        if response == .OK, let url = savePanel.url {
            do {
                try csvContent.write(to: url, atomically: true, encoding: .utf8)
                self.saveStatus = "Exported to CSV"
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.updateSaveStatus()
                }
            } catch {
                self.saveStatus = "Export failed"
                #if DEBUG
                print("Error exporting CSV: \(error)")
                #endif
            }
        }
    }
    
    private func generateCSV() -> String {
        var csv = "Entry ID,Date,Timestamp,Markdown Content\\n"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        
        let timestampFormatter = DateFormatter()
        timestampFormatter.dateStyle = .medium
        timestampFormatter.timeStyle = .medium
        
        for entry in entries.sorted(by: { $0.timestamp > $1.timestamp }) {
            let dateString = dateFormatter.string(from: entry.date)
            let timestampString = timestampFormatter.string(from: entry.timestamp)
            let escapedContent = escapeCSV(entry.markdownContent)
            
            csv += "\(entry.id),\(dateString),\(timestampString),\(escapedContent)\\n"
        }
        
        return csv
    }
    
    private func generateExcel() -> Data {
        // Simple XML-based Excel format (SpreadsheetML)
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
            let escapedContent = escapeXML(entry.markdownContent)
            
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
        
        return xml.data(using: .utf8) ?? Data()
    }
    
    private func escapeCSV(_ string: String) -> String {
        if string.contains(",") || string.contains("\"") || string.contains("\\n") {
            return "\"\(string.replacingOccurrences(of: "\"", with: "\"\""))\""
        }
        return string
    }
    
    private func escapeXML(_ string: String) -> String {
        return string
            .replacingOccurrences(of: "&", with: "&amp;")
            .replacingOccurrences(of: "<", with: "&lt;")
            .replacingOccurrences(of: ">", with: "&gt;")
            .replacingOccurrences(of: "\"", with: "&quot;")
            .replacingOccurrences(of: "'", with: "&apos;")
    }
    
    private func updateSaveStatus() {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        saveStatus = "Auto-saved at \(dateFormatter.string(from: Date()))"
    }
}
