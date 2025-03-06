@testable import GithubLensNetworks

extension Array where Element == FetchGithubUsersResponse {
    static func random() -> FetchGithubUsersResponse {
        // Create a random login name.
        let randomNumber = Int.random(in: 1000...9999)
        let randomLogin = "user\(randomNumber)"
        
        // Generate a random avatar URL with a random number to simulate different users.
        let randomAvatarNumber = Int.random(in: 1...10000)
        let randomAvatarURL = "https://avatars.githubusercontent.com/u/\(randomAvatarNumber)"
        
        // Use the login for the htmlURL.
        let randomHtmlURL = "https://github.com/\(randomLogin)"
        
        return FetchGithubUsersResponse(
            login: randomLogin,
            avatarURL: randomAvatarURL,
            htmlURL: randomHtmlURL
        )
    }
    
    /// Generates an array of random FetchGithubUsersResponse objects.
    static func generateMock(count: Int) -> [FetchGithubUsersResponse] {
        return (0..<count).map { _ in Array.random() }
    }
    
    init(count: Int) {
        self = Self.generateMock(count: count)
    }
}
