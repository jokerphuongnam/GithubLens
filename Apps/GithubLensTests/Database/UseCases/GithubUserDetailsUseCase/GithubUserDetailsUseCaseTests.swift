import Testing
import GithubLensNetworks
@testable import GithubLens

@Suite("Test GithubUserDetailsUseCase")
struct GithubUserDetailsUseCaseTests {
    // MARK: - Make SUT
    private func makeSUT(getGithubUserDetailsHandler: @escaping (String) async throws -> GithubUserDetails) -> GithubUserDetailsUseCase {
        let mockRepository = MockGithubUsersRepository(getGithubUserDetailsHandler: getGithubUserDetailsHandler)
        return GithubUserDetailsUseCaseImpl(githubUsersRepository: mockRepository)
    }
    
    // MARK: - Test: getGithubUserDetails
    @Test(
        "Test getGithubUserDetails returns expected user details",
        arguments: [
            "",
            "Test",
            "Test 1",
            "Test long username is here"
        ]
    )
    func getGithubUserDetailsParameter(loginUsername: String) async {
        // given
        var inputLoginUsername: String?
        
        let sut = makeSUT { loginUsername in
            inputLoginUsername = loginUsername
            return .init(randomBy: loginUsername)
        }
        
        await #expect(throws: Never.self) {
            // when
            let response = try await sut.getGithubUserDetails(loginUsername: loginUsername)
            
            // then
            let inputLoginUsername = try #require(inputLoginUsername)
            #expect(inputLoginUsername == loginUsername)
            #expect(response.login == loginUsername)
        }
    }
    
    @Test(
        "Test getGithubUserDetails returns expected user details",
        arguments: [
            "",
            "Test",
            "Test 1",
            "Test long username is here"
        ]
    )
    func getGithubUserDetailsReturnsExpectedUserDetails(loginUsername: String) async {
        // given
        let mockUserDetails = GithubUserDetails(randomBy: loginUsername)
        
        let sut = makeSUT { _ in
            return mockUserDetails
        }
        
        await #expect(throws: Never.self) {
            // when
            let response = try await sut.getGithubUserDetails(loginUsername: loginUsername)
            
            // then
            #expect(response.login == loginUsername)
            #expect(response.avatarUrl  == mockUserDetails.avatarUrl)
            #expect(response.htmlUrl  == mockUserDetails.htmlUrl)
            #expect(response.location  == mockUserDetails.location)
            #expect(response.login  == mockUserDetails.login)
            #expect(response.following  == mockUserDetails.following)
        }
    }
    
    @Test(
        "Test getGithubUserDetails throws errors",
        arguments: [
            AFNetworkError.serverError,
            AFNetworkError.timeout,
            AFNetworkError.forbidden,
            AFNetworkError.notFound
        ]
    )
    func getGithubUserDetailsThrowsError(error: AFNetworkError) async {
        // given
        let error = error
        
        let sut = makeSUT { _ in
            throw error
        }
        
        await #expect(throws: error) {
            // when
            try await sut.getGithubUserDetails(loginUsername: "")
        }
    }
}
