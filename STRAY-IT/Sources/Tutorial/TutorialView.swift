import Assets
import SwiftUI

public struct TutorialView: View {
    @State private var page: Int

    public init() {
        self.page = 0
    }

    public var body: some View {
        VStack {
            TabView(selection: $page) {
                TutorialPage0()
                    .tag(0)
                TutorialPage1()
                    .tag(1)
                TutorialPage2()
                    .tag(2)
            }
            #if os(iOS)
            .tabViewStyle(.page(indexDisplayMode: .never))
            #endif

            SliderIndicator(page: $page)
        }
        .background(ColorAssets.background)
    }
}

#if DEBUG
#Preview {
    TutorialView()
}
#endif
