import SwiftUI

struct RoutesScreen: View {
    var body: some View {
        NavigationStack {
            GihubUsersScreen(
                viewModel: GihubUsersViewModel(
                    useCase: DIManager.get()
                )
            )
            .navigationDestination(for: Route.self) { route in
                switch route {
                case .details(let loginUsername):
                    Text("Login username \(loginUsername)")
                }
            }
        }
    }
}
