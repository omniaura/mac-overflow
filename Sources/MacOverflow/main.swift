import SwiftUI
import AppKit

@main
struct MacOverflowApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        Settings {
            SettingsView()
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem!
    var menu: NSMenu!
    var menuBarMonitor: MenuBarMonitor!

    func applicationDidFinishLaunching(_ notification: Notification) {
        // Hide dock icon - we're a menu bar only app
        NSApp.setActivationPolicy(.accessory)

        // Create menu bar item
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

        if let button = statusItem.button {
            // Use a three-line "hamburger" icon
            button.image = NSImage(systemSymbolName: "line.3.horizontal", accessibilityDescription: "Overflow Menu")
            button.action = #selector(showOverflowMenu)
            button.target = self
        }

        // Initialize menu bar monitor
        menuBarMonitor = MenuBarMonitor()

        // Check for accessibility permissions
        checkAccessibilityPermissions()
    }

    @objc func showOverflowMenu() {
        guard let button = statusItem.button else { return }

        // Build menu from hidden items
        menu = NSMenu()

        let hiddenItems = menuBarMonitor.getHiddenMenuBarItems()

        if hiddenItems.isEmpty {
            let noItemsItem = NSMenuItem(title: "No hidden items", action: nil, keyEquivalent: "")
            noItemsItem.isEnabled = false
            menu.addItem(noItemsItem)
        } else {
            for item in hiddenItems {
                let menuItem = NSMenuItem(
                    title: item.title,
                    action: #selector(handleOverflowItemClick(_:)),
                    keyEquivalent: ""
                )
                menuItem.representedObject = item
                menuItem.image = item.icon
                menu.addItem(menuItem)
            }
        }

        menu.addItem(NSMenuItem.separator())

        // Add settings
        menu.addItem(NSMenuItem(title: "About Mac Overflow", action: #selector(showAbout), keyEquivalent: ""))
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(quit), keyEquivalent: "q"))

        // Show menu
        statusItem.menu = menu
        statusItem.button?.performClick(nil)
        statusItem.menu = nil  // Clear menu so it rebuilds fresh next time
    }

    @objc func handleOverflowItemClick(_ sender: NSMenuItem) {
        guard let item = sender.representedObject as? MenuBarItem else { return }
        // Forward click to the actual menu bar item
        item.performClick()
    }

    @objc func showAbout() {
        let alert = NSAlert()
        alert.messageText = "Mac Overflow"
        alert.informativeText = """
        Lightweight menu bar overflow manager

        Version: 0.1.0
        License: MIT

        Never lose your menu bar icons again!
        """
        alert.alertStyle = .informational
        alert.addButton(withTitle: "OK")
        alert.runModal()
    }

    @objc func quit() {
        NSApplication.shared.terminate(nil)
    }

    func checkAccessibilityPermissions() {
        let options: NSDictionary = [kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String: true]
        let accessEnabled = AXIsProcessTrustedWithOptions(options)

        if !accessEnabled {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                let alert = NSAlert()
                alert.messageText = "Accessibility Permission Required"
                alert.informativeText = """
                Mac Overflow needs Accessibility permissions to detect and interact with menu bar icons.

                Please grant permission in System Preferences > Privacy & Security > Accessibility
                """
                alert.alertStyle = .warning
                alert.addButton(withTitle: "Open System Preferences")
                alert.addButton(withTitle: "Quit")

                if alert.runModal() == .alertFirstButtonReturn {
                    NSWorkspace.shared.open(URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility")!)
                }
                NSApplication.shared.terminate(nil)
            }
        }
    }
}

struct SettingsView: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("Mac Overflow")
                .font(.title)

            Text("Lightweight menu bar overflow manager")
                .font(.subheadline)
                .foregroundColor(.secondary)

            Divider()

            Text("Click the ≡ icon in your menu bar to see hidden items")
                .multilineTextAlignment(.center)

            Spacer()
        }
        .padding()
        .frame(width: 400, height: 200)
    }
}
