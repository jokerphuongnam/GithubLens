import SwiftUI

// Define a custom view modifier that customizes the appearance of a list row.
private struct RemoveDefaultListItem: ViewModifier {
    // The body function applies the modifications to the provided content.
    func body(content: Content) -> some View {
        content
        // Set the background of the list row to be transparent.
            .listRowBackground(Color.clear)
        // Hide the default separator line between list items.
            .listRowSeparator(.hidden)
        // Customize the insets for the list row.
            .listRowInsets(
                EdgeInsets(
                    top: 0,      // No inset at the top.
                    leading: 16, // Add 16 points of inset on the leading side.
                    bottom: 0,   // No inset at the bottom.
                    trailing: 16 // Add 16 points of inset on the trailing side.
                )
            )
    }
}

// Extend the View protocol to easily apply the RemoveDefaultListItem modifier.
extension View {
    // This function applies the RemoveDefaultListItem modifier to any view.
    @ViewBuilder func removeDefaultListItem() -> some View {
        modifier(RemoveDefaultListItem())
    }
}
