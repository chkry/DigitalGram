import SwiftUI
import AppKit

struct JournalEntryView: View {
    @StateObject private var viewModel = JournalViewModel()
    @State private var markdownText = ""
    @State private var currentEntryId: String?
    @State private var showingSettings = false
    @State private var showPreview = false
    @State private var debounceTask: Task<Void, Never>?
    @State private var selectedDate = Date()
    @State private var showingDatePicker = false
    @State private var selectedTab = 0 // 0 = Journal, 1 = Entries
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false
    @State private var cursorPosition: Int = 0
    @State private var selectionRange: NSRange = NSRange(location: 0, length: 0)
    
    var body: some View {
        VStack(spacing: 0) {
            // Header with Tabs and Controls
            HStack {
                // Tabs
                HStack(spacing: 0) {
                    Button(action: { 
                        selectedTab = 0
                        showingDatePicker = false
                    }) {
                        Text("Journal")
                            .font(.headline)
                            .foregroundColor(selectedTab == 0 ? .primary : .secondary)
                            .padding(.vertical, 4)
                            .padding(.horizontal, 12)
                            .background(selectedTab == 0 ? Color.accentColor.opacity(0.1) : Color.clear)
                            .cornerRadius(6)
                    }
                    .buttonStyle(.plain)
                    
                    Text("|")
                        .foregroundColor(.secondary)
                        .padding(.horizontal, 4)
                    
                    Button(action: { 
                        selectedTab = 1
                        showingDatePicker = false
                    }) {
                        Text("Entries")
                            .font(.headline)
                            .foregroundColor(selectedTab == 1 ? .primary : .secondary)
                            .padding(.vertical, 4)
                            .padding(.horizontal, 12)
                            .background(selectedTab == 1 ? Color.accentColor.opacity(0.1) : Color.clear)
                            .cornerRadius(6)
                    }
                    .buttonStyle(.plain)
                }
                
                Spacer()
                
                // Dark Mode Toggle
                Button(action: { isDarkMode.toggle() }) {
                    Image(systemName: isDarkMode ? "moon.fill" : "sun.max.fill")
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                }
                .buttonStyle(.plain)
                .help(isDarkMode ? "Switch to Light Mode" : "Switch to Dark Mode")
                .padding(.trailing, 4)
                
                // Settings
                Button(action: { showingSettings.toggle() }) {
                    Image(systemName: "gear")
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                }
                .buttonStyle(.plain)
                .help("Settings")
                
                // Date Navigation (only show in Journal tab)
                if selectedTab == 0 {
                    HStack(spacing: 6) {
                        Button(action: { changeDate(by: -1) }) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 12))
                        }
                        .buttonStyle(.plain)
                        .help("Previous day")
                        
                        Button(action: { showingDatePicker.toggle() }) {
                            Text(selectedDate.formatted(date: .abbreviated, time: .omitted))
                                .font(.system(size: 13, weight: .medium))
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.accentColor.opacity(0.1))
                                .cornerRadius(6)
                        }
                        .buttonStyle(.plain)
                        .help("Select date")
                        .popover(isPresented: $showingDatePicker) {
                            DatePicker("", selection: $selectedDate, displayedComponents: .date)
                                .datePickerStyle(.graphical)
                                .padding()
                                .onChange(of: selectedDate) { _ in
                                    loadEntryForDate(selectedDate)
                                    showingDatePicker = false
                                }
                        }
                        
                        Button(action: { changeDate(by: 1) }) {
                            Image(systemName: "chevron.right")
                                .font(.system(size: 12))
                        }
                        .buttonStyle(.plain)
                        .help("Next day")
                        .disabled(Calendar.current.isDateInToday(selectedDate))
                    }
                    .foregroundColor(.secondary)
                }
            }
            .padding()
            .background(Color(NSColor.controlBackgroundColor))
            
            // Markdown Toolbar
            HStack(spacing: 8) {
                Button(action: { insertMarkdown("**bold**") }) {
                    Text("B").bold()
                        .font(.system(size: 12))
                        .frame(minWidth: 20)
                }
                .buttonStyle(.plain)
                .help("Bold")
                .disabled(showPreview)
                
                Button(action: { insertMarkdown("*italic*") }) {
                    Text("I").italic()
                        .font(.system(size: 12))
                        .frame(minWidth: 20)
                }
                .buttonStyle(.plain)
                .help("Italic")
                .disabled(showPreview)
                
                Button(action: { insertMarkdown("`code`") }) {
                    Text("<>")
                        .font(.system(size: 12, design: .monospaced))
                        .frame(minWidth: 20)
                }
                .buttonStyle(.plain)
                .help("Inline code")
                .disabled(showPreview)
                
                Button(action: { insertMarkdown("# ") }) {
                    Text("H1")
                        .font(.system(size: 12, weight: .bold))
                        .frame(minWidth: 24)
                }
                .buttonStyle(.plain)
                .help("Heading 1")
                .disabled(showPreview)
                
                Button(action: { insertMarkdown("## ") }) {
                    Text("H2")
                        .font(.system(size: 12, weight: .bold))
                        .frame(minWidth: 24)
                }
                .buttonStyle(.plain)
                .help("Heading 2")
                .disabled(showPreview)
                
                Button(action: { insertMarkdown("### ") }) {
                    Text("H3")
                        .font(.system(size: 12, weight: .bold))
                        .frame(minWidth: 24)
                }
                .buttonStyle(.plain)
                .help("Heading 3")
                .disabled(showPreview)
                
                Button(action: { insertMarkdown("- ") }) {
                    Image(systemName: "list.bullet")
                        .font(.system(size: 12))
                }
                .buttonStyle(.plain)
                .help("Bullet list")
                .disabled(showPreview)
                
                Button(action: { insertMarkdown("- [ ] ") }) {
                    Image(systemName: "checkmark.square")
                        .font(.system(size: 12))
                }
                .buttonStyle(.plain)
                .help("Checkbox")
                .disabled(showPreview)
                
                Button(action: { insertMarkdown("[link text](url)") }) {
                    Image(systemName: "link")
                        .font(.system(size: 12))
                }
                .buttonStyle(.plain)
                .help("Insert link")
                .disabled(showPreview)
                
                Button(action: { insertMarkdown("```\ncode\n```\n") }) {
                    Image(systemName: "curlybraces")
                        .font(.system(size: 12))
                }
                .buttonStyle(.plain)
                .help("Code block")
                .disabled(showPreview)
                
                Button(action: { insertImage() }) {
                    Image(systemName: "photo")
                        .font(.system(size: 12))
                }
                .buttonStyle(.plain)
                .help("Insert image")
                .disabled(showPreview)
                
                Button(action: { insertTimestamp() }) {
                    Image(systemName: "clock")
                        .font(.system(size: 12))
                }
                .buttonStyle(.plain)
                .help("Insert timestamp")
                .disabled(showPreview)
                
                Spacer()
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(Color(NSColor.controlBackgroundColor))
            
            Divider()
            
            // Tab Content
            if selectedTab == 1 {
                // Entries List View
                EntriesListView(viewModel: viewModel, selectedDate: $selectedDate, selectedTab: $selectedTab)
            } else if showPreview {
                // Markdown Preview
                ScrollView {
                    InteractiveMarkdownPreview(markdown: $markdownText, onSave: autoSave, onDoubleTap: {
                        showPreview = false
                    })
                        .padding()
                }
                .background(Color(NSColor.textBackgroundColor))
            } else {
                // Markdown Editor
                MarkdownTextEditor(text: $markdownText, cursorPosition: $cursorPosition, selectionRange: $selectionRange)
                    .font(.system(.body, design: .default))
                    .padding(8)
                    .onChange(of: markdownText) { newValue in
                        autoSave()
                    }
            }
            
            Divider()
            
            // Footer
            HStack {
                Text(viewModel.saveStatus)
                    .font(.caption)
                    .foregroundColor(.secondary)
                Spacer()
                
                // Preview Toggle (only in Journal tab)
                if selectedTab == 0 {
                    Button(action: { showPreview.toggle() }) {
                        HStack(spacing: 4) {
                            Image(systemName: showPreview ? "doc.plaintext" : "doc.richtext")
                                .font(.system(size: 11))
                            Text(showPreview ? "Markdown" : "Preview")
                                .font(.caption)
                        }
                        .foregroundColor(.secondary)
                    }
                    .buttonStyle(.plain)
                    .help(showPreview ? "Show editor" : "Show preview")
                    
                    Spacer()
                }
                
                Text("\(viewModel.entries.count) entries")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
            .background(Color(NSColor.controlBackgroundColor))
        }
        .frame(width: 400, height: 500)
        .preferredColorScheme(isDarkMode ? .dark : .light)
        .onChange(of: selectedDate) { newDate in
            loadEntryForDate(newDate)
        }
        .onAppear {
            selectedDate = Date()
            loadEntryForDate(selectedDate)
            
            // Listen for database changes
            NotificationCenter.default.addObserver(forName: NSNotification.Name("DatabaseChanged"), object: nil, queue: .main) { _ in
                viewModel.loadEntries()
                loadEntryForDate(selectedDate)
            }
        }
        .sheet(isPresented: $showingSettings) {
            SettingsView()
        }
    }
    
    private func insertTimestamp() {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        let timeString = formatter.string(from: Date())
        let index = markdownText.index(markdownText.startIndex, offsetBy: min(cursorPosition, markdownText.count))
        markdownText.insert(contentsOf: timeString, at: index)
        cursorPosition += timeString.count
    }
    
    private func loadEntryForDate(_ date: Date) {
        if let entry = viewModel.getEntryForDate(date) {
            markdownText = entry.markdownContent
            currentEntryId = entry.id
            // Start in preview mode if entry exists and has content
            showPreview = !entry.markdownContent.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        } else {
            // Create new entry for selected date
            currentEntryId = UUID().uuidString
            markdownText = ""
            // Start in editor mode for new entries
            showPreview = false
        }
    }
    
    private func changeDate(by days: Int) {
        if let newDate = Calendar.current.date(byAdding: .day, value: days, to: selectedDate) {
            selectedDate = newDate
            loadEntryForDate(newDate)
        }
    }
    
    private func insertMarkdown(_ syntax: String) {
        // Check if there's a selection
        if selectionRange.length > 0 {
            // Wrap selected text with markdown syntax
            let startIndex = markdownText.index(markdownText.startIndex, offsetBy: selectionRange.location)
            let endIndex = markdownText.index(startIndex, offsetBy: selectionRange.length)
            let selectedText = String(markdownText[startIndex..<endIndex])
            
            // Determine wrapping syntax based on the syntax type
            var wrappedText: String
            if syntax == "**bold**" {
                wrappedText = "**\(selectedText)**"
            } else if syntax == "*italic*" {
                wrappedText = "*\(selectedText)*"
            } else if syntax == "`code`" {
                wrappedText = "`\(selectedText)`"
            } else if syntax == "[link text](url)" {
                wrappedText = "[\(selectedText)](url)"
            } else {
                // For other syntax, just insert before selection
                wrappedText = syntax + selectedText
            }
            
            markdownText.replaceSubrange(startIndex..<endIndex, with: wrappedText)
            cursorPosition = selectionRange.location + wrappedText.count
            selectionRange = NSRange(location: cursorPosition, length: 0)
        } else {
            // No selection, insert at cursor position
            let index = markdownText.index(markdownText.startIndex, offsetBy: min(cursorPosition, markdownText.count))
            markdownText.insert(contentsOf: syntax, at: index)
            cursorPosition += syntax.count
        }
    }
    
    private func insertImage() {
        let panel = NSOpenPanel()
        panel.allowsMultipleSelection = false
        panel.canChooseDirectories = false
        
        // Use UTType with fallback for compatibility
        if #available(macOS 11.0, *) {
            panel.allowedContentTypes = [.png, .jpeg, .gif, .heic]
        } else {
            panel.allowedFileTypes = ["png", "jpg", "jpeg", "gif", "heic"]
        }
        
        panel.message = "Select an image to insert"
        panel.prompt = "Insert"
        
        // Get the popover window to attach the panel
        guard let popoverWindow = NSApp.keyWindow else {
            // Fallback to non-modal if window not available
            runImagePanel(panel)
            return
        }
        
        // Use beginSheetModal to keep popover open
        panel.beginSheetModal(for: popoverWindow) { response in
            self.handleImageSelection(panel: panel, response: response)
        }
    }
    
    private func runImagePanel(_ panel: NSOpenPanel) {
        NSApp.activate(ignoringOtherApps: true)
        let response = panel.runModal()
        handleImageSelection(panel: panel, response: response)
    }
    
    private func handleImageSelection(panel: NSOpenPanel, response: NSApplication.ModalResponse) {
        guard response == .OK, let sourceURL = panel.url else { return }
        
        // Start accessing security-scoped resource
        let sourceAccess = sourceURL.startAccessingSecurityScopedResource()
        defer {
            if sourceAccess {
                sourceURL.stopAccessingSecurityScopedResource()
            }
        }
        
        let storageManager = StorageManager.shared
        let imageName = "\(UUID().uuidString)_\(sourceURL.lastPathComponent)"
        let destinationURL = storageManager.imagesDirectory.appendingPathComponent(imageName)
        
        // Ensure images directory exists and we have access
        let imagesDir = storageManager.imagesDirectory
        let imagesDirAccess = imagesDir.startAccessingSecurityScopedResource()
        defer {
            if imagesDirAccess {
                imagesDir.stopAccessingSecurityScopedResource()
            }
        }
        
        do {
            // Create images directory if needed
            try FileManager.default.createDirectory(at: imagesDir, withIntermediateDirectories: true, attributes: nil)
            
            // Copy the image
            try FileManager.default.copyItem(at: sourceURL, to: destinationURL)
            
            // Insert markdown at cursor position
            let relativePath = "./images/\(imageName)"
            let altText = sourceURL.deletingPathExtension().lastPathComponent
            let imageMarkdown = "![\(altText)](\(relativePath))\n"
            let index = markdownText.index(markdownText.startIndex, offsetBy: min(cursorPosition, markdownText.count))
            markdownText.insert(contentsOf: imageMarkdown, at: index)
            cursorPosition += imageMarkdown.count
            
            print("Image copied successfully to: \(destinationURL.path)")
        } catch {
            print("Error copying image: \(error.localizedDescription)")
            // Show alert to user
            DispatchQueue.main.async {
                let alert = NSAlert()
                alert.messageText = "Image Upload Failed"
                alert.informativeText = "Could not copy image: \(error.localizedDescription)"
                alert.alertStyle = .warning
                alert.addButton(withTitle: "OK")
                alert.runModal()
            }
        }
    }
    
    private func autoSave() {
        // Cancel previous debounce task
        debounceTask?.cancel()
        
        // Create new debounce task
        debounceTask = Task {
            try? await Task.sleep(nanoseconds: 1_000_000_000) // 1 second
            
            guard !Task.isCancelled else { return }
            
            await MainActor.run {
                if let entryId = currentEntryId {
                    viewModel.saveEntry(id: entryId, markdownContent: markdownText, forDate: selectedDate)
                }
            }
        }
    }
}

