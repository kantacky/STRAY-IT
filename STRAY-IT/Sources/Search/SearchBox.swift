import ComposableArchitecture
import Resource
import SwiftUI

public struct SearchBox: View {
    @Binding public var searchQuery: String
    @Binding public var isSearchMode: Bool
    @FocusState private var isFocused: Bool

    public init(searchQuery: Binding<String>, isSearchMode: Binding<Bool>) {
        self._searchQuery = searchQuery
        self._isSearchMode = isSearchMode
    }

    public var body: some View {
            ZStack {
                Rectangle()
                    .foregroundColor(Asset.Colors.accent.swiftUIColor)
                HStack {
                    Button(action: {
                        isSearchMode = false
                    }, label: {
                        Image(systemName: "chevron.backward")
                            .bold()
                    })
                    TextField(text: $searchQuery) {
                        Text("Search")
                            .foregroundColor(Asset.Colors.background.swiftUIColor)
                    }
                    .focused($isFocused)
                    .accentColor(Asset.Colors.background.swiftUIColor)
                }
                .foregroundColor(Asset.Colors.background.swiftUIColor)
                .padding(.leading, 12)
            }
            .frame(height: 40)
            .cornerRadius(24)
    }
}

public struct SearchBox_Previews: PreviewProvider {
    public static var previews: some View {
        SearchBox(searchQuery: .constant(""), isSearchMode: .constant(true))
    }
}
