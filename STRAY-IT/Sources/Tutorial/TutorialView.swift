import ComposableArchitecture
import Resources
import SwiftUI

public struct TutorialView: View {
    public typealias Reducer = TutorialReducer
    private let store: StoreOf<Reducer>
    @StateObject private var viewStore: ViewStoreOf<Reducer>

    public init(store: StoreOf<Reducer>) {
        self.store = store
        self._viewStore = .init(wrappedValue: ViewStore(store, observe: { $0 }))
    }

    public var body: some View {
        VStack {
            TabView(selection: self.viewStore.$page) {
                TutorialPage0()
                    .tag(0)
                TutorialPage1()
                    .tag(1)
                TutorialPage2(store: self.store)
                    .tag(2)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))

            SliderIndicator(page: self.viewStore.$page)
        }
        .background(Color.background)
    }
}

#Preview {
    TutorialView(store: Store(initialState: TutorialView.Reducer.State()) {
        TutorialView.Reducer()
    })
}
