import _MapKit_SwiftUI
import ComposableArchitecture
import CoreLocation
import Models
import XCTest

@testable import Adventure

@MainActor
public final class AdventureTests: XCTestCase {
    deinit {}

    typealias Reducer = AdventureReducer

    let start: CLLocationCoordinate2D = .init(latitude: 35.681042, longitude: 139.767214)
    let goal: CLLocationCoordinate2D = .init(latitude: 35.683588, longitude: 139.750323)
    let point: CLLocationCoordinate2D = .init(latitude: 35.681464, longitude: 139.765726)

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

        await store.receive(.appendPoint(point)) {
            $0.points = [
                self.start,
                self.point
            ]
            $0.position = MapCameraPosition.region(LocationLogic.getRegion(coordinates: [
                self.start,
                self.goal,
                self.point
            ]))
        }
    }
}
