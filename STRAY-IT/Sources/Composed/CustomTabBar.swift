import SharedModel
import SwiftUI

public struct CustomTabBar: View {
    @Binding public var selection: TabItem

    public init(selection: Binding<TabItem>) {
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
        .background(Color(.background))
    }
}

#Preview {
    CustomTabBar(selection: .constant(.direction))
}
