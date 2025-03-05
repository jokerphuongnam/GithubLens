protocol GithubUserDetailsUseCase {
    func getGithubUserDetails(loginUsername: String) async throws -> GithubUserDetails
}

struct GithubUserDetailsUseCaseImpl: GithubUserDetailsUseCase {
    private let githubUsersRepository: GithubUsersRepository
    
    init(githubUsersRepository: GithubUsersRepository) {
        self.githubUsersRepository = githubUsersRepository
    }
    
    func getGithubUserDetails(loginUsername: String) async throws -> GithubUserDetails {
        try await githubUsersRepository.getGithubUserDetails(loginUsername: loginUsername)
    }
}
