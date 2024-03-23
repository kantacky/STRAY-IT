import STRAYITEntity
import STRAYITResource
import SwiftUI

public struct CustomTabBarButton: View {
    private let mode: STRAYITNavigationMode
    @Binding public var selection: STRAYITNavigationMode

    public init(
        mode: STRAYITNavigationMode,
        selection: Binding<STRAYITNavigationMode>
    ) {
        self.mode = mode
        self._selection = selection
    }

    public var body: some View {
        Button(action: {
            selection = mode
        }, label: {
            VStack {
                VStack {
                    if selection == mode {
                        mode.tabButtonIconFilledSymbol
                    } else {
                        mode.tabButtonIconSymbol
                    }
                }
                .font(.system(size: 32.0))
                .padding(.vertical, 1.0)

                Text(mode.title)
                    .font(.system(size: 12.0, design: .monospaced))
            }
            .foregroundStyle(Color.primaryFont)
        })
    }
}

#Preview {
    CustomTabBarButton(
        mode: .direction,
        selection: .constant(.direction)
    )
}
