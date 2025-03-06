import SwiftUI

// Define a view that manages navigation between different routes.
struct RoutesScreen: View {
    // State property to hold the current navigation path as an array of Route objects.
    @State private var routes: [Route]
    
    // Custom initializer that allows passing an initial array of routes.
    // By default, the routes array is empty.
    init(routes: [Route] = []) {
        self.routes = routes
    }
    
    // The body property describes the view's layout and behavior.
    var body: some View {
        // NavigationStack manages navigation in a stack-based interface.
        // The 'path' binding keeps track of the current navigation stack.
        NavigationStack(path: $routes) {
            // The root view in the navigation stack is GihubUsersScreen.
            // It receives a view model created using dependency injection.
            GihubUsersScreen(
                viewModel: GihubUsersViewModel(
                    // Use DIManager to resolve the required dependency.
                    useCase: DIManager.get()
                )
            )
            // Define navigation destinations for Route objects.
            // When a new route is pushed onto the stack, this closure determines the destination view.
            .navigationDestination(for: Route.self) { route in
                // Switch based on the route type.
                switch route {
                    // When the route is .details, extract the loginUsername.
                case .details(let loginUsername):
                    // Navigate to GithubUserDetailsScreen with the appropriate view model and username.
                    GithubUserDetailsScreen(
                        viewModel: GithubUserDetailsViewModel(
                            // Resolve the dependency via DIManager.
                            useCase: DIManager.get()
                        ),
                        loginUsername: loginUsername
                    )
                }
            }
        }
        // Inject the routes binding into the environment so that child views can access it if needed.
        .environment(\.routes, $routes)
    }
}
