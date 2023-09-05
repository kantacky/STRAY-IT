import Resource
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
                .foregroundColor(Asset.Colors.accent.swiftUIColor)
            HStack {
                Image(systemName: "magnifyingglass")
                    .bold()
                TextField(text: $text) {
                    Text("Search")
                        .foregroundColor(Asset.Colors.background.swiftUIColor)
                }
                .onChange(of: text) {
                    searchQuery = text
                }
                .focused($isFocused)
                .accentColor(Asset.Colors.background.swiftUIColor)
            }
            .foregroundColor(Asset.Colors.background.swiftUIColor)
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
