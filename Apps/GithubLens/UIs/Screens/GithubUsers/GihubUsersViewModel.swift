import Observation
import GithubLensNetworks

@Observable
final class GihubUsersViewModel {
    private let useCase: GithubUsersUserCase
    var usersState: LoadMoreResource<GithubUser> = .init(
        resource: .loading,
        prepareLoadMore: .canLoadMore,
        page: 0
    )
    
    init(useCase: GithubUsersUserCase) {
        self.useCase = useCase
    }
    
    func loadGitHubUsers() {
        usersState.resource = .loading
        Task(priority: .utility) { [weak self] in
            guard let self else { return }
            await self.refreshGitHubUsers()
        }
    }
    
    func refreshGitHubUsers() async {
        do {
            let users = try await useCase.getGithubUsers(page: usersState.page)
            Task { @MainActor [weak self] in
                guard let self else { return }
                self.usersState.resource = .success(data: users)
                self.usersState.increasePage()
            }
        } catch {
            Task { @MainActor [weak self] in
                guard let self else { return }
                self.usersState.resource = .failure(error: error)
            }
        }
    }
    
    func loadMore() {
        Task(priority: .utility) { [weak self] in
            guard let self else { return }
            guard self.usersState.prepareLoadMore == .canLoadMore else { return }
            guard case .success(data: _) = self.usersState.resource else { return }
            Task { @MainActor [weak self] in
                guard let self else { return }
                self.usersState.loadMoreState = .loading
                self.usersState.prepareLoadMore = .cannotLoadMore
            }
            
            do {
                let users = try await self.useCase.getGithubUsers(page: self.usersState.page)
                if users.isEmpty {
                    Task { @MainActor [weak self] in
                        guard let self else { return }
                        self.usersState.prepareLoadMore = .success
                        self.usersState.loadMoreState = nil
                        
                    }
                } else {
                    let newState = self.usersState.resource.loadMore(moreData: users)
                    if let _ = newState.data {
                        Task { @MainActor [weak self] in
                            guard let self else { return }
                            self.usersState.prepareLoadMore = .canLoadMore
                            self.usersState.increasePage()
                        }
                    }
                    Task { @MainActor [weak self] in
                        guard let self else { return }
                        self.usersState.resource = newState
                        self.usersState.loadMoreState = nil
                    }
                }
            } catch {
                Task { @MainActor [weak self] in
                    guard let self else { return }
                    self.usersState.loadMoreState = .error(error: error)
                }
            }
        }
    }
    
    func resetLoadMore() {
        Task { @MainActor [weak self] in
            guard let self else { return }
            self.usersState.prepareLoadMore = .canLoadMore
            self.usersState.loadMoreState = .loading
        }
        loadMore()
    }
}
