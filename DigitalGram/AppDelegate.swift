import SwiftUI
import AppKit
import ServiceManagement

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem?
    var popover: NSPopover?
    var eventMonitor: Any?
    var contextMenu: NSMenu?
    var settingsWindow: NSWindow?
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        // Ensure menu bar stays visible (compatible with all macOS versions)
        if #available(macOS 12.0, *) {
            NSApp.presentationOptions = []
        }
        
        // Create the status bar item
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        if let button = statusItem?.button {
            // Use SF Symbols which is available on macOS 11.0+
            if let image = NSImage(systemSymbolName: "book.fill", accessibilityDescription: "DigitalGram") {
                button.image = image
            } else {
                // Fallback for older systems (shouldn't happen with macOS 12+)
                button.title = "📓"
            }
            button.action = #selector(handleClick)
            button.target = self
            
            // Enable right-click
            button.sendAction(on: [.leftMouseUp, .rightMouseUp])
        }
        
        // Create the right-click menu (don't attach it to statusItem)
        createMenu()
        
        // Create the popover
        popover = NSPopover()
        popover?.contentSize = NSSize(width: 400, height: 500)
        popover?.behavior = .applicationDefined
        popover?.animates = true
        popover?.contentViewController = NSHostingController(rootView: JournalEntryView())
    }
    
    func createMenu() {
        let menu = NSMenu()
        
        // Launch at Login
        let launchAtLoginItem = NSMenuItem(title: "Launch at Login", action: #selector(toggleLaunchAtLogin), keyEquivalent: "")
        launchAtLoginItem.target = self
        launchAtLoginItem.state = isLaunchAtLoginEnabled() ? .on : .off
        menu.addItem(launchAtLoginItem)
        
        menu.addItem(NSMenuItem.separator())
        
        // Quit
        let quitItem = NSMenuItem(title: "Quit DigitalGram", action: #selector(quitApp), keyEquivalent: "q")
        quitItem.target = self
        menu.addItem(quitItem)
        
        // Store menu but don't attach it to statusItem
        contextMenu = menu
    }
    
    @objc func handleClick(_ sender: NSStatusBarButton) {
        guard let event = NSApp.currentEvent else { return }
        
        // Right-click or Control+click shows menu
        if event.type == .rightMouseUp || (event.type == .leftMouseUp && event.modifierFlags.contains(.control)) {
            contextMenu?.popUp(positioning: nil, at: NSPoint(x: 0, y: sender.bounds.height + 5), in: sender)
            return
        }
        
        // Left-click toggles popover
        if let button = statusItem?.button {
            if let popover = popover {
                if popover.isShown {
                    closePopover()
                } else {
                    popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
                    startMonitoring()
                }
            }
        }
    }
    
    @objc func openSettings() {
        // Close popover if shown
        closePopover()
        
        // If window already exists, just bring it to front
        if let existingWindow = settingsWindow, existingWindow.isVisible {
            existingWindow.makeKeyAndOrderFront(nil)
            NSApp.activate(ignoringOtherApps: true)
            return
        }
        
        // Show settings window
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 600, height: 700),
            styleMask: [.titled, .closable, .miniaturizable],
            backing: .buffered,
            defer: false
        )
        window.center()
        window.title = "Settings"
        
        // Create SettingsView with close action
        let settingsView = SettingsView(closeAction: { [weak self] in
            self?.settingsWindow?.close()
            self?.settingsWindow = nil
        })
        
        window.contentView = NSHostingView(rootView: settingsView)
        window.makeKeyAndOrderFront(nil)
        
        // Store the window
        settingsWindow = window
        
        // Activate the app
        NSApp.activate(ignoringOtherApps: true)
    }
    
    @objc func toggleLaunchAtLogin() {
        let currentState = isLaunchAtLoginEnabled()
        setLaunchAtLogin(enabled: !currentState)
        
        // Update menu item state
        if let menu = statusItem?.menu {
            for item in menu.items {
                if item.title == "Launch at Login" {
                    item.state = isLaunchAtLoginEnabled() ? .on : .off
                }
            }
        }
    }
    
    @objc func quitApp() {
        NSApplication.shared.terminate(nil)
    }
    
    func isLaunchAtLoginEnabled() -> Bool {
        if #available(macOS 13.0, *) {
            return SMAppService.mainApp.status == .enabled
        } else {
            // For macOS 12, track preference in UserDefaults
            // The actual implementation would require a helper app or login item
            return UserDefaults.standard.bool(forKey: "LaunchAtLogin")
        }
    }
    
    func setLaunchAtLogin(enabled: Bool) {
        if #available(macOS 13.0, *) {
            do {
                if enabled {
                    try SMAppService.mainApp.register()
                } else {
                    try SMAppService.mainApp.unregister()
                }
            } catch {
                #if DEBUG
                print("Failed to \(enabled ? "enable" : "disable") launch at login: \(error)")
                #endif
            }
        } else {
            // For macOS 12, store preference
            // Note: Full implementation would require a helper app
            UserDefaults.standard.set(enabled, forKey: "LaunchAtLogin")
            
            // Show alert that this feature requires macOS 13+
            let alert = NSAlert()
            alert.messageText = "Launch at Login"
            alert.informativeText = "This feature requires macOS 13 or later. Please upgrade to use automatic launch at login."
            alert.alertStyle = .informational
            alert.addButton(withTitle: "OK")
            alert.runModal()
        }
    }
    
    func closePopover() {
        popover?.performClose(nil)
        stopMonitoring()
    }
    
    func startMonitoring() {
        eventMonitor = NSEvent.addGlobalMonitorForEvents(matching: [.leftMouseDown, .rightMouseDown]) { [weak self] event in
            // Don't close if a panel or sheet is shown
            if NSApp.modalWindow != nil || NSApp.keyWindow is NSPanel {
                return
            }
            
            if let popover = self?.popover, popover.isShown {
                self?.closePopover()
            }
        }
    }
    
    func stopMonitoring() {
        if let monitor = eventMonitor {
            NSEvent.removeMonitor(monitor)
            eventMonitor = nil
        }
    }
    
    func applicationWillTerminate(_ notification: Notification) {
        // Checkpoint the database before app terminates to ensure all data is saved
        StorageManager.shared.checkpointDatabase()
    }
    
    func applicationDidResignActive(_ notification: Notification) {
        // Checkpoint when app goes to background
        StorageManager.shared.checkpointDatabase()
    }
}
