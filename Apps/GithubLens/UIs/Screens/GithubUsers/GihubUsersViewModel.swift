import Observation
import GithubLensNetworks

// Marks the class as observable so that UI updates are triggered when published properties change.
@Observable
final class GihubUsersViewModel {
    // The use case responsible for fetching GitHub users.
    private let useCase: GithubUsersUserCase
    
    // The current state of GitHub users, including:
    // - `resource`: Represents the data state (loading, success, or failure).
    // - `prepareLoadMore`: Indicates whether more data can be loaded.
    // - `page`: The current page number used for pagination.
    var usersState: LoadMoreResource<GithubUser> = .init(
        resource: .loading,         // Initially, the resource state is set to loading.
        prepareLoadMore: .canLoadMore, // Ready to load more data.
        page: 0                     // Start at page 0.
    )
    
    // Initializer that injects the dependency required for fetching GitHub users.
    init(useCase: GithubUsersUserCase) {
        self.useCase = useCase
    }
    
    // Initiates the loading process of GitHub users.
    // Sets the state to loading, then starts an asynchronous task to refresh the user list.
    func loadGitHubUsers() {
        usersState.resource = .loading
        Task(priority: .utility) { [weak self] in
            guard let self else { return }
            await self.refreshGitHubUsers()
        }
    }
    
    // Asynchronously refreshes the list of GitHub users.
    // On success, updates the resource state to success and increases the page number.
    // On failure, sets the resource state to failure.
    func refreshGitHubUsers() async {
        do {
            // Attempt to fetch users for the current page.
            let users = try await useCase.getGithubUsers(page: usersState.page)
            Task { @MainActor [weak self] in
                guard let self else { return }
                // On success, update the resource with the fetched users.
                self.usersState.resource = .success(data: users)
                // Increase the page number for future requests.
                self.usersState.increasePage()
            }
        } catch {
            // In case of error, update the resource state to failure on the main thread.
            Task { @MainActor [weak self] in
                guard let self else { return }
                self.usersState.resource = .failure(error: error)
            }
        }
    }
    
    // Loads additional GitHub users (pagination).
    // Checks if loading more is allowed, then fetches more data and updates the state accordingly.
    func loadMore() {
        Task(priority: .utility) { [weak self] in
            guard let self else { return }
            // Ensure that the view model is allowed to load more data.
            guard self.usersState.prepareLoadMore == .canLoadMore else { return }
            // Proceed only if the current resource state indicates a successful load.
            guard case .success(data: _) = self.usersState.resource else { return }
            
            // Update the UI state on the main thread to reflect that a load more action is in progress.
            Task { @MainActor [weak self] in
                guard let self else { return }
                self.usersState.loadMoreState = .loading
                self.usersState.prepareLoadMore = .cannotLoadMore
            }
            
            do {
                // Attempt to fetch the next page of users.
                let users = try await self.useCase.getGithubUsers(page: self.usersState.page)
                if users.isEmpty {
                    // If no more users are returned, update the load more state accordingly.
                    Task { @MainActor [weak self] in
                        guard let self else { return }
                        self.usersState.prepareLoadMore = .success
                        self.usersState.loadMoreState = nil
                    }
                } else {
                    // Merge the new users with the current resource.
                    let newState = self.usersState.resource.loadMore(moreData: users)
                    // If new data exists, allow further load more actions and increase the page count.
                    if let _ = newState.data {
                        Task { @MainActor [weak self] in
                            guard let self else { return }
                            self.usersState.prepareLoadMore = .canLoadMore
                            self.usersState.increasePage()
                        }
                    }
                    // Update the resource state with the merged data.
                    Task { @MainActor [weak self] in
                        guard let self else { return }
                        self.usersState.resource = newState
                        self.usersState.loadMoreState = nil
                    }
                }
            } catch {
                // In case of error during load more, update the load more state to error.
                Task { @MainActor [weak self] in
                    guard let self else { return }
                    self.usersState.loadMoreState = .error(error: error)
                }
            }
        }
    }
    
    // Resets the load more state to allow retrying a load more action.
    // Updates the state on the main thread and then triggers `loadMore()`.
    func resetLoadMore() {
        Task { @MainActor [weak self] in
            guard let self else { return }
            self.usersState.prepareLoadMore = .canLoadMore
            self.usersState.loadMoreState = .loading
        }
        loadMore()
    }
}
