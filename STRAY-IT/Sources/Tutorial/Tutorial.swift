import ComposableArchitecture

@Reducer
public struct Tutorial {
    // MARK: - State
    @ObservableState
    public struct State {
        var page = 0

        public init() {}
    }

    // MARK: - Action
    public enum Action: BindableAction {
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
