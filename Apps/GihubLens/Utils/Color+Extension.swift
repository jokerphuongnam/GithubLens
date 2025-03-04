import SwiftUI

extension Color {
    init(r: Int, g: Int, b: Int, a: Double = 1) {
        self.init(red: Double(r) / 255.0, green: Double(g) / 255, blue: Double(b) / 255, opacity: a)
    }
}
