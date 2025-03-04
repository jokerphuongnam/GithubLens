protocol GithubUsersUserCase {
    func fetchGithubUser(page: Int) async throws -> [GithubUser]
}

struct GithubUsersUserCaseImpl: GithubUsersUserCase {
    private let githubUsersRepository: GithubUsersRepository
    
    init(githubUsersRepository: GithubUsersRepository) {
        self.githubUsersRepository = githubUsersRepository
    }
    
    func fetchGithubUser(page: Int) async throws -> [GithubUser] {
        try await githubUsersRepository.fetchGithubUser(page: page)
    }
}
