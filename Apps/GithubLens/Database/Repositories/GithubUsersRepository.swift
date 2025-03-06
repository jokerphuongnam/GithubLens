import GithubLensNetworks

// Protocol defining the repository interface for fetching GitHub user data.
protocol GithubUsersRepository {
    // Asynchronously fetch a list of GitHub users for a given page.
    // This function can throw errors if the network request fails.
    func getGithubUsers(page: Int) async throws -> [GithubUser]
    
    // Asynchronously fetch detailed information for a specific GitHub user identified by loginUsername.
    // This function can throw errors if the network request fails.
    func getGithubUserDetails(loginUsername: String) async throws -> GithubUserDetails
}

// Concrete implementation of the GithubUsersRepository protocol.
struct GithubUsersRepositoryImpl: GithubUsersRepository {
    // The network layer used to perform API requests.
    private let network: GithubNetwork
    
    // Number of users to fetch per page.
    private let perPage: Int = 20
    
    // Initializer that injects a GithubNetwork dependency.
    init(network: GithubNetwork) {
        self.network = network
    }
    
    // Fetches GitHub users for the specified page.
    func getGithubUsers(page: Int) async throws -> [GithubUser] {
        // Calculate the 'since' parameter for pagination.
        // This determines the starting point of users for the given page.
        let since = page * perPage
        
        // Use the network layer to fetch users.
        // The response is then mapped to extract the GithubUser objects.
        return try await network.fetchGithubUser(perPage: perPage, since: since)
            .map { $0.githubUser }
    }
    
    // Fetches detailed information for a specific GitHub user.
    func getGithubUserDetails(loginUsername: String) async throws -> GithubUserDetails {
        // Use the network layer to fetch the user's details.
        // The result is then transformed to extract the GithubUserDetails.
        try await network.fetchGithubUserDetails(loginUsername: loginUsername)
            .githubUserDetails
    }
}
