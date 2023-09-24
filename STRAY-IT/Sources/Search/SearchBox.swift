import SwiftUI

public struct SearchBox: View {
    @AppStorage("hasShownTutorial")
    private var hasShownTutorial: Bool = false
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
                .foregroundStyle(Color(.accent))
            HStack {
                Image(systemName: "magnifyingglass")
                    .bold()
                TextField(text: $text) {
                    Text("Search")
                        .foregroundStyle(Color(.background))
                }
                .onChange(of: text) {
                    searchQuery = text
                }
                .focused($isFocused)
                .accentColor(Color(.background))
            }
            .foregroundStyle(Color(.background))
            .padding(.leading, 12)
        }
        .frame(height: 40)
        .cornerRadius(24)
        .onAppear {
            if self.hasShownTutorial {
                self.isFocused = true
            }
        }
    }
}

#Preview {
    SearchBox(searchQuery: .constant(""))
}
