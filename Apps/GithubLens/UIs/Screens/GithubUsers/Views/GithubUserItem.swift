import SwiftUI
import Kingfisher

struct GithubUserItem: View {
    private let githubUser: GithubUser
    
    init(githubUser: GithubUser) {
        self.githubUser = githubUser
    }
    
    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            Color(r: 247, g: 247, b: 247)
                .frame(maxHeight: .infinity, alignment: .center)
                .aspectRatio(1.0, contentMode: .fit)
                .cornerRadius(8)
                .overlay(alignment: .center) {
                    if let url = URL(string: githubUser.avatarURL) {
                        KingfisherNetworkImage(url: url)
                            .clipShape(Circle())
                            .padding(8)
                    }
                }
            
            VStack(alignment: .leading, spacing: 8) {
                Text(githubUser.login)
                    .bold()
                    .font(.system(size: 24))
                    .foregroundStyle(Color(r: 35, g: 43, b: 55))
                
                Divider()
                    .background(Color(r: 233, g: 234, b: 237))
                    .frame(height: 1)
                
                if let url = URL(string: githubUser.htmlURL) {
                    Link(destination: url) {
                        Text(githubUser.htmlURL)
                            .foregroundStyle(Color(r: 185, g: 205, b: 235))
                            .font(.system(size: 14))
                            .underline()
                    }
                }
                
                Spacer()
            }
            
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .cornerRadius(12)
        .background {
            Color.white
                .cornerRadius(12)
                .shadow(
                    color: Color(r: 227, g: 227, b: 227),
                    radius: 10,
                    x: 10,
                    y: 10
                )
        }
    }
}

#if DEBUG
#Preview(traits: .fixedLayout(width: 440, height: 100)) {
    GithubUserItem(
        githubUser: GithubUser(
            login: "vanpelt",
            avatarURL: "https://avatars.githubusercontent.com/u/29?v=4",
            htmlURL: "https://github.com/vanpelt"
        )
    )
    .padding(12)
}
#endif
