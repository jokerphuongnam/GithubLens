import SwiftUI

// Define a custom progress view style that draws a circular progress indicator.
struct CircleProgressViewStyle: ProgressViewStyle {
    // This method builds the view using the current progress configuration.
    @ViewBuilder func makeBody(configuration: Configuration) -> some View {
        // Retrieve the fraction of progress completed.
        // If not available, default to 0.
        let progress = configuration.fractionCompleted ?? 0
        
        // Use a ZStack to overlay the progress circle and text.
        ZStack {
            // Background circle (track) that shows the uncompleted portion.
            Circle()
                .stroke(lineWidth: 2)
                .opacity(0.3)
                .foregroundColor(.gray)
            
            // Only display the foreground progress circle and text if progress is greater than 0.
            if progress > 0 {
                // The progress circle representing the completed portion.
                Circle()
                // Trim the circle to display only a portion corresponding to the progress value.
                    .trim(from: 0, to: CGFloat(progress))
                    .stroke(
                        // Define stroke style with a 2-point line width and rounded ends.
                        style: StrokeStyle(lineWidth: 2, lineCap: .round)
                    )
                    .foregroundColor(.blue) // Set the color of the progress arc.
                // Rotate the circle so that progress starts at the top.
                    .rotationEffect(Angle(degrees: -90))
                // Animate changes in progress with a linear animation.
                    .animation(.linear, value: progress)
                
                // Display the progress percentage in text format.
                Text(formattedProgress(progress))
            }
        }
    }
    
    // Helper method to format the progress value as a percentage string.
    private func formattedProgress(_ progress: Double) -> String {
        // Convert the progress fraction to a percentage.
        let percentage = progress * 100
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        // Show no decimals for whole numbers, up to two decimals otherwise.
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        // Format the percentage value, defaulting to the raw value if formatting fails.
        let formatted = formatter.string(from: NSNumber(value: percentage)) ?? "\(percentage)"
        return "\(formatted)%"
    }
}

#if DEBUG
// Preview for the CircleProgressViewStyle using a fixed layout.
#Preview(traits: .fixedLayout(width: 100, height: 100)) {
    // Create a stateful progress object with a total unit count of 100.
    @Previewable @State var progress = Progress(totalUnitCount: 100)
    
    // Use a white background for the preview.
    Color.white
        .overlay {
            // Embed a ProgressView configured with the progress object.
            // Apply the custom CircleProgressViewStyle.
            ProgressView(progress)
                .progressViewStyle(CircleProgressViewStyle())
                .padding(16)
        }
    // Initialize the progress to 0 when the view appears.
        .onAppear {
            progress.completedUnitCount = 0
        }
    // On tap, simulate progress updates every second.
        .onTapGesture {
            Task { @MainActor in
                // Increment progress in steps of 10 until complete.
                for i in stride(from: 0, to: 101, by: 10) {
                    progress.completedUnitCount = Int64(i)
                    try await Task.sleep(for: .seconds(1))
                }
            }
        }
}
#endif
