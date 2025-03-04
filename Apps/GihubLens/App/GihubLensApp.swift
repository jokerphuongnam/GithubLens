import SwiftUI

@main
struct GihubLensApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    
    var body: some Scene {
        WindowGroup {
            RoutesScreen()
        }
    }
}
