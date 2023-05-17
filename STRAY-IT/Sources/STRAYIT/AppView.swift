import ComposableArchitecture
import Search
import SharedModel
import SwiftUI
import Tutorial

public struct AppView: View {
    @AppStorage("hasShownTutorial")
    private var hasShownTutorial: Bool = .init(false)
    private let store: StoreOf<AppReducer>

    public init() {
        self.store = Store(initialState: AppReducer.State(), reducer: AppReducer())
    }

    public var body: some View {
        WithViewStore(self.store, observe: { $0 }, content: { viewStore in
            VStack(spacing: 0) {
                if self.hasShownTutorial {
                    if viewStore.state.search.goal != nil {
                        if viewStore.state.isLoading {
                            ProgressView()
                        } else {
                            SelectedTabView(store: self.store)

                            CustomTabBar(selection: viewStore.binding(get: \.tabSelection, send: AppReducer.Action.setTabSelection))
                        }
                    } else {
                        SearchView(store: self.store.scope(state: \.search, action: AppReducer.Action.search))
                    }
                } else {
                    TutorialView()
                }
            }
            .alert(
                self.store.scope(state: \.alert),
                dismiss: .alertDismissed
            )
            .onAppear {
                viewStore.send(.onAppear)
            }
            .onDisappear {
                viewStore.send(.onDisappear)
            }
            .onOpenURL {
                viewStore.send(.openURL($0))
            }
        })
    }
}

public struct AppView_Previews: PreviewProvider {
    public static var previews: some View {
        AppView()
    }
}
