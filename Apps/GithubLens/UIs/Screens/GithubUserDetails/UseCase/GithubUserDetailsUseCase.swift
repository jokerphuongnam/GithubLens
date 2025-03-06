// Protocol defining the use case for fetching detailed information about a GitHub user.
// This abstracts the fetching logic and allows for different implementations.
protocol GithubUserDetailsUseCase {
    // Asynchronously fetch detailed GitHub user information given a login username.
    // The function can throw an error if the operation fails.
    func getGithubUserDetails(loginUsername: String) async throws -> GithubUserDetails
}

// Concrete implementation of the GithubUserDetailsUseCase protocol.
struct GithubUserDetailsUseCaseImpl: GithubUserDetailsUseCase {
    // Dependency on a repository that handles the actual fetching of GitHub user details.
    private let githubUsersRepository: GithubUsersRepository
    
    // Initializer that injects the GithubUsersRepository dependency.
    init(githubUsersRepository: GithubUsersRepository) {
        self.githubUsersRepository = githubUsersRepository
    }
    
    // Implementation of the protocol method.
    // Calls the repository's method to fetch the GitHub user details asynchronously.
    func getGithubUserDetails(loginUsername: String) async throws -> GithubUserDetails {
        try await githubUsersRepository.getGithubUserDetails(loginUsername: loginUsername)
    }
}
