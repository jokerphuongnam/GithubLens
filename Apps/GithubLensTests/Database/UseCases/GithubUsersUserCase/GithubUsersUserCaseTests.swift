import Testing
import GithubLensNetworks
@testable import GithubLens

@Suite("Test GithubUsersUserCase")
struct GithubUsersUserCaseTests {
    // MARK: - Make SUT
    private func makeSUT(getGithubUsersHandler: @escaping (_ page: Int) async throws -> [GithubUser]) -> GithubUsersUserCase {
        let mockRepository = MockGithubUsersRepository(getGithubUsersHandler: getGithubUsersHandler)
        return GithubUsersUserCaseImpl(githubUsersRepository: mockRepository)
    }
    
    // MARK: getGithubUsers
    @Test(
        "Test parameter page of getGithubUsers",
        arguments: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
    )
    func getGithubUsersParameters(page: Int) async {
        // given
        var inputPage: Int?
        
        let sut = makeSUT { page in
            inputPage = page
            return []
        }
        
        await #expect(throws: Never.self) {
            // when
            let response = try await sut.getGithubUsers(page: page)
            
            // then
            #expect(response.count == 0)
            let inputPage = try #require(inputPage)
            #expect(inputPage == page)
        }
    }
    
    @Test(
        "Test getGithubUsers size of returned users",
        arguments: [0, 20, 40, 60]
    )
    func getGithubUsersSizeOfReturnUsers(count: Int) async {
        // given
        let sut = makeSUT { _ in
                .init(count: count)
        }
        
        await #expect(throws: Never.self) {
            // when
            let response = try await sut.getGithubUsers(page: 0)
            
            // then
            #expect(count == response.count)
        }
    }
    
    @Test(
        "Test getGithubUsers returns expected users",
        arguments: [0, 10, 20, 40, 60],
        [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
    )
    func getGithubUsersReturnsExpectedUsers(count: Int, page: Int) async {
        // given
        let arrayOfUsers: [GithubUser] = .init(count: count)
        
        let sut = makeSUT { page in
            arrayOfUsers
        }
        
        await #expect(throws: Never.self) {
            // when
            let response = try await sut.getGithubUsers(page: page)
            
            // then
            #expect(count == response.count)
            #expect(arrayOfUsers.count == response.count)
            #expect(arrayOfUsers == response)
            
        }
    }
    
    @Test(
        "Test getGithubUsers throws errors",
        arguments: [
            AFNetworkError.serverError,
            AFNetworkError.timeout,
            AFNetworkError.forbidden,
            AFNetworkError.notFound
        ]
    )
    func getGithubUsersThrowsError(error: AFNetworkError) async {
        // given
        let error = error
        
        let sut = makeSUT { _ in
            throw error
        }
        
        await #expect(throws: error) {
            // when
            try await sut.getGithubUsers(page: 0)
        }
    }
}
