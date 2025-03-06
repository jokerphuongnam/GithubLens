protocol GithubUsersUserCase {
    func getGithubUsers(page: Int) async throws -> [GithubUser]
}

struct GithubUsersUserCaseImpl: GithubUsersUserCase {
    private let githubUsersRepository: GithubUsersRepository
    
    init(githubUsersRepository: GithubUsersRepository) {
        self.githubUsersRepository = githubUsersRepository
    }
    
    func getGithubUsers(page: Int) async throws -> [GithubUser] {
        try await githubUsersRepository.getGithubUsers(page: page)
    }
}
