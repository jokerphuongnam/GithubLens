import SwiftUI

struct GihubUsersScreen: View {
    // The view model that handles fetching and managing GitHub user data.
    private let viewModel: GihubUsersViewModel
    
    // Access the navigation routes from the environment.
    @Environment(\.routes) private var routes
    
    // Custom initializer to inject the view model.
    init(viewModel: GihubUsersViewModel) {
        self.viewModel = viewModel
    }
    
    // The main view body.
    var body: some View {
        // Render the content view based on the state of the users.
        contentView
            .navigationTitle("Github Users") // Set the navigation bar title.
            .onAppear {
                // Load GitHub users when the view appears.
                viewModel.loadGitHubUsers()
            }
    }
    
    // A computed view that displays content based on the current resource state.
    @ViewBuilder private var contentView: some View {
        switch viewModel.usersState.resource {
        case .loading:
            // Show a loading indicator while data is loading.
            loadingView
        case .success(let data):
            // Display the list of GitHub users when data loads successfully.
            githubUsers(users: data)
        case .failure(let error):
            // Display an error view if loading fails.
            failureView(error: error)
        }
    }
    
    // A simple loading view that displays a progress indicator.
    @ViewBuilder private var loadingView: some View {
        ProgressView()
    }
    
    // A view to display the list of GitHub users.
    @ViewBuilder private func githubUsers(users: [GithubUser]) -> some View {
        if users.isEmpty {
            // If no users are available, display an empty state view.
            emptyStateView
        } else {
            // Use a List to display user items.
            List {
                // A spacer at the top for additional spacing.
                Spacer()
                    .frame(height: 32)
                    .removeDefaultListItem()
                
                // Loop through each GitHub user.
                ForEach(users, id: \.login) { user in
                    // Each user is displayed as a button to trigger navigation.
                    Button {
                        // Append a new route to navigate to the user's detail screen.
                        routes.wrappedValue.append(Route.details(user.login))
                    } label: {
                        // Display the GitHub user item.
                        GithubUserItem(githubUser: user)
                            .frame(height: 100)
                            .onAppear {
                                // If nearing the end of the list, trigger loading more data.
                                if let _ = users[safe: users.count - 10] {
                                    viewModel.loadMore()
                                }
                            }
                    }
                    .buttonStyle(.plain) // Use a plain button style.
                    .removeDefaultListItem()
                }
                
                // Display the load more view.
                loadMoreView
                    .removeDefaultListItem()
                    .frame(maxWidth: .infinity)
                
                // A spacer at the bottom for additional spacing.
                Spacer()
                    .frame(height: 32)
                    .removeDefaultListItem()
            }
            .listStyle(.plain)     // Set the list style.
            .listRowSpacing(8)     // Set spacing between rows.
            .refreshable {
                // Allow users to refresh the list via pull-to-refresh.
                await viewModel.refreshGitHubUsers()
            }
        }
    }
    
    // A simple empty state view when there are no users.
    @ViewBuilder private var emptyStateView: some View {
        EmptyView()
    }
    
    // A view to handle the "load more" state.
    @ViewBuilder private var loadMoreView: some View {
        if let loadMoreState = viewModel.usersState.loadMoreState {
            switch loadMoreState {
            case .loading:
                // Show a small progress view when loading more users.
                ProgressView()
                    .frame(width: 24, height: 24)
            case .error:
                // Show an error message with a retry button if loading more fails.
                VStack(spacing: 8) {
                    Text("Error load more user")
                        .font(.system(size: 16))
                        .foregroundStyle(Color(r: 237, g: 67, b: 55))
                    
                    Button {
                        // Retry loading more users.
                        viewModel.resetLoadMore()
                    } label: {
                        Text("Retry?")
                            .foregroundStyle(Color(r: 185, g: 205, b: 235))
                            .font(.system(size: 14))
                            .underline()
                    }
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.vertical, 8)
                .padding(.horizontal, 12)
            }
        }
    }
    
    // A view to handle the failure state when the initial user loading fails.
    @ViewBuilder private func failureView(error: Error) -> some View {
        VStack(spacing: 8) {
            Text("Error load users")
                .font(.system(size: 16))
                .foregroundStyle(Color(r: 237, g: 67, b: 55))
            
            Button {
                // Retry loading the users.
                viewModel.loadGitHubUsers()
            } label: {
                Text("Retry?")
                    .foregroundStyle(Color(r: 185, g: 205, b: 235))
                    .font(.system(size: 14))
                    .underline()
            }
        }
    }
}

#if DEBUG
#Preview {
    NavigationStack {
        GihubUsersScreen(
            viewModel: GihubUsersViewModel(
                useCase: DIManager.get()
            )
        )
    }
}
#endif
