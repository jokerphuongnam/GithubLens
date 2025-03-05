import SwiftUI

struct GithubUserDetailsScreen: View {
    private let viewModel: GithubUserDetailsViewModel
    @Environment(\.dismiss) var dismiss
    
    init(viewModel: GithubUserDetailsViewModel, loginUsername: String) {
        self.viewModel = viewModel
        viewModel.loadUserDetails(loginUsername: loginUsername)
    }
    
    var body: some View {
        contentView
            .navigationTitle("User Details")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden()
            .navigationBarItems(leading: backButton)
    }
    
    @ViewBuilder private var backButton: some View {
        Button {
            dismiss()
        } label: {
            Asset.Assets.backIcon.swiftUIImage.resizable()
                .renderingMode(.template)
                .frame(width: 24, height: 24)
                .padding(4)
                .foregroundColor(Color(r: 73, g: 81, b: 95))
        }
    }
    
    @ViewBuilder private var contentView: some View {
        switch viewModel.userDetailsState {
        case .loading:
            loadingView
        case .success(data: let data):
            successView(data: data)
        case .failure(error: let error):
            failureView(error: error)
        }
    }
    
    @ViewBuilder private var loadingView: some View {
        ProgressView()
    }
    
    @ViewBuilder private func successView(data: GithubUserDetails) -> some View {
        VStack(spacing: 16) {
            bannerView(data: data)
                .frame(height: 100)
            
            followInfoView(data: data)
            
            blockView(data: data)
            
            Spacer()
        }
        .padding(.horizontal, 16)
    }
    
    @ViewBuilder private func failureView(error: Error) -> some View {
        VStack(spacing: 8) {
            Text("Error load user details")
                .font(.system(size: 16))
                .foregroundStyle(Color(r: 237, g: 67, b: 55))
            
            Button {
                viewModel.reloadUserDetails()
            } label: {
                Text("Retry?")
                    .foregroundStyle(Color(r: 185, g: 205, b: 235))
                    .font(.system(size: 14))
                    .underline()
            }
        }
    }
    
    @ViewBuilder private func bannerView(data: GithubUserDetails) -> some View {
        HStack(alignment: .center, spacing: 12) {
            Color(r: 247, g: 247, b: 247)
                .frame(maxHeight: .infinity, alignment: .center)
                .aspectRatio(1.0, contentMode: .fit)
                .cornerRadius(8)
                .overlay(alignment: .center) {
                    if let url = URL(string: data.avatarUrl) {
                        KingfisherNetworkImage(url: url)
                            .clipShape(Circle())
                            .padding(8)
                    }
                }
            
            VStack(alignment: .leading, spacing: 8) {
                Text(data.login)
                    .bold()
                    .font(.system(size: 24))
                    .foregroundStyle(Color(r: 35, g: 43, b: 55))
                
                Divider()
                    .background(Color(r: 233, g: 234, b: 237))
                    .frame(height: 1)
                
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
    
    @ViewBuilder private func followInfoView(data: GithubUserDetails) -> some View {
        HStack(spacing: 16) {
            if let followers = data.followers {
                FollowView(
                    number: followers,
                    title: "Follower",
                    icon: Asset.Assets.multipleUsersIcon.swiftUIImage.resizable()
                        .renderingMode(.template)
                )
            }
            
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
    
    @ViewBuilder private func blockView(data: GithubUserDetails) -> some View {
        if let url = URL(string: data.htmlUrl) {
            VStack(alignment: .leading) {
                Text("Blog")
                    .bold()
                    .font(.system(size: 16))
                    .foregroundColor(Color(r: 35, g: 43, b: 55))
                
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
