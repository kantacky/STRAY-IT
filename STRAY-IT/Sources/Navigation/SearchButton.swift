import Resources
import SwiftUI

public struct SearchButton: View {
    public init() {}

    public var body: some View {
        Image(systemName: "magnifyingglass")
            .font(.system(size: 24, weight: .bold))
            .foregroundStyle(Color.secondaryFont)
            .padding(16)
            .background(Color.secondaryBackground)
            .clipShape(Circle())
    }
}

#Preview {
    SearchButton()
}
