import STRAYITEntity
import STRAYITResource
import SwiftUI

struct CustomTabBar: View {
    @Binding private var mode: STRAYITNavigationMode

    init(mode: Binding<STRAYITNavigationMode>) {
        self._mode = mode
    }

    var body: some View {
        HStack {
            Spacer()
            ForEach(STRAYITNavigationMode.allCases) { item in
                CustomTabBarButton(mode: item, selection: $mode)
                Spacer()
            }
        }
        .padding(.top, 4.0)
        .background(Color.primaryBackground)
    }
}

#Preview {
    @State var mode: STRAYITNavigationMode = .direction

    return CustomTabBar(mode: $mode)
}
