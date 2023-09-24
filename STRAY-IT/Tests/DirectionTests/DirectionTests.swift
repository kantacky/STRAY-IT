import _MapKit_SwiftUI
import ComposableArchitecture
import CoreLocation
import SharedModel
import XCTest

@testable import Direction

@MainActor
public final class DirectionTests: XCTestCase {
    deinit {}

    typealias Reducer = DirectionReducer

    let start: CLLocationCoordinate2D = .init(latitude: 35.681042, longitude: 139.767214)
    let goal: CLLocationCoordinate2D = .init(latitude: 35.683588, longitude: 139.750323)
    let point: CLLocationCoordinate2D = .init(latitude: 35.681464, longitude: 139.765726)
    let direction: CLLocationDirection = 72

    func testChangeCoordinate() async {
        let store: TestStoreOf<Reducer> = TestStore(
            initialState: Reducer.State(
                start: start,
                goal: goal
            ),
            reducer: { Reducer() }
        )

        await store.send(.onChangeCoordinate(point)) {
            $0.coordinate = self.point
        }

        await store.receive(.calculate) {
            $0.distanceToGoal = LocationLogic.getDistance(
                originLC: self.point,
                targetLC: self.goal
            )
            $0.directionToGoal = LocationLogic.getDirectionDelta(
                self.point,
                self.goal,
                heading: 0
            )
        }

        await store.send(.onChangeDegrees(direction)) {
            $0.degrees = self.direction
        }

        await store.receive(.calculate) {
            $0.distanceToGoal = LocationLogic.getDistance(
                originLC: self.point,
                targetLC: self.goal
            )
            $0.directionToGoal = LocationLogic.getDirectionDelta(
                self.point,
                self.goal,
                heading: self.direction
            )
        }
    }
}
