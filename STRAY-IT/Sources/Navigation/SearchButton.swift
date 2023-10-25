import Assets
import SwiftUI

public struct SearchButton: View {
    public init() {}

    public var body: some View {
        Image(systemName: "magnifyingglass")
            .font(.title3)
            .bold()
            .foregroundStyle(ColorAssets.background)
            .padding()
            .background(ColorAssets.accent)
            .clipShape(Circle())
    }
}

#if DEBUG
#Preview {
    SearchButton()
}
#endif
