import Resource
import SwiftUI

public struct InitialSearchView: View {
    @Binding public var isSearchMode: Bool

    public init(isSearchMode: Binding<Bool>) {
        self._isSearchMode = isSearchMode
    }

    public var body: some View {
        VStack {
            Button(action: {
                isSearchMode = true
            }, label: {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .padding(.trailing, 8.0)
                    Text("GO STRAY-IT!!")
                }
                .padding()
                .padding(.horizontal, 16.0)
                .font(.system(.title, design: .monospaced, weight: .bold))
                .foregroundColor(Asset.Colors.background.swiftUIColor)
            })
            .background(Asset.Colors.accent.swiftUIColor)
            .cornerRadius(64.0)
            .padding(.top, 64.0)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Asset.Colors.background.swiftUIColor)
    }
}

public struct InitialSearchView_Previews: PreviewProvider {
    public static var previews: some View {
        InitialSearchView(isSearchMode: .constant(false))
    }
}
