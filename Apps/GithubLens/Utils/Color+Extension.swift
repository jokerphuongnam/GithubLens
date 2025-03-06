import SwiftUI

extension Color {
    /// Creates a Color instance using integer RGB values (0–255) and an optional alpha value (default is 1).
    /// - Parameters:
    ///   - r: The red component as an integer (0–255).
    ///   - g: The green component as an integer (0–255).
    ///   - b: The blue component as an integer (0–255).
    ///   - a: The alpha (opacity) value as a Double (default is 1 for fully opaque).
    init(r: Int, g: Int, b: Int, a: Double = 1) {
        // Convert integer values to a Double between 0 and 1, and initialize the Color.
        self.init(
            red: Double(r) / 255.0,
            green: Double(g) / 255.0,
            blue: Double(b) / 255.0,
            opacity: a
        )
    }
}
