import Models
import Resources
import SwiftUI

public struct CustomTabBarButton: View {
    private let tab: TabItem
    @Binding public var selection: TabItem

    public init(tab: TabItem, selection: Binding<TabItem>) {
        self.tab = tab
        self._selection = selection
    }

    public var body: some View {
        Button(action: {
            selection = tab
        }, label: {
            VStack {
                VStack {
                    if selection == tab {
                        tab.tabButtonIconFilledSymbol
                    } else {
                        tab.tabButtonIconSymbol
                    }
                }
                .font(.system(size: 32.0))
                .padding(.vertical, 1.0)

                Text(tab.title)
                    .font(.system(size: 12.0, design: .monospaced))
            }
            .foregroundStyle(Color.accent)
        })
    }
}

#Preview {
    CustomTabBarButton(
        tab: .direction,
        selection: .constant(.direction)
    )
}
