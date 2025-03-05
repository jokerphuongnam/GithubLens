import SwiftUI

struct RoutesScreen: View {
    @State private var routes: [Route]
    
    init(routes: [Route] = []) {
        self.routes = routes
    }
    
    var body: some View {
        NavigationStack(path: $routes) {
            GihubUsersScreen(
                viewModel: GihubUsersViewModel(
                    useCase: DIManager.get()
                )
            )
            .navigationDestination(for: Route.self) { route in
                switch route {
                case .details(let loginUsername):
                    GithubUserDetailsScreen(
                        viewModel: GithubUserDetailsViewModel(
                            useCase: DIManager.get()
                        ),
                        loginUsername: loginUsername
                    )
                }
            }
        }
        .environment(\.routes, $routes)
    }
}
