import SwiftUI

// Define a private struct that conforms to EnvironmentKey.
// This key is used to store a Binding for an array of Route objects in the SwiftUI environment.
private struct RoutesKey: EnvironmentKey {
    // Provide a default value for the key.
    // Here, we create a constant (immutable) Binding to an empty array of Route objects.
    static let defaultValue: Binding<[Route]> = .constant([])
}

// Extend EnvironmentValues to add a custom property for routes.
extension EnvironmentValues {
    // The 'routes' property allows access to a Binding<[Route]> via the RoutesKey.
    // This enables child views to read and write to the routes binding from the environment.
    var routes: Binding<[Route]> {
        get {
            // Retrieve the value associated with RoutesKey from the environment.
            self[RoutesKey.self]
        }
        set {
            // Set a new value for RoutesKey in the environment.
            self[RoutesKey.self] = newValue
        }
    }
}
