@testable import GithubLens

extension GithubUserDetails {
    init(randomBy loginUserName: String) {
        // Generate a random avatar URL with a random number to simulate different users.
        let randomAvatarNumber = Int.random(in: 1...10000)
        let randomAvatarURL = "https://avatars.githubusercontent.com/u/\(randomAvatarNumber)"
        
        // Use the login for the htmlURL.
        let randomHtmlURL = "https://github.com/\(loginUserName)"
        
        // For optional fields, randomly decide if the field is nil or a random value.
        let randomLocation: String? = Bool.random() ? nil : "Location \(Int.random(in: 1...100))"
        let randomFollowers: Int? = Bool.random() ? nil : Int.random(in: 0...5000)
        let randomFollowing: Int? = Bool.random() ? nil : Int.random(in: 0...5000)
        
        self.init(
            login: loginUserName,
            avatarUrl: randomAvatarURL,
            htmlUrl: randomHtmlURL,
            location: randomLocation,
            followers: randomFollowers,
            following: randomFollowing
        )
    }
}
