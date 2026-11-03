import AppKit

final class AppDelegate: NSObject, NSApplicationDelegate {
    private var statusItem: NSStatusItem!
    private let windowController = NotchWindowController()

    func applicationDidFinishLaunching(_ notification: Notification) {
        setupStatusItem()
        windowController.setupWindow()
    }

    private func setupStatusItem() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        if let button = statusItem.button {
            button.image = NSImage(systemSymbolName: "timer", accessibilityDescription: "NotchFocus")
        }

        let menu = NSMenu()
        menu.addItem(NSMenuItem(title: "Toggle Sticky Notes", action: #selector(toggleNotes), keyEquivalent: "n"))
        menu.addItem(NSMenuItem(title: "Show / Hide Notch", action: #selector(toggleWindow), keyEquivalent: "h"))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(quitApp), keyEquivalent: "q"))

        statusItem.menu = menu
    }

    @objc private func toggleNotes() {
        windowController.toggleNotes()
    }

    @objc private func toggleWindow() {
        windowController.toggleVisibility()
    }

    @objc private func quitApp() {
        NSApp.terminate(nil)
    }
}

let app = NSApplication.shared
let delegate = AppDelegate()
app.delegate = delegate
app.setActivationPolicy(.accessory)
app.run()
