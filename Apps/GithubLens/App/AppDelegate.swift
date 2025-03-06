import UIKit

// AppDelegate is responsible for handling application-level events and lifecycle changes.
class AppDelegate: NSObject, UIApplicationDelegate {
    
    // This method is called when the application has finished launching.
    // It's the starting point for any setup your app needs before presenting its UI.
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        // Register all required dependencies using the Dependency Injection Manager.
        // This helps manage and inject dependencies throughout the application.
        DIManager.register()
        
        // Returning true indicates that the app has successfully finished launching.
        return true
    }
}
