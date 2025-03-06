import SwiftUI

struct GithubUserDetailsScreen: View {
    // The view model that provides user details data.
    private let viewModel: GithubUserDetailsViewModel
    // Environment variable for dismissing the current view.
    @Environment(\.dismiss) var dismiss
    
    // Custom initializer takes a view model and a login username.
    // Immediately loads user details for the given username.
    init(viewModel: GithubUserDetailsViewModel, loginUsername: String) {
        self.viewModel = viewModel
        viewModel.loadUserDetails(loginUsername: loginUsername)
    }
    
    // The main body of the view.
    var body: some View {
        // The content is determined based on the current state of userDetailsState.
        contentView
            .navigationTitle("User Details")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden() // Hide the default back button.
            .navigationBarItems(leading: backButton) // Use a custom back button.
    }
    
    // Custom back button that dismisses the view.
    @ViewBuilder private var backButton: some View {
        Button {
            dismiss()
        } label: {
            // Render the custom back icon.
            Asset.Assets.backIcon.swiftUIImage
                .resizable()
                .renderingMode(.template)
                .frame(width: 24, height: 24)
                .padding(4)
                .foregroundColor(Color(r: 73, g: 81, b: 95))
        }
    }
    
    // The content view changes based on the current state of userDetailsState.
    @ViewBuilder private var contentView: some View {
        switch viewModel.userDetailsState {
        case .loading:
            // Show a progress indicator while data is loading.
            loadingView
        case .success(data: let data):
            // On successful data fetch, show the user details view.
            successView(data: data)
        case .failure(error: let error):
            // On failure, show an error view with a retry option.
            failureView(error: error)
        }
    }
    
    // A simple loading view with a progress indicator.
    @ViewBuilder private var loadingView: some View {
        ProgressView()
    }
    
    // The view shown when user details are successfully loaded.
    @ViewBuilder private func successView(data: GithubUserDetails) -> some View {
        VStack(spacing: 16) {
            // Display a banner with the user's avatar and basic info.
            bannerView(data: data)
                .frame(height: 100)
            
            // Display follow information (followers and following counts).
            followInfoView(data: data)
            
            // Display a block for additional user info, such as blog/website.
            blockView(data: data)
            
            // Spacer pushes the content toward the top.
            Spacer()
        }
        .padding(.horizontal, 16)
    }
    
    // View for displaying errors with a retry button.
    @ViewBuilder private func failureView(error: Error) -> some View {
        VStack(spacing: 8) {
            Text("Error load user details")
                .font(.system(size: 16))
                .foregroundStyle(Color(r: 237, g: 67, b: 55))
            
            Button {
                // Retry loading user details when tapped.
                viewModel.reloadUserDetails()
            } label: {
                Text("Retry?")
                    .foregroundStyle(Color(r: 185, g: 205, b: 235))
                    .font(.system(size: 14))
                    .underline()
            }
        }
    }
    
    // Banner view displaying the user's avatar, login, and location.
    @ViewBuilder private func bannerView(data: GithubUserDetails) -> some View {
        HStack(alignment: .center, spacing: 12) {
            // Display a colored placeholder for the avatar.
            Color(r: 247, g: 247, b: 247)
                .frame(maxHeight: .infinity, alignment: .center)
                .aspectRatio(1.0, contentMode: .fit)
                .cornerRadius(8)
                .overlay(alignment: .center) {
                    // If avatar URL is valid, load the image using Kingfisher.
                    if let url = URL(string: data.avatarUrl) {
                        KingfisherNetworkImage(url: url)
                            .clipShape(Circle())
                            .padding(8)
                    }
                }
            
            VStack(alignment: .leading, spacing: 8) {
                // Display the user's login name in bold.
                Text(data.login)
                    .bold()
                    .font(.system(size: 24))
                    .foregroundStyle(Color(r: 35, g: 43, b: 55))
                
                // Divider to separate the login from the location.
                Divider()
                    .background(Color(r: 233, g: 234, b: 237))
                    .frame(height: 1)
                
                // If available, show the user's location with an icon.
                if let location = data.location {
                    HStack(spacing: 4) {
                        Asset.Assets.locationIcon.swiftUIImage
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor(Color(r: 141, g: 146, b: 154))
                            .frame(width: 16, height: 16)
                        
                        Text(location)
                            .foregroundStyle(Color(r: 141, g: 146, b: 154))
                            .font(.system(size: 14))
                    }
                }
                
                Spacer()
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .cornerRadius(12)
        .background {
            // Background with white color and a shadow effect.
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
    
    // Displays follower and following counts if available.
    @ViewBuilder private func followInfoView(data: GithubUserDetails) -> some View {
        HStack(spacing: 16) {
            // Display follower information if available.
            if let followers = data.followers {
                FollowView(
                    number: followers,
                    title: "Follower",
                    icon: Asset.Assets.multipleUsersIcon.swiftUIImage.resizable()
                        .renderingMode(.template)
                )
            }
            
            // Display following information if available.
            if let following = data.following {
                FollowView(
                    number: following,
                    title: "Following",
                    icon: Asset.Assets.multipleUsersIcon.swiftUIImage.resizable()
                        .renderingMode(.template)
                )
            }
        }
    }
    
    // Displays the user's blog or website URL as a clickable link.
    @ViewBuilder private func blockView(data: GithubUserDetails) -> some View {
        // Verify the URL is valid.
        if let url = URL(string: data.htmlUrl) {
            VStack(alignment: .leading) {
                Text("Blog")
                    .bold()
                    .font(.system(size: 16))
                    .foregroundColor(Color(r: 35, g: 43, b: 55))
                
                // A clickable link that navigates to the user's blog.
                Link(destination: url) {
                    Text(data.htmlUrl)
                        .foregroundStyle(Color(r: 156, g: 160, b: 168))
                        .font(.system(size: 14))
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}
