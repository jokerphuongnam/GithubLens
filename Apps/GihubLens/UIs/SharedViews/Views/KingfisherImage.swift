import Kingfisher
import SwiftUI
import Foundation

@MainActor @ViewBuilder func KingfisherNetworkImage(url: URL) -> KFImage {
    KFImage.url(url)
        .resizable()
        .fade(duration: 0.5)
        .loadDiskFileSynchronously()
        .fromMemoryCacheOrRefresh(true)
        .cacheOriginalImage(true)
        .cacheMemoryOnly(false)
        .placeholder { progress in
            ProgressView(progress)
                .progressViewStyle(CircleProgressViewStyle())
        }
}

#if DEBUG
#Preview {
    KingfisherNetworkImage(url: URL(string: "https://avatars.githubusercontent.com/u/29?v=4")!)
        .padding(16)
}
#endif
