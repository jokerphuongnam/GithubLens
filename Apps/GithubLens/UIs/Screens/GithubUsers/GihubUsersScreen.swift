import SwiftUI

struct GihubUsersScreen: View {
    private let viewModel: GihubUsersViewModel
    @Environment(\.routes) private var routes
    
    init(viewModel: GihubUsersViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        contentView
            .navigationTitle("Github Users")
            .onAppear {
                viewModel.loadGitHubUsers()
            }
    }
    
    @ViewBuilder private var contentView: some View {
        switch viewModel.usersState.resource {
        case .loading:
            loadingView
        case .success(let data):
            githubUsers(users: data)
        case .failure(let error):
            failureView(error: error)
        }
    }
    
    @ViewBuilder private var loadingView: some View {
        ProgressView()
    }
    
    @ViewBuilder private func githubUsers(users: [GithubUser]) -> some View {
        if users.isEmpty {
            emptyStateView
        } else {
            List {
                Spacer()
                    .frame(height: 32)
                    .removeDefaultListItem()
                
                ForEach(users, id: \.login) { user in
                    Button {
                        routes.wrappedValue.append(Route.details(user.login))
                    } label: {
                        GithubUserItem(githubUser: user)
                            .frame(height: 100)
                            .onAppear {
                                if let _ = users[safe: users.count - 10] {
                                    viewModel.loadMore()
                                }
                            }
                    }
                    .buttonStyle(.plain)
                    .removeDefaultListItem()
                }
                
                loadMoreView
                    .removeDefaultListItem()
                    .frame(maxWidth: .infinity)
                
                Spacer()
                    .frame(height: 32)
                    .removeDefaultListItem()
            }
            .listStyle(.plain)
            .listRowSpacing(8)
            .refreshable {
                await viewModel.refreshGitHubUsers()
            }
        }
    }
    
    @ViewBuilder private var emptyStateView: some View {
        EmptyView()
    }
    
    @ViewBuilder private var loadMoreView: some View {
        if let loadMoreState = viewModel.usersState.loadMoreState {
            switch loadMoreState {
            case .loading:
                ProgressView()
                    .frame(width: 24, height: 24)
            case .error:
                VStack(spacing: 8) {
                    Text("Error load more user")
                        .font(.system(size: 16))
                        .foregroundStyle(Color(r: 237, g: 67, b: 55))
                    
                    Button {
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
    
    @ViewBuilder private func failureView(error: Error) -> some View {
        VStack(spacing: 8) {
            Text("Error load users")
                .font(.system(size: 16))
                .foregroundStyle(Color(r: 237, g: 67, b: 55))
            
            Button {
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
