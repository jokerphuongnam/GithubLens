import SwiftUI
import Kingfisher

struct GithubUserItem: View {
    // The GithubUser model containing the data to be displayed.
    private let githubUser: GithubUser
    
    // Custom initializer to inject a GithubUser instance.
    init(githubUser: GithubUser) {
        self.githubUser = githubUser
    }
    
    // The view's body describing its UI layout.
    var body: some View {
        // A horizontal stack to arrange the avatar and user info side by side.
        HStack(alignment: .center, spacing: 12) {
            // Left section: displays the user's avatar.
            Color(r: 247, g: 247, b: 247)
                .frame(maxHeight: .infinity, alignment: .center)
                .aspectRatio(1.0, contentMode: .fit)
                .cornerRadius(8)
                // Overlay to show the avatar image on top of the colored background.
                .overlay(alignment: .center) {
                    // Safely unwrap and validate the avatar URL.
                    if let url = URL(string: githubUser.avatarURL) {
                        // KingfisherNetworkImage is used to load the image asynchronously.
                        KingfisherNetworkImage(url: url)
                            .clipShape(Circle()) // Clip the image into a circular shape.
                            .padding(8)
                    }
                }
            
            // Right section: displays the user's login name and profile URL.
            VStack(alignment: .leading, spacing: 8) {
                // Display the user's login in bold with a large font.
                Text(githubUser.login)
                    .bold()
                    .font(.system(size: 24))
                    .foregroundStyle(Color(r: 35, g: 43, b: 55))
                
                // Divider to separate the login from the profile URL.
                Divider()
                    .background(Color(r: 233, g: 234, b: 237))
                    .frame(height: 1)
                
                // If the profile URL is valid, display it as a clickable link.
                if let url = URL(string: githubUser.htmlURL) {
                    Link(destination: url) {
                        Text(githubUser.htmlURL)
                            .foregroundStyle(Color(r: 185, g: 205, b: 235))
                            .font(.system(size: 14))
                            .underline()
                    }
                }
                
                // Spacer to push content to the top.
                Spacer()
            }
        }
        // Padding around the entire HStack.
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        // Rounded corners for the overall view.
        .cornerRadius(12)
        // Background styling: white background with rounded corners and a subtle shadow.
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
