import SwiftUI

private struct RemoveDefaultListItem: ViewModifier {
    func body(content: Content) -> some View {
        content
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)
            .listRowInsets(
                EdgeInsets(
                    top: 0,
                    leading: 16,
                    bottom: 0,
                    trailing: 16
                )
            )
    }
}

extension View {
    @ViewBuilder func removeDefaultListItem() -> some View {
        modifier(RemoveDefaultListItem())
    }
}
