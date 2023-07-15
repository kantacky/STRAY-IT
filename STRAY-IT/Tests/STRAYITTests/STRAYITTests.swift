import ComposableArchitecture
import CoreLocation
import Search
@testable import STRAYIT
import XCTest

@MainActor
public final class STRAYITTests: XCTestCase {
    deinit {}

    public func testSettingStartAndGoal() async {
        let store: TestStore = .init(
            initialState: STRAYIT.CoreReducer.State(
                coordinate: CLLocationCoordinate2DMake(137, 43),
                search: SearchReducer.State(
                    goal: CLLocationCoordinate2DMake(143, 46)
                )
            ),
            reducer: STRAYIT.CoreReducer()
        )

        await store.send(.setStartAndGoal) {
            $0.direction.goal = CLLocationCoordinate2DMake(143, 46)
        }
    }
}
