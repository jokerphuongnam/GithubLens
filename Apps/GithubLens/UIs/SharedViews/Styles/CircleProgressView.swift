import SwiftUI

struct CircleProgressViewStyle: ProgressViewStyle {
    @ViewBuilder func makeBody(configuration: Configuration) -> some View {
        // Use the fractionCompleted from the configuration.
        let progress = configuration.fractionCompleted ?? 0
        
        ZStack {
            // Background circle (track)
            Circle()
                .stroke(lineWidth: 2)
                .opacity(0.3)
                .foregroundColor(.gray)
            
            // Foreground progress circle only if progress > 0
            if progress > 0 {
                Circle()
                    .trim(from: 0, to: CGFloat(progress))
                    .stroke(
                        style: StrokeStyle(lineWidth: 2, lineCap: .round)
                    )
                    .foregroundColor(.blue)
                    .rotationEffect(Angle(degrees: -90))
                    .animation(.linear, value: progress)
                
                Text(formattedProgress(progress))
            }
        }
    }
    
    private func formattedProgress(_ progress: Double) -> String {
        // Multiply by 100 to get percentage.
        let percentage = progress * 100
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        // The formatter will show no decimals for whole numbers,
        // one decimal if needed, or two decimals if necessary.
        let formatted = formatter.string(from: NSNumber(value: percentage)) ?? "\(percentage)"
        return "\(formatted)%"
    }
}

#if DEBUG
#Preview(traits: .fixedLayout(width: 100, height: 100)) {
    @Previewable @State var progress = Progress(totalUnitCount: 100)
    
    Color.white
        .overlay {
            ProgressView(progress)
                .progressViewStyle(CircleProgressViewStyle())
                .padding(16)
        }
        .onAppear {
            progress.completedUnitCount = 0
        }
        .onTapGesture {
            Task { @MainActor in
                for i in stride(from: 0, to: 101, by: 10) {
                    progress.completedUnitCount = Int64(i)
                    try await Task.sleep(for: .seconds(1))
                }
            }
        }
}
#endif
