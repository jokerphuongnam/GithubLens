import Kingfisher
import SwiftUI
import Foundation

@MainActor @ViewBuilder func KingfisherNetworkImage(url: URL) -> KFImage {
    // Create a KFImage instance from the provided URL.
    KFImage.url(url)
        .resizable() // Allow the image to be resized to fit its container.
        .fade(duration: 0.5) // Apply a fade animation over 0.5 seconds when the image loads.
        .loadDiskFileSynchronously() // Attempt to load the image synchronously from disk if available.
        .fromMemoryCacheOrRefresh(true) // Use the image from memory cache or refresh if needed.
        .cacheOriginalImage(true) // Cache the original image for potential reuse.
        .cacheMemoryOnly(false) // Allow caching on disk in addition to memory.
        .placeholder { progress in
            // While the image is loading, display a progress view.
            // The progress view uses a custom circular style defined by CircleProgressViewStyle.
            ProgressView(progress)
                .progressViewStyle(CircleProgressViewStyle())
        }
}

#if DEBUG
#Preview {
    // Preview for the KingfisherNetworkImage function with a sample avatar URL.
    KingfisherNetworkImage(url: URL(string: "https://avatars.githubusercontent.com/u/29?v=4")!)
        .padding(16) // Apply padding around the preview for better visualization.
}
#endif
