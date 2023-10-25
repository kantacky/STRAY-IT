import ComposableArchitecture
import MapKit
import Models

public struct SearchReducer: Reducer {
    // MARK: - State
    public struct State: Equatable {
        var searchQuery: String
        var querySearchResults: [MKMapItem]
        var searchStatus: SearchStatus?

        public init() {
            self.searchQuery = ""
            self.querySearchResults = []
        }
    }

    public enum SearchStatus: Equatable {
        case searching
        case noResult
        case searched
    }

    // MARK: - Action
    public enum Action: Equatable {
        case onDisappear
        case setSearchQuery(String)
        case executeQuery
        case querySearchResponse(TaskResult<[MKMapItem]>)
        case onSelectResult(MKMapItem)
    }

    // MARK: - Dependency

    private struct SearchExecutionId: Hashable {}

    public init() {}

    // MARK: - Reducer
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onDisappear:
                return .cancel(id: SearchExecutionId())

            case let .setSearchQuery(newQuery):
                state.searchQuery = newQuery
                if newQuery.isEmpty {
                    state.searchStatus = nil
                    state.querySearchResults = []
                } else {
                    state.searchStatus = .searching
                }
                return .merge(
                    .cancel(id: SearchExecutionId()),
                    .run { send in
                        try await Task.sleep(nanoseconds: 1_000_000_000)
                        await send(.executeQuery)
                    }
                        .cancellable(id: SearchExecutionId())
                )

            case .executeQuery:
                if state.searchQuery.isEmpty {
                    state.querySearchResults = []
                    return .none
                }
                let request: MKLocalSearch.Request = .init()
                request.resultTypes = [.pointOfInterest]
                request.naturalLanguageQuery = state.searchQuery
                let search: MKLocalSearch = .init(request: request)
                return .run { send in
                    await send(.querySearchResponse(TaskResult {
                        try await search.start().mapItems
                    }))
                }

            case let .querySearchResponse(.success(results)):
                state.querySearchResults = results
                if results.isEmpty {
                    state.searchStatus = .noResult
                } else {
                    state.searchStatus = .searched
                }
                return .none

            case let .querySearchResponse(.failure(error)):
#if DEBUG
                print(error.localizedDescription)
#endif
                state.querySearchResults = []
                state.searchStatus = nil
                return .none

            case .onSelectResult(_):
                return .none
            }
        }
    }
}
