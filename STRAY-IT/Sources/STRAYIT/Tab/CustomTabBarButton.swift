import Resource
import SharedModel
import SwiftUI

public struct CustomTabBarButton: View {
    private let tab: TabSelection
    @Binding public var selection: TabSelection

    public init(tab: TabSelection, selection: Binding<TabSelection>) {
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
                        tab.tabButtonIconFilledSymbol.swiftUIImage
                    } else {
                        tab.tabButtonIconSymbol.swiftUIImage
                    }
                }
                .font(.system(size: 32.0))
                .padding(.vertical, 1.0)

                Text(tab.rawValue.uppercased())
                    .font(.system(size: 12.0, design: .monospaced))
            }
            .foregroundColor(Asset.Colors.accent.swiftUIColor)
        })
    }
}

public struct CustomTabBarButton_Previews: PreviewProvider {
    public static var previews: some View {
        CustomTabBarButton(tab: .direction, selection: .constant(.direction))
    }
}
