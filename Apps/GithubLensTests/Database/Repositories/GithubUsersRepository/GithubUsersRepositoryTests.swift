import Testing
@testable import GithubLensNetworks
@testable import GithubLens

@Suite("Test Github users repository")
struct GithubUsersRepositoryTests {
    // MARK: - Test: make SUT
    private func makeSUT(fetchGithubUserHandler: @escaping (Int, Int) async throws -> [FetchGithubUsersResponse]) -> GithubUsersRepository {
        let mockNetwork = MockGithubNetwork(fetchGithubUserHandler: fetchGithubUserHandler)
        return GithubUsersRepositoryImpl(network: mockNetwork)
    }
    
    private func makeSUT(fetchGithubUserDetailsHandler: @escaping (String) async throws -> FetchGithubUserDetailsResponse) -> GithubUsersRepository {
        let mockNetwork = MockGithubNetwork(fetchGithubUserDetailsHandler: fetchGithubUserDetailsHandler)
        return GithubUsersRepositoryImpl(network: mockNetwork)
    }
    
    // MARK: - Test: fetchGithubUser
    @Test(
        "Test parameters per page and since of getGithubUsers",
        arguments: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
    )
    func getGithubUsersParameters(page: Int) async {
        // given
        var inputPerPage: Int?
        var inputSince: Int?
        
        let sut = makeSUT { perPage, since in
            inputPerPage = perPage
            inputSince = since
            return []
        }
        
        await #expect(throws: Never.self) {
            // when
            let respoonse = try await sut.getGithubUsers(page: page)
            
            // then
            #expect(respoonse.count == 0)
            let inputPerPage = try #require(inputPerPage)
            #expect(inputPerPage == 20)
            let inputSince = try #require(inputSince)
            #expect(inputSince == 20 * page)
        }
    }
    
    
    @Test(
        "Test getGithubUsers size of returned users",
        arguments: [0, 20, 40, 60]
    )
    func getGithubUsersSizeOfReturnUsers(count: Int) async {
        // given
        let sut = makeSUT { perPage, since in
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
        let arrayOfUsers: [FetchGithubUsersResponse] = .init(count: count)
        let githubUsers = arrayOfUsers.map { $0.githubUser }
        
        let sut = makeSUT { perPage, since in
            arrayOfUsers
        }
        
        await #expect(throws: Never.self) {
            // when
            let response = try await sut.getGithubUsers(page: page)
            
            // then
            #expect(count == response.count)
            #expect(arrayOfUsers.count == response.count)
            #expect(githubUsers.count == response.count)
            #expect(githubUsers == response)
            
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
        
        let sut = makeSUT { _, _ in
            throw error
        }
        
        await #expect(throws: error) {
            // when
            try await sut.getGithubUsers(page: 0)
        }
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
        let mockUserDetails = FetchGithubUserDetailsResponse(randomBy: loginUsername)
        
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
