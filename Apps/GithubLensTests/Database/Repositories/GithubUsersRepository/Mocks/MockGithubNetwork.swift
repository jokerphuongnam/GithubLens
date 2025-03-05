import Foundation
import GithubLensNetworks
@testable import GithubLens

struct MockGithubNetwork: GithubNetwork {
    private let fetchGithubUserHandler: ((Int, Int) async throws -> [FetchGithubUsersResponse])?
    private let fetchGithubUserDetailsHandler: ((String) async throws -> FetchGithubUserDetailsResponse)?
    
    init(fetchGithubUserHandler: @escaping (Int, Int) async throws -> [FetchGithubUsersResponse]) {
        self.fetchGithubUserHandler = fetchGithubUserHandler
        self.fetchGithubUserDetailsHandler = nil
    }
    
    init(fetchGithubUserDetailsHandler: @escaping (String) async throws -> FetchGithubUserDetailsResponse) {
        self.fetchGithubUserHandler = nil
        self.fetchGithubUserDetailsHandler = fetchGithubUserDetailsHandler
    }
    
    func fetchGithubUser(perPage: Int, since: Int) async throws -> [FetchGithubUsersResponse] {
        if let handler = fetchGithubUserHandler {
            return try await handler(perPage, since)
        }
        throw NSError(domain: "MockGithubNetwork need implement fetchGithubUserHandler", code: 0, userInfo: nil)
    }
    
    func fetchGithubUserDetails(loginUsername: String) async throws -> FetchGithubUserDetailsResponse {
        if let handler = fetchGithubUserDetailsHandler {
            return try await handler(loginUsername)
        }
        throw NSError(domain: "MockGithubNetwork need implement fetchGithubUserHandler", code: 0, userInfo: nil)
    }
}
