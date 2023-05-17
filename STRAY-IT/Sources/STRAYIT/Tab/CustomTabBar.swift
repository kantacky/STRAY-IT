import Resource
import SharedModel
import SwiftUI

public struct CustomTabBar: View {
    @Binding public var selection: TabSelection

    public init(selection: Binding<TabSelection>) {
        self._selection = selection
    }

    public var body: some View {
        HStack {
            Spacer()
            CustomTabBarButton(tab: .direction, selection: $selection)
            Spacer()
            CustomTabBarButton(tab: .adventure, selection: $selection)
            Spacer()
            CustomTabBarButton(tab: .cheating, selection: $selection)
            Spacer()
        }
        .padding(.top, 4.0)
        .background(Asset.Colors.background.swiftUIColor)
    }
}

public struct CustomTabBar_Previews: PreviewProvider {
    public static var previews: some View {
        CustomTabBar(selection: .constant(.direction))
    }
}
