import Observation
import GithubLensNetworks

@Observable
final class GihubUsersViewModel {
    private let useCase: GithubUsersUserCase
    var usersState: LoadMoreState<[GithubUser]> = .init(resource: .loading, loadMore: .cannotLoadMore, page: 0)
    
    init(useCase: GithubUsersUserCase) {
        self.useCase = useCase
    }
    
    func loadGitHubUsers() {
        usersState.resource = .loading
        Task(priority: .utility) {
            await refreshGitHubUsers()
        }
    }
    
    func refreshGitHubUsers() async {
        do {
            let users = try await useCase.fetchGithubUser(page: usersState.page)
            Task { @MainActor in
                usersState.resource = .success(data: users)
            }
        } catch {
            Task { @MainActor in
                usersState.resource = .failure(error: error)
            }
        }
    }
    
    func loadMore() {
        Task(priority: .utility) {
            guard usersState.loadMore == .cannotLoadMore else { return }
            guard case .success(data: _) = usersState.resource else { return }
            
            do {
                
            } catch {
                
            }
        }
    }
}
