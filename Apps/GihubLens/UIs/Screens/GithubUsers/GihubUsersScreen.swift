import SwiftUI

struct GihubUsersScreen: View {
    private let viewModel: GihubUsersViewModel
    
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
            failure(error: error)
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
                    GithubUserItem(githubUser: user)
                        .frame(height: 100)
                        .removeDefaultListItem()
                }
                
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
    
    @ViewBuilder private func failure(error: Error) -> some View {
        
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
