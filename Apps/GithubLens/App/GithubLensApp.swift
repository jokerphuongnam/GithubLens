import SwiftUI

@main
struct GithubLensApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    
    var body: some Scene {
        WindowGroup {
            RoutesScreen()
        }
    }
}
