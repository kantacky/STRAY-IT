import ComposableArchitecture
import Resource
import SwiftUI

public struct SearchBox: View {
    @State private var text: String
    @Binding public var searchQuery: String
    @FocusState private var isFocused: Bool

    public init(searchQuery: Binding<String>) {
        self._text = .init(initialValue: "")
        self._searchQuery = searchQuery
    }

    public var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(Asset.Colors.accent.swiftUIColor)
            HStack {
                Image(systemName: "magnifyingglass")
                    .bold()
                TextField(text: $text) {
                    Text("Search")
                        .foregroundColor(Asset.Colors.background.swiftUIColor)
                }
                .onChange(of: text) { newText in
                    searchQuery = newText
                }
                .focused($isFocused)
                .accentColor(Asset.Colors.background.swiftUIColor)
            }
            .foregroundColor(Asset.Colors.background.swiftUIColor)
            .padding(.leading, 12)
        }
        .frame(height: 40)
        .cornerRadius(24)
        .task {
            isFocused = true
        }
    }
}

public struct SearchBox_Previews: PreviewProvider {
    public static var previews: some View {
        SearchBox(searchQuery: .constant(""))
    }
}
