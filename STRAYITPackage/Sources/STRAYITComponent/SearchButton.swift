import STRAYITResource
import SwiftUI

public struct SearchButton: View {
    private let action: () -> Void

    public init(action: @escaping () -> Void) {
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            Image(systemName: "magnifyingglass")
                .accessibilityLabel("Search")
                .font(.system(size: 24, weight: .bold))
                .foregroundStyle(Color.secondaryFont)
                .padding(16)
                .background(Color.secondaryBackground)
                .clipShape(Circle())
        }
    }
}

#Preview {
    SearchButton {
        print("Tapped")
    }
}
