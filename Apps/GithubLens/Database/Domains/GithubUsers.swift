import GithubLensNetworks

struct GithubUser: Hashable {
    let login: String
    let avatarURL: String
    let htmlURL: String
}

extension FetchGithubUsersResponse {
    var githubUser: GithubUser {
        GithubUser(
            login: login,
            avatarURL: avatarURL,
            htmlURL: htmlURL
        )
    }
}
