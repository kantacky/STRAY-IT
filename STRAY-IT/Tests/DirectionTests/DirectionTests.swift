import _MapKit_SwiftUI
import ComposableArchitecture
import CoreLocation
import Models
import XCTest

@testable import Direction

public final class DirectionTests: XCTestCase {
    @MainActor
    func testChangeCoordinate() async {
        // Given
        let start = CLLocationCoordinate2D(latitude: 35.681042, longitude: 139.767214)
        let goal = CLLocationCoordinate2D(latitude: 35.683588, longitude: 139.750323)
        let point = CLLocationCoordinate2D(latitude: 35.681464, longitude: 139.765726)
        let direction = CLLocationDirection(72)

        let store: TestStoreOf<Direction> = TestStore(initialState: Direction.State(
            start: start,
            goal: goal
        )) { Direction() }

        // When
        await store.send(.onChangeCoordinate(point)) {
            $0.coordinate = point
        }

        // Then
        await store.receive(\.calculate) {
            $0.distanceToGoal = point.distance(from: goal)
            $0.directionToGoal = point.directionDelta(from: goal, heading: 0)
        }

        // When
        await store.send(.onChangeDegrees(direction)) {
            $0.degrees = direction
        }

        // Then
        await store.receive(\.calculate) {
            $0.distanceToGoal = point.distance(from: goal)
            $0.directionToGoal = point.directionDelta(from: goal, heading: direction)
        }
    }
}
