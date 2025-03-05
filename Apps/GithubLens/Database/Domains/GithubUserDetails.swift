import GithubLensNetworks

struct GithubUserDetails: Hashable {
    let login: String
    let avatarUrl: String
    let htmlUrl: String
    let location: String?
    let followers: Int?
    let following: Int?
}

extension FetchGithubUserDetailsResponse {
    var githubUserDetails: GithubUserDetails {
        GithubUserDetails(
            login: login,
            avatarUrl: avatarUrl,
            htmlUrl: htmlUrl,
            location: location,
            followers: followers,
            following: following
        )
    }
}
