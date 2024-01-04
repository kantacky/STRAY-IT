import ComposableArchitecture
import Navigation
import SwiftUI

struct TutorialPage2: View {
    typealias Reducer = TutorialReducer
    private let store: StoreOf<Reducer>
    @StateObject private var viewStore: ViewStoreOf<Reducer>

    init(store: StoreOf<Reducer>) {
        self.store = store
        self._viewStore = .init(wrappedValue: ViewStore(store, observe: { $0 }))
    }

    var body: some View {
        SearchButton {
            self.viewStore.send(.onSearchButtonTapped)
        }
    }
}

#Preview {
    TutorialPage2(store: Store(initialState: TutorialView.Reducer.State()) {
        TutorialView.Reducer()
    })
}
