import SwiftUI

public struct SearchButton: View {
    public init() {}

    public var body: some View {
        Image(systemName: "magnifyingglass")
            .font(.title3)
            .bold()
            .foregroundStyle(Color(.background))
            .padding()
            .background(Color(.accent))
            .clipShape(Circle())
    }
}

#Preview {
    SearchButton()
}
