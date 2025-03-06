// This protocol defines a contract for fetching GitHub users with pagination support.
// Any type conforming to this protocol must implement the getGithubUsers method.
protocol GithubUsersUserCase {
    // Fetch GitHub users for a given page.
    // The method is asynchronous and can throw errors.
    // Returns an array of GithubUser objects.
    func getGithubUsers(page: Int) async throws -> [GithubUser]
}

// This struct is a concrete implementation of the GithubUsersUserCase protocol.
// It uses a repository to actually fetch the GitHub users.
struct GithubUsersUserCaseImpl: GithubUsersUserCase {
    // The repository that handles the actual data fetching.
    private let githubUsersRepository: GithubUsersRepository
    
    // Initializer that injects a GithubUsersRepository dependency.
    init(githubUsersRepository: GithubUsersRepository) {
        self.githubUsersRepository = githubUsersRepository
    }
    
    // Implementation of the protocol method.
    // This function calls the repository's method to fetch GitHub users for the given page.
    func getGithubUsers(page: Int) async throws -> [GithubUser] {
        // Await the asynchronous operation on the repository.
        // Propagate any error thrown by the repository.
        try await githubUsersRepository.getGithubUsers(page: page)
    }
}
