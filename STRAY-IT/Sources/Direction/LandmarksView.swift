import ComposableArchitecture
import Resource
import SwiftUI

public struct LandmarksView: View {
    public typealias Reducer = DirectionReducer

    private let store: StoreOf<Reducer>

    public init(store: StoreOf<Reducer>) {
        self.store = store
    }

    public var body: some View {
        WithViewStore(self.store, observe: { $0 }, content: { viewStore in
            GeometryReader { geometry in
                ZStack {
                    Asset.Assets.circle.swiftUIImage
                        .resizable()
                        .scaledToFit()
                        .frame(width: geometry.size.width * 0.8, height: geometry.size.width * 0.8)
                        .position(x: geometry.size.width / 2, y: geometry.size.height / 2)

//                    ForEach(viewStore.state.landmarks) { item in
//                        if let category = item.category {
//                            category.swiftUIImage
//                                .resizable()
//                                .scaledToFit()
//                                .frame(width: 50, height: 50)
//                                .position(
//                                    x: geometry.size.width / 2 + LocationLogic.getPosition(geometry.size.width * 0.8 / 2, item.direction)[0],
//                                    y: geometry.size.height / 2 + LocationLogic.getPosition(geometry.size.width * 0.8 / 2, item.direction)[1]
//                                )
//                        }
//                    }
                }
            }
        })
    }
}

#Preview {
    LandmarksView(store: Store(
        initialState: LandmarksView.Reducer.State()
    ) {
        LandmarksView.Reducer()
    })
}
