import ComposableArchitecture

@Reducer
public struct TutorialReducer {
    // MARK: - State
    public struct State: Equatable {
        @BindingState var page: Int

        public init() {
            self.page = 0
        }
    }

    // MARK: - Action
    public enum Action: Equatable, BindableAction {
        case binding(BindingAction<State>)
        case onSearchButtonTapped
    }

    // MARK: - Dependencies

    public init() {}

    // MARK: - Reducer
    public var body: some ReducerOf<Self> {
        BindingReducer()

        Reduce { state, action in
            switch action {
            case .binding:
                return .none

            case .onSearchButtonTapped:
                return .none
            }
        }
    }
}
