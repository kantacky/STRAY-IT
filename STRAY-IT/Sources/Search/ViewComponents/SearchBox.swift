import Resources
import SwiftUI

public struct SearchBox: View {
    @State private var text: String
    @Binding private var searchQuery: String
    @FocusState private var isFocused: Bool

    public init(searchQuery: Binding<String>) {
        self._text = .init(initialValue: "")
        self._searchQuery = searchQuery
    }

    public var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .bold()
            TextField(text: $text) {
                Text("Search", bundle: .module)
                    .foregroundStyle(Color.secondaryFont)
            }
            .onChange(of: text) {
                searchQuery = text
            }
            .focused($isFocused)
            .accentColor(Color.secondaryFont)
        }
        .padding(12)
        .foregroundStyle(Color.secondaryFont)
        .background(Color.secondaryBackground)
        .frame(height: 40)
        .clipShape(Capsule())
        .onAppear {
            self.isFocused = true
        }
    }
}

#Preview {
    SearchBox(searchQuery: .constant(""))
}
