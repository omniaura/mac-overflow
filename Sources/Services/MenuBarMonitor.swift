import Foundation
import AppKit
import ApplicationServices

/// Monitors the menu bar for hidden items
class MenuBarMonitor {
    private var menuBarItems: [MenuBarItem] = []
    private var screenWidth: CGFloat

    init() {
        // Get main screen width
        screenWidth = NSScreen.main?.frame.width ?? 1920
    }

    /// Get all menu bar items that are currently hidden (off-screen)
    func getHiddenMenuBarItems() -> [MenuBarItem] {
        // Refresh the list of menu bar items
        refreshMenuBarItems()

        // Filter for items that are not visible
        return menuBarItems.filter { !$0.isVisible(screenWidth: screenWidth) }
    }

    /// Get all menu bar items (visible and hidden)
    func getAllMenuBarItems() -> [MenuBarItem] {
        refreshMenuBarItems()
        return menuBarItems
    }

    /// Refresh the list of menu bar items from the system
    private func refreshMenuBarItems() {
        var items: [MenuBarItem] = []

        // Get the system-wide accessibility element
        let systemWide = AXUIElementCreateSystemWide()

        // Get all menu bar items
        var menuBarElement: AnyObject?
        AXUIElementCopyAttributeValue(
            systemWide,
            kAXMenuBarAttribute as CFString,
            &menuBarElement
        )

        guard let menuBar = menuBarElement else {
            menuBarItems = []
            return
        }

        // Get menu bar items (children)
        var children: AnyObject?
        AXUIElementCopyAttributeValue(
            menuBar as! AXUIElement,
            kAXChildrenAttribute as CFString,
            &children
        )

        guard let childrenArray = children as? [AXUIElement] else {
            menuBarItems = []
            return
        }

        // Convert each element to MenuBarItem
        for element in childrenArray {
            if let item = MenuBarItem.from(element: element) {
                items.append(item)
            }
        }

        // Sort by x position (left to right)
        items.sort { $0.frame.minX < $1.frame.minX }

        menuBarItems = items
    }

    /// Calculate approximately how many items are hidden
    func getHiddenCount() -> Int {
        return getHiddenMenuBarItems().count
    }
}
