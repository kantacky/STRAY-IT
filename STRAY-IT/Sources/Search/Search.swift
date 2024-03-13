import ComposableArchitecture
import Entity
import MapKit

@Reducer
public struct Search {
    // MARK: - State
    @ObservableState
    public struct State: Equatable {
        var searchQuery = ""
        var querySearchResults: [MKMapItem] = []
        var searchStatus: SearchStatus?

        public init() {}
    }

    public enum SearchStatus {
        case searching
        case noResult
        case searched
    }

    // MARK: - Action
    public enum Action {
        case onDisappear
        case setSearchQuery(String)
        case executeQuery
        case querySearchResponse(Result<[MKMapItem], Error>)
        case onSelectResult(MKMapItem)
    }

    // MARK: - Dependency

    private enum CancelID { case search }

    public init() {}

    // MARK: - Reducer
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onDisappear:
                return .cancel(id: CancelID.search)

            case let .setSearchQuery(newQuery):
                state.searchQuery = newQuery
                if newQuery.isEmpty {
                    state.searchStatus = nil
                    state.querySearchResults = []
                } else {
                    state.searchStatus = .searching
                }
                Task.cancel(id: CancelID.search)
                return .run { send in
                    try await Task.sleep(nanoseconds: 1_000_000_000)
                    await send(.executeQuery)
                }
                .cancellable(id: CancelID.search)

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
                    await send(.querySearchResponse(Result { try await search.start().mapItems }))
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
                print(error.localizedDescription)
                state.querySearchResults = []
                state.searchStatus = nil
                return .none

            case .onSelectResult(_):
                return .none
            }
        }
    }
}
