import SwiftUI

struct FollowView: View {
    // Number to display (either followers count or following count)
    let number: Int
    // Title for the count (e.g., "Follower" or "Following")
    let title: String
    // Icon image to display within the circle
    let icon: Image
    
    // Custom initializer for FollowView.
    init(number: Int, title: String, icon: Image) {
        self.number = number
        self.title = title
        self.icon = icon
    }
    
    var body: some View {
        // Vertical stack to arrange the icon and texts.
        VStack(spacing: 0) {
            // Circular background for the icon.
            Color(r: 243, g: 244, b: 245)
                .clipShape(Circle())
                .frame(width: 48, height: 48)
                // Overlay the icon image on top of the circular background.
                .overlay {
                    icon
                        .resizable()
                        .renderingMode(.template)
                        .foregroundColor(Color(r: 31, g: 42, b: 56))
                        .frame(width: 24, height: 24)
                }
            
            // Spacer for a small vertical gap.
            Spacer()
                .frame(height: 2)
            
            // Display the formatted number (e.g., "9", "10+", etc.)
            Text("\(numberFormatted)")
                .fontWeight(.semibold)
                .font(.system(size: 12))
            
            // Spacer for additional vertical gap.
            Spacer()
                .frame(height: 4)
            
            // Display the title text.
            Text(title)
                .font(.system(size: 14))
                .foregroundColor(Color(r: 149, g: 152, b: 162))
        }
    }
    
    // Computed property to format the number.
    private var numberFormatted: String {
        // If the number is less than 10, simply return it as a string.
        if number < 10 {
            return "\(number)"
        }
        
        // Determine the number of digits in the number.
        let digits = String(number).count
        
        // Calculate the "round" number which is 10^(digits - 1).
        // For example, if number = 45 (2 digits), roundNumber will be 10.
        let roundNumber = Int(pow(10.0, Double(digits - 1)))
        
        // If the number exactly equals the round number, return it as-is.
        // Otherwise, return the round number with a plus sign (e.g., "10+").
        return number == roundNumber ? "\(number)" : "\(roundNumber)+"
    }
}
