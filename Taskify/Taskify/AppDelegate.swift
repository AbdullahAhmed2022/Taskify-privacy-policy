import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate {

    func applicationDidFinishLaunching(_ notification: Notification) {
        // Set the Dock icon when the app finishes launching
        setDockIcon()
    }

    func setDockIcon() {
        if let icon = NSImage(named: "AppIcon") {
            NSApplication.shared.applicationIconImage = icon
        } else {
            print("Error: AppIcon not found in asset catalog.")
        }
    }
}
