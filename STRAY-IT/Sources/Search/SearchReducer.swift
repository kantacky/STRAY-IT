import ComposableArchitecture
import Dependency
import ExtendedMKModels
import MapKit
import SharedLogic

public struct SearchReducer: ReducerProtocol {
    @Dependency(\.userDefaults)
    private var userDefaults: UserDefaultsClient

    public init() {}

    private struct SearchExecutionId: Hashable {}

    public struct State: Equatable {
        public var isLoading: Bool
        public var alert: AlertState<Action>?
        public var searchQuery: String
        public var request: MKLocalSearch.Request
        public var search: MKLocalSearch
        public var isSearching: Bool
        public var querySearchResults: [MKMapItem]
        public var goal: Annotation?
        public var searchExecutedTimestamp: Date?

        public init() {
            self.isLoading = false
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
        case setStartAndGoalResponse(TaskResult<Bool>)
    }

    public func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
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
                .task {
                    try? await Task.sleep(nanoseconds: 500_000_000)
                    return .executeQuery
                }
                .cancellable(id: SearchExecutionId())
            )

        case .executeQuery:
            if state.searchQuery.isEmpty {
                state.querySearchResults = []
                return .none
            }
            state.request.naturalLanguageQuery = state.searchQuery
            state.search = MKLocalSearch(request: state.request)
            return .task { [search = state.search] in
                await .querySearchResponse(TaskResult { try await search.start().mapItems })
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
            let coordinate: CLLocationCoordinate2D = result.placemark.coordinate
            let title: String? = result.name
            state.goal = .init(coordinate: coordinate, title: title)
            return .task { [goal = state.goal] in
                .setStartAndGoalResponse(
                    await TaskResult {
                        let startCoordinate: CLLocationCoordinate2D = try userDefaults.customType(forKey: UserDefaultsKeys.currentLocation)
                        let start: Annotation = .init(coordinate: startCoordinate)

                        try await userDefaults.set(start, forKey: UserDefaultsKeys.start)
                        try await userDefaults.set(goal, forKey: UserDefaultsKeys.goal)
                        return true
                    }
                )
            }

        case .setStartAndGoalResponse(.success):
            return .none

        case let .setStartAndGoalResponse(.failure(error)):
            state.alert = .init(
                title: .init("Error"),
                message: .init(error.localizedDescription)
            )
            return .none
        }
    }
}
