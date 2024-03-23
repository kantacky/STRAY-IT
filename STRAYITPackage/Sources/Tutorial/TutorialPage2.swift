import ComposableArchitecture
import STRAYITNavigation
import SwiftUI

struct TutorialPage2: View {
    private let store: StoreOf<Tutorial>

    init(store: StoreOf<Tutorial>) {
        self.store = store
    }

    var body: some View {
        SearchButton {
            store.send(.onSearchButtonTapped)
        }
    }
}

#Preview {
    TutorialPage2(store: Store(initialState: Tutorial.State()) {
        Tutorial()
    })
}