// Interactive Markdown Preview with clickable checkboxes and resizable images
struct InteractiveMarkdownPreview: View {
    @Binding var markdown: String
    let onSave: () -> Void
    var onDoubleTap: () -> Void
    @State private var imageScale: CGFloat = 1.0
    @Environment(\.colorScheme) var colorScheme
    @AppStorage("appTheme") private var themeRawValue: String = AppTheme.earthyOlive.rawValue
    
    private var theme: AppTheme {
        AppTheme(rawValue: themeRawValue) ?? .earthyOlive
    }
    
    var linkColor: Color {
        colorScheme == .dark ? theme.darkLinkColor : theme.lightLinkColor
    }
    
    var codeBackgroundColor: Color {
        colorScheme == .dark ? theme.darkCodeBackground : theme.lightCodeBackground
    }
    
    var backgroundColor: Color {
        colorScheme == .dark ? theme.darkBackground : theme.lightBackground
    }
    
    var accentColor: Color {
        colorScheme == .dark ? theme.darkAccent : theme.lightAccent
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ForEach(Array(parseMarkdownBlocks(markdown).enumerated()), id: \.offset) { index, block in
                renderBlock(block, at: index)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .contentShape(Rectangle())
        .onTapGesture(count: 2) {
            onDoubleTap()
        }
    }
    
    private func parseMarkdownBlocks(_ text: String) -> [MarkdownBlock] {
        var blocks: [MarkdownBlock] = []
        let lines = text.components(separatedBy: "\n")
        var i = 0
        
        while i < lines.count {
            let line = lines[i]
            
            // Check for code block
            if line.hasPrefix("```") {
                var codeLines: [String] = []
                let language = String(line.dropFirst(3)).trimmingCharacters(in: .whitespaces)
                i += 1
                
                while i < lines.count && !lines[i].hasPrefix("```") {
                    codeLines.append(lines[i])
                    i += 1
                }
                
                blocks.append(.codeBlock(language: language, code: codeLines.joined(separator: "\n")))
                i += 1
            } else {
                blocks.append(.line(line, originalIndex: i))
                i += 1
            }
        }
        
        return blocks
    }
    
    enum MarkdownBlock {
        case line(String, originalIndex: Int)
        case codeBlock(language: String, code: String)
    }
    
    private func renderBlock(_ block: MarkdownBlock, at blockIndex: Int) -> some View {
        Group {
            switch block {
            case .line(let line, let index):
                renderLine(line, at: index)
            case .codeBlock(let language, let code):
                VStack(alignment: .leading, spacing: 4) {
                    if !language.isEmpty {
                        Text(language)
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(codeBackgroundColor.opacity(0.7))
                            .cornerRadius(4, corners: [.topLeft, .topRight])
                    }
                    
                    Text(code)
                        .font(.system(.body, design: .monospaced))
                        .padding(8)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(codeBackgroundColor)
                        .cornerRadius(language.isEmpty ? 4 : 0, corners: language.isEmpty ? [.allCorners] : [.bottomLeft, .bottomRight])
                }
            }
        }
    }
    
    private func renderLine(_ line: String, at index: Int) -> some View {
        Group {
            if line.hasPrefix("# ") {
                Text(line.dropFirst(2))
                    .font(.title)
                    .bold()
            } else if line.hasPrefix("## ") {
                Text(line.dropFirst(3))
                    .font(.title2)
                    .bold()
            } else if line.hasPrefix("### ") {
                Text(line.dropFirst(4))
                    .font(.title3)
                    .bold()
            } else if line.hasPrefix("- [ ] ") {
                HStack(alignment: .top) {
                    Button(action: {
                        toggleCheckbox(at: index, checked: false)
                    }) {
                        Image(systemName: "square")
                            .foregroundColor(linkColor)
                    }
                    .buttonStyle(.plain)
                    Text(formatInlineMarkdown(String(line.dropFirst(6))))
                }
            } else if line.hasPrefix("- [x] ") || line.hasPrefix("- [X] ") {
                HStack(alignment: .top) {
                    Button(action: {
                        toggleCheckbox(at: index, checked: true)
                    }) {
                        Image(systemName: "checkmark.square.fill")
                            .foregroundColor(linkColor)
                    }
                    .buttonStyle(.plain)
                    Text(formatInlineMarkdown(String(line.dropFirst(6))))
                        .strikethrough()
                }
            } else if line.hasPrefix("- ") {
                HStack(alignment: .top) {
                    Text("•")
                    Text(formatInlineMarkdown(String(line.dropFirst(2))))
                }
            } else if line.hasPrefix("![") {
                // Resizable Image preview with download option
                if let imageURL = extractImageURL(from: line) {
                    VStack(alignment: .leading, spacing: 4) {
                        AsyncImage(url: imageURL) { image in
                            image.resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(maxHeight: 200 * imageScale)
                                .cornerRadius(8)
                        } placeholder: {
                            ProgressView()
                        }
                        
                        HStack(spacing: 8) {
                            Button("-") {
                                imageScale = max(0.5, imageScale - 0.25)
                            }
                            .buttonStyle(.borderless)
                            .font(.caption)
                            
                            Slider(value: Binding(
                                get: { imageScale },
                                set: { imageScale = $0 }
                            ), in: 0.5...2.0)
                            .frame(width: 100)
                            
                            Button("+") {
                                imageScale = min(2.0, imageScale + 0.25)
                            }
                            .buttonStyle(.borderless)
                            .font(.caption)
                            
                            Text("\(Int(imageScale * 100))%")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                            
                            Spacer()
                            
                            Button(action: {
                                downloadImage(from: imageURL)
                            }) {
                                HStack(spacing: 4) {
                                    Image(systemName: "arrow.down.circle")
                                    Text("Download")
                                }
                                .font(.caption)
                            }
                            .buttonStyle(.borderless)
                        }
                    }
                } else {
                    Text(line)
                        .foregroundColor(.secondary)
                }
            } else if line.contains("[") && line.contains("](") && !line.hasPrefix("![") {
                // Render text with clickable links
                renderTextWithLinks(line)
            } else {
                Text(formatInlineMarkdown(line))
            }
        }
    }
    
    private func renderTextWithLinks(_ line: String) -> some View {
        let pattern = "\\[([^\\]]+)\\]\\(([^\\)]+)\\)"
        guard let regex = try? NSRegularExpression(pattern: pattern) else {
            return AnyView(Text(line))
        }
        
        let nsString = line as NSString
        let matches = regex.matches(in: line, range: NSRange(location: 0, length: nsString.length))
        
        if matches.isEmpty {
            return AnyView(Text(line))
        }
        
        var result: [AnyView] = []
        var lastIndex = 0
        
        for match in matches {
            // Add text before link
            if match.range.location > lastIndex {
                let range = NSRange(location: lastIndex, length: match.range.location - lastIndex)
                let text = nsString.substring(with: range)
                if !text.isEmpty {
                    result.append(AnyView(Text(formatInlineMarkdown(text))))
                }
            }
            
            // Add clickable link
            if let textRange = Range(match.range(at: 1), in: line),
               let urlRange = Range(match.range(at: 2), in: line) {
                let linkText = String(line[textRange])
                let urlString = String(line[urlRange])
                
                if let url = URL(string: urlString) {
                    result.append(AnyView(
                        Button(action: {
                            NSWorkspace.shared.open(url)
                        }) {
                            Text(linkText)
                                .foregroundColor(linkColor)
                                .underline()
                        }
                        .buttonStyle(.plain)
                    ))
                } else {
                    result.append(AnyView(Text("[\(linkText)](\(urlString))")))
                }
            }
            
            lastIndex = match.range.location + match.range.length
        }
        
        // Add remaining text
        if lastIndex < nsString.length {
            let range = NSRange(location: lastIndex, length: nsString.length - lastIndex)
            let text = nsString.substring(with: range)
            if !text.isEmpty {
                result.append(AnyView(Text(formatInlineMarkdown(text))))
            }
        }
        
        return AnyView(
            HStack(spacing: 0) {
                ForEach(0..<result.count, id: \.self) { index in
                    result[index]
                }
            }
        )
    }
    
    private func toggleCheckbox(at index: Int, checked: Bool) {
        var lines = markdown.components(separatedBy: "\n")
        guard index < lines.count else { return }
        
        let line = lines[index]
        if checked {
            // Change [x] to [ ]
            lines[index] = line.replacingOccurrences(of: "- [x] ", with: "- [ ] ")
                .replacingOccurrences(of: "- [X] ", with: "- [ ] ")
        } else {
            // Change [ ] to [x]
            lines[index] = line.replacingOccurrences(of: "- [ ] ", with: "- [x] ")
        }
        
        markdown = lines.joined(separator: "\n")
        onSave()
    }
    
    private func extractImageURL(from line: String) -> URL? {
        let pattern = "!\\[.*?\\]\\((.*?)\\)"
        if let regex = try? NSRegularExpression(pattern: pattern),
           let match = regex.firstMatch(in: line, range: NSRange(line.startIndex..., in: line)),
           let range = Range(match.range(at: 1), in: line) {
            let urlString = String(line[range])
            
            if urlString.hasPrefix("./images/") {
                let storageManager = StorageManager.shared
                let fileName = urlString.replacingOccurrences(of: "./images/", with: "")
                return storageManager.imagesDirectory.appendingPathComponent(fileName)
            }
            
            return URL(string: urlString)
        }
        return nil
    }
    
    private func formatInlineMarkdown(_ text: String) -> AttributedString {
        var result = AttributedString(text)
        
        // Process inline code first (to prevent interference with bold/italic)
        let codePattern = "`([^`]+)`"
        if let regex = try? NSRegularExpression(pattern: codePattern) {
            let matches = regex.matches(in: text, range: NSRange(text.startIndex..., in: text))
            for match in matches.reversed() {
                if let fullRange = Range(match.range, in: text),
                   let contentRange = Range(match.range(at: 1), in: text) {
                    let startIndex = result.index(result.startIndex, offsetByCharacters: text.distance(from: text.startIndex, to: fullRange.lowerBound))
                    let endIndex = result.index(result.startIndex, offsetByCharacters: text.distance(from: text.startIndex, to: fullRange.upperBound))
                    
                    let content = String(text[contentRange])
                    result.replaceSubrange(startIndex..<endIndex, with: AttributedString(content))
                    
                    let newEndIndex = result.index(startIndex, offsetByCharacters: content.count)
                    result[startIndex..<newEndIndex].font = .system(.body, design: .monospaced)
                    result[startIndex..<newEndIndex].backgroundColor = codeBackgroundColor.opacity(0.5)
                }
            }
        }
        
        // Process bold-italic ***text***
        let boldItalicPattern = "\\*\\*\\*([^*]+)\\*\\*\\*"
        if let regex = try? NSRegularExpression(pattern: boldItalicPattern) {
            let currentText = String(result.characters)
            let matches = regex.matches(in: currentText, range: NSRange(currentText.startIndex..., in: currentText))
            for match in matches.reversed() {
                if let fullRange = Range(match.range, in: currentText),
                   let contentRange = Range(match.range(at: 1), in: currentText) {
                    let startIndex = result.index(result.startIndex, offsetByCharacters: currentText.distance(from: currentText.startIndex, to: fullRange.lowerBound))
                    let endIndex = result.index(result.startIndex, offsetByCharacters: currentText.distance(from: currentText.startIndex, to: fullRange.upperBound))
                    
                    let content = String(currentText[contentRange])
                    var attrContent = AttributedString(content)
                    attrContent.font = .body.bold().italic()
                    result.replaceSubrange(startIndex..<endIndex, with: attrContent)
                }
            }
        }
        
        // Process bold **text**
        let boldPattern = "\\*\\*([^*]+)\\*\\*"
        if let regex = try? NSRegularExpression(pattern: boldPattern) {
            let currentText = String(result.characters)
            let matches = regex.matches(in: currentText, range: NSRange(currentText.startIndex..., in: currentText))
            for match in matches.reversed() {
                if let fullRange = Range(match.range, in: currentText),
                   let contentRange = Range(match.range(at: 1), in: currentText) {
                    let startIndex = result.index(result.startIndex, offsetByCharacters: currentText.distance(from: currentText.startIndex, to: fullRange.lowerBound))
                    let endIndex = result.index(result.startIndex, offsetByCharacters: currentText.distance(from: currentText.startIndex, to: fullRange.upperBound))
                    
                    let content = String(currentText[contentRange])
                    var attrContent = AttributedString(content)
                    attrContent.font = .body.bold()
                    result.replaceSubrange(startIndex..<endIndex, with: attrContent)
                }
            }
        }
        
        // Process italic *text* or _text_
        let italicPattern = "[*_]([^*_]+)[*_]"
        if let regex = try? NSRegularExpression(pattern: italicPattern) {
            let currentText = String(result.characters)
            let matches = regex.matches(in: currentText, range: NSRange(currentText.startIndex..., in: currentText))
            for match in matches.reversed() {
                if let fullRange = Range(match.range, in: currentText),
                   let contentRange = Range(match.range(at: 1), in: currentText) {
                    let startIndex = result.index(result.startIndex, offsetByCharacters: currentText.distance(from: currentText.startIndex, to: fullRange.lowerBound))
                    let endIndex = result.index(result.startIndex, offsetByCharacters: currentText.distance(from: currentText.startIndex, to: fullRange.upperBound))
                    
                    let content = String(currentText[contentRange])
                    var attrContent = AttributedString(content)
                    attrContent.font = .body.italic()
                    result.replaceSubrange(startIndex..<endIndex, with: attrContent)
                }
            }
        }
        
        return result
    }
    
    private func downloadImage(from url: URL) {
        let fileManager = FileManager.default
        let downloadsURL = fileManager.urls(for: .downloadsDirectory, in: .userDomainMask).first!
        
        // Get the file name from the URL
        var fileName = url.lastPathComponent
        var destinationURL = downloadsURL.appendingPathComponent(fileName)
        
        // Handle duplicate filenames
        var counter = 1
        let fileExtension = (fileName as NSString).pathExtension
        let fileNameWithoutExtension = (fileName as NSString).deletingPathExtension
        
        while fileManager.fileExists(atPath: destinationURL.path) {
            fileName = "\(fileNameWithoutExtension)_\(counter).\(fileExtension)"
            destinationURL = downloadsURL.appendingPathComponent(fileName)
            counter += 1
        }
        
        do {
            // Start accessing security-scoped resource if needed
            let accessing = url.startAccessingSecurityScopedResource()
            defer {
                if accessing {
                    url.stopAccessingSecurityScopedResource()
                }
            }
            
            // Copy the file
            try fileManager.copyItem(at: url, to: destinationURL)
            
            // Show in Finder
            NSWorkspace.shared.activateFileViewerSelecting([destinationURL])
            
        } catch {
            #if DEBUG
            print("Error downloading image: \(error)")
            #endif
        }
    }
}

// Helper function for downloading images (used by preview views)
private func downloadImage(from url: URL) {
    let fileManager = FileManager.default
    let downloadsURL = fileManager.urls(for: .downloadsDirectory, in: .userDomainMask).first!
    
    // Get the file name from the URL
    var fileName = url.lastPathComponent
    var destinationURL = downloadsURL.appendingPathComponent(fileName)
    
    // Handle duplicate filenames
    var counter = 1
    let fileExtension = (fileName as NSString).pathExtension
    let fileNameWithoutExtension = (fileName as NSString).deletingPathExtension
    
    while fileManager.fileExists(atPath: destinationURL.path) {
        fileName = "\(fileNameWithoutExtension)_\(counter).\(fileExtension)"
        destinationURL = downloadsURL.appendingPathComponent(fileName)
        counter += 1
    }
    
    do {
        // Start accessing security-scoped resource if needed
        let accessing = url.startAccessingSecurityScopedResource()
        defer {
            if accessing {
                url.stopAccessingSecurityScopedResource()
            }
        }
        
        // Copy the file
        try fileManager.copyItem(at: url, to: destinationURL)
        
        // Show in Finder
        NSWorkspace.shared.activateFileViewerSelecting([destinationURL])
        
    } catch {
        print("Error downloading image: \(error)")
    }
}

// Entries List View
struct EntriesListView: View {
    @ObservedObject var viewModel: JournalViewModel
    @Binding var selectedDate: Date
    @Binding var selectedTab: Int
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("All Entries")
                    .font(.headline)
                Spacer()
                Text("\(viewModel.entries.count) total")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding()
            .background(Color(NSColor.controlBackgroundColor))
            
