extension Array {
    // A safe subscript that returns an element at the given index if it exists,
    // or nil if the index is out of bounds.
    subscript(safe index: Int) -> Element? {
        // Check if the index is within valid bounds (0 to count - 1).
        // If yes, return the element at that index; otherwise, return nil.
        index >= 0 && index < count ? self[index] : nil
    }
}
