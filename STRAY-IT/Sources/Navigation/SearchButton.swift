import Resources
import SwiftUI

public struct SearchButton: View {
    private let action: () -> Void

    public init(action: @escaping () -> Void) {
        self.action = action
    }

    public var body: some View {
        Button {
            self.action()
        } label: {
            Image(systemName: "magnifyingglass")
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
