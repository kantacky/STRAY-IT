import ComposableArchitecture
import CoreLocation
import Search
@testable import STRAYIT
import XCTest

@MainActor
public final class STRAYITTests: XCTestCase {
    deinit {}

    public func testOnSearchButtonTapped() async {
        let store: TestStore = .init(
            initialState: STRAYIT.CoreReducer.State(
                search: SearchReducer.State(
                    goal: CLLocationCoordinate2DMake(143, 46)
                )
            ),
            reducer: STRAYIT.CoreReducer()
        )

        await store.send(.onSearchButtonTapped) {
            $0.search.goal = nil
        }
    }
}
