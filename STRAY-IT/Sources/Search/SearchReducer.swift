import ComposableArchitecture
import LocationManager
import MapKit
import SharedModel

public struct SearchReducer: Reducer {
    @Dependency(\.locationManager)
    private var locationManager: LocationManager

    public init() {}

    private struct SearchExecutionId: Hashable {}

    public struct State: Equatable {
        public var alert: AlertState<Action>?
        public var searchQuery: String
        public var request: MKLocalSearch.Request
        public var search: MKLocalSearch
        public var isSearching: Bool
        public var querySearchResults: [MKMapItem]
        public var searchExecutedTimestamp: Date?

        public init() {
            self.searchQuery = ""
            self.request = .init()
            self.request.resultTypes = [.address, .pointOfInterest]
            self.search = MKLocalSearch(request: request)
            self.isSearching = false
            self.querySearchResults = []
        }
    }

    public enum Action: Equatable {
        case onAppear
        case onDisappear
        case alertDismissed
        case setSearchQuery(String)
        case executeQuery
        case querySearchResponse(TaskResult<[MKMapItem]>)
        case onSelectResult(MKMapItem)
    }

    public func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .onAppear:
            state.searchQuery = ""
            state.querySearchResults = []
            return .none

        case .onDisappear:
            state.searchQuery = ""
            state.querySearchResults = []
            return .cancel(id: SearchExecutionId())

        case .alertDismissed:
            state.alert = nil
            return .none

        case let .setSearchQuery(newQuery):
            state.searchQuery = newQuery
            if newQuery.isEmpty {
                state.isSearching = false
                state.querySearchResults = []
            } else {
                state.isSearching = true
            }
            return .merge(
                .cancel(id: SearchExecutionId()),
                .run { send in
                    try? await Task.sleep(nanoseconds: 500_000_000)
                    await send(.executeQuery)
                }
                    .cancellable(id: SearchExecutionId())
            )

        case .executeQuery:
            if state.searchQuery.isEmpty {
                state.querySearchResults = []
                return .none
            }
            state.request.naturalLanguageQuery = state.searchQuery
            let search: MKLocalSearch = .init(request: state.request)
            return .run { send in
                await send(.querySearchResponse(TaskResult { try await search.start().mapItems }))
            }

        case let .querySearchResponse(.success(results)):
            state.querySearchResults = results
            state.searchExecutedTimestamp = Date.now
            state.isSearching = false
            return .none

        case let .querySearchResponse(.failure(error)):
            print(error.localizedDescription)
            state.alert = .init(
                title: .init("Error"),
                message: .init(error.localizedDescription)
            )
            state.querySearchResults = []
            state.isSearching = false
            return .none

        case let .onSelectResult(result):
            return .none
        }
    }
}
