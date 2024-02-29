import ComposableArchitecture
import Resources
import SwiftUI

public struct TutorialView: View {
    @Bindable private var store: StoreOf<Tutorial>

    public init(store: StoreOf<Tutorial>) {
        self.store = store
    }

    public var body: some View {
        VStack {
            TabView(selection: $store.page) {
                TutorialPage0()
                    .tag(0)
                TutorialPage1()
                    .tag(1)
                TutorialPage2(store: self.store)
                    .tag(2)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))

            SliderIndicator(page: $store.page)
        }
        .background(Color.primaryBackground)
    }
}

#Preview {
    TutorialView(store: Store(initialState: Tutorial.State()) {
        Tutorial()
    })
}
