import SwiftUI

@main
struct TaskifyApp: App {
    // Apply @NSApplicationDelegateAdaptor to a property to link AppDelegate
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
