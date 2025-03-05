@testable import GithubLens

extension GithubUsersUserCaseTests {
    class MockGithubUsersRepository: GithubUsersRepository {
        private let getGithubUsersHandler: (_ page: Int) async throws -> [GithubUser]
        
        init(getGithubUsersHandler: @escaping (_ page: Int) async throws -> [GithubUser]) {
            self.getGithubUsersHandler = getGithubUsersHandler
        }
        
        func getGithubUsers(page: Int) async throws -> [GithubUser] {
            return try await getGithubUsersHandler(page)
        }
        
        func getGithubUserDetails(loginUsername: String) async throws -> GithubUserDetails {
            fatalError("Not implemented for test")
        }
    }
}
