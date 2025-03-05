import SwiftUI

private struct RoutesKey: EnvironmentKey {
    static let defaultValue: Binding<[Route]> = .constant([])
}

extension EnvironmentValues {
    var routes: Binding<[Route]> {
        get { self[RoutesKey.self] }
        set { self[RoutesKey.self] = newValue }
    }
}