            Divider()
            
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(viewModel.entries.sorted(by: { $0.date > $1.date })) { entry in
                        EntryRow(entry: entry) {
                            selectedDate = entry.date
                            selectedTab = 0
                        }
                    }
                }
                .padding()
            }
        }
    }
}

struct EntryRow: View {
    let entry: JournalEntry
    let onSelect: () -> Void
    
    var body: some View {
        Button(action: onSelect) {
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(entry.date.formatted(date: .abbreviated, time: .omitted))
                        .font(.headline)
                    Spacer()
                    if let createdDate = ISO8601DateFormatter().date(from: entry.created) {
                        Text(createdDate.formatted(date: .omitted, time: .shortened))
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                Text(entry.markdownContent.prefix(150))
                    .font(.body)
                    .foregroundColor(.secondary)
                    .lineLimit(3)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(12)
            .background(Color(NSColor.controlBackgroundColor))
            .cornerRadius(8)
        }
        .buttonStyle(.plain)
    }
}

struct MarkdownPreview: View {
    let markdown: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ForEach(parseMarkdown(markdown), id: \.self) { line in
                renderLine(line)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private func parseMarkdown(_ text: String) -> [String] {
        return text.components(separatedBy: "\n")
    }
    
    private func renderLine(_ line: String) -> some View {
        Group {
            if line.hasPrefix("# ") {
                Text(line.dropFirst(2))
                    .font(.title)
                    .bold()
            } else if line.hasPrefix("## ") {
                Text(line.dropFirst(3))
                    .font(.title2)
                    .bold()
            } else if line.hasPrefix("### ") {
                Text(line.dropFirst(4))
                    .font(.title3)
                    .bold()
            } else if line.hasPrefix("- [ ] ") {
                HStack(alignment: .top) {
                    Image(systemName: "square")
                    Text(line.dropFirst(6))
                }
            } else if line.hasPrefix("- [x] ") || line.hasPrefix("- [X] ") {
                HStack(alignment: .top) {
                    Image(systemName: "checkmark.square.fill")
                        .foregroundColor(.blue)
                    Text(line.dropFirst(6))
                        .strikethrough()
                }
            } else if line.hasPrefix("- ") {
                HStack(alignment: .top) {
                    Text("•")
                    Text(line.dropFirst(2))
                }
            } else if line.hasPrefix("![") {
                // Image preview with download option
                if let imageURL = extractImageURL(from: line) {
                    VStack(alignment: .leading, spacing: 4) {
                        AsyncImage(url: imageURL) { image in
                            image.resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(maxHeight: 200)
                        } placeholder: {
                            ProgressView()
                        }
                        
                        HStack {
                            Spacer()
                            Button(action: {
                                downloadImage(from: imageURL)
                            }) {
                                HStack(spacing: 4) {
                                    Image(systemName: "arrow.down.circle")
                                    Text("Download")
                                }
                                .font(.caption)
                            }
                            .buttonStyle(.borderless)
                        }
                    }
                } else {
                    Text(line)
                        .foregroundColor(.secondary)
                }
            } else {
                Text(formatInlineMarkdown(line))
            }
        }
    }
    
    private func extractImageURL(from line: String) -> URL? {
        // Extract URL from markdown image syntax: ![alt](url)
        let pattern = "!\\[.*?\\]\\((.*?)\\)"
        if let regex = try? NSRegularExpression(pattern: pattern),
           let match = regex.firstMatch(in: line, range: NSRange(line.startIndex..., in: line)),
           let range = Range(match.range(at: 1), in: line) {
            let urlString = String(line[range])
            
            // Handle relative paths
            if urlString.hasPrefix("./images/") {
                let storageManager = StorageManager.shared
                let fileName = urlString.replacingOccurrences(of: "./images/", with: "")
                return storageManager.imagesDirectory.appendingPathComponent(fileName)
            }
            
            return URL(string: urlString)
        }
        return nil
    }
    
    private func formatInlineMarkdown(_ text: String) -> AttributedString {
        let result = AttributedString(text)
        
        // Bold
        let boldPattern = "\\*\\*(.*?)\\*\\*"
        if let boldRegex = try? NSRegularExpression(pattern: boldPattern) {
            _ = boldRegex.matches(in: text, range: NSRange(text.startIndex..., in: text))
            // Note: For full implementation, would need to process matches
        }
        
        return result
    }
}

// Extension for custom corner radius
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = NSBezierPath(roundedRect: rect,
                                byRoundingCorners: corners,
                                cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

extension UIRectCorner {
    static let allCorners: UIRectCorner = [.topLeft, .topRight, .bottomLeft, .bottomRight]
}

extension NSBezierPath {
    convenience init(roundedRect rect: CGRect, byRoundingCorners corners: UIRectCorner, cornerRadii: CGSize) {
        self.init()
        
        let topLeft = rect.origin
        let topRight = CGPoint(x: rect.maxX, y: rect.minY)
        let bottomRight = CGPoint(x: rect.maxX, y: rect.maxY)
        let bottomLeft = CGPoint(x: rect.minX, y: rect.maxY)
        
        move(to: CGPoint(x: rect.minX + (corners.contains(.topLeft) ? cornerRadii.width : 0), y: rect.minY))
        
        // Top edge and top-right corner
        if corners.contains(.topRight) {
            line(to: CGPoint(x: topRight.x - cornerRadii.width, y: topRight.y))
            curve(to: CGPoint(x: topRight.x, y: topRight.y + cornerRadii.height),
                  controlPoint1: topRight,
                  controlPoint2: topRight)
        } else {
            line(to: topRight)
        }
        
        // Right edge and bottom-right corner
        if corners.contains(.bottomRight) {
            line(to: CGPoint(x: bottomRight.x, y: bottomRight.y - cornerRadii.height))
            curve(to: CGPoint(x: bottomRight.x - cornerRadii.width, y: bottomRight.y),
                  controlPoint1: bottomRight,
                  controlPoint2: bottomRight)
        } else {
            line(to: bottomRight)
        }
        
        // Bottom edge and bottom-left corner
        if corners.contains(.bottomLeft) {
            line(to: CGPoint(x: bottomLeft.x + cornerRadii.width, y: bottomLeft.y))
            curve(to: CGPoint(x: bottomLeft.x, y: bottomLeft.y - cornerRadii.height),
                  controlPoint1: bottomLeft,
                  controlPoint2: bottomLeft)
        } else {
            line(to: bottomLeft)
        }
        
        // Left edge and top-left corner
        if corners.contains(.topLeft) {
            line(to: CGPoint(x: topLeft.x, y: topLeft.y + cornerRadii.height))
            curve(to: CGPoint(x: topLeft.x + cornerRadii.width, y: topLeft.y),
                  controlPoint1: topLeft,
                  controlPoint2: topLeft)
        } else {
            line(to: topLeft)
        }
        
        close()
    }
    
    var cgPath: CGPath {
        let path = CGMutablePath()
        var points = [CGPoint](repeating: .zero, count: 3)
        
        for i in 0..<elementCount {
            let type = element(at: i, associatedPoints: &points)
            switch type {
            case .moveTo:
                path.move(to: points[0])
            case .lineTo:
                path.addLine(to: points[0])
            case .curveTo:
                path.addCurve(to: points[2], control1: points[0], control2: points[1])
            case .closePath:
                path.closeSubpath()
            default:
                break
            }
        }
        
        return path
    }
}

struct UIRectCorner: OptionSet {
    let rawValue: Int
    
    static let topLeft = UIRectCorner(rawValue: 1 << 0)
    static let topRight = UIRectCorner(rawValue: 1 << 1)
    static let bottomLeft = UIRectCorner(rawValue: 1 << 2)
    static let bottomRight = UIRectCorner(rawValue: 1 << 3)
}

// Custom NSTextView wrapper to track cursor position and selection
struct MarkdownTextEditor: NSViewRepresentable {
    @Binding var text: String
    @Binding var cursorPosition: Int
    @Binding var selectionRange: NSRange
    
    func makeNSView(context: Context) -> NSScrollView {
        let scrollView = NSTextView.scrollableTextView()
        let textView = scrollView.documentView as! NSTextView
        
        textView.delegate = context.coordinator
        textView.isRichText = false
        textView.autoresizingMask = [.width]
        textView.font = .systemFont(ofSize: NSFont.systemFontSize)
        textView.textColor = NSColor.textColor
        textView.backgroundColor = NSColor.textBackgroundColor
        textView.string = text
        textView.isAutomaticQuoteSubstitutionEnabled = false
        textView.isAutomaticDashSubstitutionEnabled = false
        textView.isAutomaticTextReplacementEnabled = false
        
        return scrollView
    }
    
    func updateNSView(_ scrollView: NSScrollView, context: Context) {
        let textView = scrollView.documentView as! NSTextView
        
        if textView.string != text {
            let selectedRange = textView.selectedRange()
            textView.string = text
            
            // Restore cursor position
            if cursorPosition <= text.count {
                textView.setSelectedRange(NSRange(location: cursorPosition, length: 0))
            } else {
                textView.setSelectedRange(selectedRange)
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, NSTextViewDelegate {
        var parent: MarkdownTextEditor
        
        init(_ parent: MarkdownTextEditor) {
            self.parent = parent
        }
        
        func textDidChange(_ notification: Notification) {
            guard let textView = notification.object as? NSTextView else { return }
            parent.text = textView.string
            let range = textView.selectedRange()
            parent.cursorPosition = range.location
            parent.selectionRange = range
        }
        
        func textViewDidChangeSelection(_ notification: Notification) {
            guard let textView = notification.object as? NSTextView else { return }
            let range = textView.selectedRange()
            parent.cursorPosition = range.location
            parent.selectionRange = range
        }
        
        func textView(_ textView: NSTextView, doCommandBy commandSelector: Selector) -> Bool {
            // Handle Enter key for auto-continuing lists and checkboxes
            if commandSelector == #selector(NSResponder.insertNewline(_:)) {
                return handleNewline(textView)
            }
            return false
        }
        
        private func handleNewline(_ textView: NSTextView) -> Bool {
            let text = textView.string as NSString
            let cursorLocation = textView.selectedRange().location
            
            // Find the current line using NSString methods
            let lineRange = text.lineRange(for: NSRange(location: cursorLocation, length: 0))
            let currentLine = text.substring(with: lineRange).trimmingCharacters(in: .newlines)
            
            // Check for checkbox patterns
            if currentLine.hasPrefix("- [ ] ") {
                let restOfLine = currentLine.dropFirst(6)
                if restOfLine.trimmingCharacters(in: CharacterSet.whitespaces).isEmpty {
                    // Empty checkbox, remove it and just add newline
                    textView.insertText("", replacementRange: NSRange(location: lineRange.location, length: lineRange.length - 1))
                } else {
                    // Add new checkbox
                    textView.insertText("\n- [ ] ", replacementRange: textView.selectedRange())
                }
                return true
            } else if currentLine.hasPrefix("- [x] ") || currentLine.hasPrefix("- [X] ") {
                let restOfLine = currentLine.dropFirst(6)
                if restOfLine.trimmingCharacters(in: CharacterSet.whitespaces).isEmpty {
                    // Empty checked checkbox, remove it and just add newline
                    textView.insertText("", replacementRange: NSRange(location: lineRange.location, length: lineRange.length - 1))
                } else {
                    // Add new unchecked checkbox
                    textView.insertText("\n- [ ] ", replacementRange: textView.selectedRange())
                }
                return true
            } else if currentLine.hasPrefix("- ") {
                let restOfLine = currentLine.dropFirst(2)
                if restOfLine.trimmingCharacters(in: CharacterSet.whitespaces).isEmpty {
                    // Empty list item, remove it and just add newline
                    textView.insertText("", replacementRange: NSRange(location: lineRange.location, length: lineRange.length - 1))
                } else {
                    // Add new list item
                    textView.insertText("\n- ", replacementRange: textView.selectedRange())
                }
                return true
            }
            
            return false
        }
    }
}

#Preview {
    JournalEntryView()
}
