import ComposableArchitecture
import XCTest
@testable import STRAYIT

@MainActor
final class STRAYITTests: XCTestCase {
    func testOnAppear() async {
        let store: TestStore = .init(initialState: STRAYIT.AppReducer.State(), reducer: STRAYIT.AppReducer())

//        await store.send(.onAppear) {
//            $0.isLoading = false
//        }
    }
}
