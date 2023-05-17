import Resource
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
            .tabViewStyle(.page(indexDisplayMode: .never))

            SliderIndicator(page: page)
        }
        .background(Asset.Colors.background.swiftUIColor)
    }
}

public struct TutorialView_Previews: PreviewProvider {
    public static var previews: some View {
        TutorialView()
    }
}
