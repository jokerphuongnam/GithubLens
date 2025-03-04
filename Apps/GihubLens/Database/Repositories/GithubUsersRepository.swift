import GithubLensNetworks

protocol GithubUsersRepository {
    func fetchGithubUser(page: Int) async throws -> [GithubUser]
    func fetchGithubUserDetails(loginUsername: String) async throws -> GithubUserDetails
}

struct GithubUsersRepositoryImpl: GithubUsersRepository {
    private let network: GithubNetwork
    private let perPage: Int = 20
    
    init(network: GithubNetwork) {
        self.network = network
    }
    
    func fetchGithubUser(page: Int) async throws -> [GithubUser] {
        let since = page * perPage
        return try await network.fetchGithubUser(perPage: perPage, since: since).map { $0.githubUser }
    }
    
    func fetchGithubUserDetails(loginUsername: String) async throws -> GithubUserDetails {
        try await network.fetchGithubUserDetails(loginUsername: loginUsername).githubUserDetails
    }
}
