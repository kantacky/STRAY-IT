import Models
import Resources
import SwiftUI

struct CustomTabBar: View {
    @Binding private var selection: TabItem

    init(selection: Binding<TabItem>) {
        self._selection = selection
    }

    var body: some View {
        HStack {
            Spacer()
            ForEach(TabItem.allCases) { item in
                CustomTabBarButton(tab: item, selection: $selection)
                Spacer()
            }
        }
        .padding(.top, 4.0)
        .background(Color.background)
    }
}

#Preview {
    CustomTabBar(selection: .constant(.direction))
}
