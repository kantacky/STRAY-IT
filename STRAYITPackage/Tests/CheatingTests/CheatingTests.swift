import ComposableArchitecture
import CoreLocation
import STRAYITEntity
import _MapKit_SwiftUI
import XCTest

@testable import Cheating

public final class CheatingTests: XCTestCase {
    @MainActor
    func testChangeCoordinate() async {
        // Given
        let start = CLLocationCoordinate2D(latitude: 35.681042, longitude: 139.767214)
        let goal = CLLocationCoordinate2D(latitude: 35.683588, longitude: 139.750323)
        let point = CLLocationCoordinate2D(latitude: 35.681464, longitude: 139.765726)

        let store: TestStoreOf<Cheating> = TestStore(initialState: Cheating.State(
            start: start,
            goal: goal
        )) { Cheating() }

        // When
        await store.send(.onChangeCoordinate(point)) {
            $0.coordinate = point
        }

        // Then
        await store.receive(\.appendPoint) {
            $0.points = [start, point]
            $0.position = MapCameraPosition.region(.getRegion(from: [start, goal, point]))
        }
    }
}
