@testable import GithubLens

extension GithubUserDetailsUseCaseTests {
    final class MockGithubUsersRepository: GithubUsersRepository {
        private let getGithubUserDetailsHandler: (_ loginUsername: String) async throws -> GithubUserDetails
        
        init(getGithubUserDetailsHandler: @escaping (_ loginUsername: String) async throws -> GithubUserDetails) {
            self.getGithubUserDetailsHandler = getGithubUserDetailsHandler
        }
        
        func getGithubUsers(page: Int) async throws -> [GithubUser] {
            fatalError("Not implemented for test")
        }
        
        func getGithubUserDetails(loginUsername: String) async throws -> GithubUserDetails {
            try await getGithubUserDetailsHandler(loginUsername)
        }
    }
}
