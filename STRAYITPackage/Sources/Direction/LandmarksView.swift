import ComposableArchitecture
import STRAYITEntity
import STRAYITResource
import SwiftUI

struct LandmarksView: View {
    @Environment(\.colorScheme) private var colorScheme
    private let landmarks: [Landmark]

    init(landmarks: [Landmark]) {
        self.landmarks = landmarks
    }

    var body: some View {
        Circle()
            .fill(.clear)
            .stroke(Color.primaryFont, lineWidth: 2)
            .containerRelativeFrame(
                .horizontal,
                count: 5,
                span: 4,
                spacing: .zero
            )
            .opacity(0.3)
            .overlay {
                GeometryReader { geometry in
                    ForEach(landmarks) { item in
                        item.category.image
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                            .position(
                                x: geometry.size.width / 2 + CGFloat.getCoordinate(
                                    radius: geometry.size.width / 2,
                                    degrees: item.direction
                                ).0,
                                y: geometry.size.height / 2 + CGFloat.getCoordinate(
                                    radius: geometry.size.width / 2,
                                    degrees: item.direction
                                ).1
                            )
                    }
                }
            }
    }
}

#Preview {
    LandmarksView(landmarks: [
        .init(
            id: .init(),
            coordinate: .init(latitude: 35.681042, longitude: 139.767214),
            category: .cafe,
            direction: 0.0
        ),
        .init(
            id: .init(),
            coordinate: .init(latitude: 35.681042, longitude: 139.767214),
            category: .restaurant,
            direction: 90.0
        ),
        .init(
            id: .init(),
            coordinate: .init(latitude: 35.681042, longitude: 139.767214),
            category: .airport,
            direction: 180.0
        ),
        .init(
            id: .init(),
            coordinate: .init(latitude: 35.681042, longitude: 139.767214),
            category: .amusementPark,
            direction: 270.0
        )
    ])
}
