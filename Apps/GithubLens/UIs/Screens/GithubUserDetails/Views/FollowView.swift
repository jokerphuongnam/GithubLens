import SwiftUI

struct FollowView: View {
    let number: Int
    let title: String
    let icon: Image
    
    init(number: Int, title: String, icon: Image) {
        self.number = number
        self.title = title
        self.icon = icon
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Color(r: 243, g: 244, b: 245)
                .clipShape(Circle())
                .frame(width: 48, height: 48)
                .overlay {
                    icon
                        .resizable()
                        .renderingMode(.template)
                        .foregroundColor(Color(r: 31, g: 42, b: 56))
                        .frame(width: 24, height: 24)
                }
            
            Spacer()
                .frame(height: 2)
            
            Text("\(numberFormatted)")
                .fontWeight(.semibold)
                .font(.system(size: 12))
            
            
            Spacer()
                .frame(height: 4)
            
            Text(title)
                .font(.system(size: 14))
                .foregroundColor(Color(r: 149, g: 152, b: 162))
        }
    }
    
    private var numberFormatted: String {
        // If the number is less than 10, return it directly as a string.
        if number < 10 {
            return "\(number)"
        }
        
        // Determine the number of digits in the number.
        let digits = String(number).count
        // Calculate the "round" number, which is 10^(digits - 1).
        let roundNumber = Int(pow(10.0, Double(digits - 1)))
        
        // If the number exactly equals the round number, return it without a plus sign.
        // Otherwise, return the round number with a plus sign.
        return number == roundNumber ? "\(number)" : "\(roundNumber)+"
    }
}
