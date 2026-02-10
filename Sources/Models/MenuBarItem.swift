import Foundation
import AppKit

/// Represents a menu bar item from another application
struct MenuBarItem: Identifiable {
    let id: String
    let title: String
    let icon: NSImage?
    let element: AXUIElement
    let frame: CGRect

    /// Simulate a click on this menu bar item
    func performClick() {
        // Perform a click action on the accessibility element
        AXUIElementPerformAction(element, kAXPressAction as CFString)
    }

    /// Check if this item is currently visible on screen
    func isVisible(screenWidth: CGFloat) -> Bool {
        // Item is visible if its center point is within the screen bounds
        let centerX = frame.midX
        return centerX > 0 && centerX < screenWidth
    }
}

extension MenuBarItem {
    /// Create MenuBarItem from an AXUIElement
    static func from(element: AXUIElement) -> MenuBarItem? {
        var titleValue: AnyObject?
        var positionValue: AnyObject?
        var sizeValue: AnyObject?

        // Get title
        AXUIElementCopyAttributeValue(element, kAXTitleAttribute as CFString, &titleValue)
        let title = titleValue as? String ?? "Unknown"

        // Get position
        AXUIElementCopyAttributeValue(element, kAXPositionAttribute as CFString, &positionValue)
        var position = CGPoint.zero
        if let posValue = positionValue {
            AXValueGetValue(posValue as! AXValue, .cgPoint, &position)
        }

        // Get size
        AXUIElementCopyAttributeValue(element, kAXSizeAttribute as CFString, &sizeValue)
        var size = CGSize.zero
        if let sizeVal = sizeValue {
            AXValueGetValue(sizeVal as! AXValue, .cgSize, &size)
        }

        let frame = CGRect(origin: position, size: size)

        // Try to get icon (may not always be available)
        var imageValue: AnyObject?
        AXUIElementCopyAttributeValue(element, kAXImageAttribute as CFString, &imageValue)
        let icon = imageValue as? NSImage

        // Generate unique ID
        let id = "\(title)-\(position.x)-\(position.y)"

        return MenuBarItem(
            id: id,
            title: title,
            icon: icon,
            element: element,
            frame: frame
        )
    }
}
