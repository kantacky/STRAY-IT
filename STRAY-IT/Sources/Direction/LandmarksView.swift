import ComposableArchitecture
import Entity
import Resources
import SwiftUI

struct LandmarksView: View {
    private let landmarks: [Landmark]

    init(landmarks: [Landmark]) {
        self.landmarks = landmarks
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Image.circle
                    .resizable()
                    .scaledToFit()
                    .frame(
                        width: geometry.size.width * 0.8,
                        height: geometry.size.width * 0.8
                    )
                    .position(
                        x: geometry.size.width / 2,
                        y: geometry.size.height / 2
                    )

                ForEach(self.landmarks) { item in
                    item.category.image
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                        .position(
                            x: geometry.size.width / 2 + CGFloat.getCoordinate(
                                radius: geometry.size.width * 0.8 / 2.0,
                                degrees: item.direction
                            ).0,
                            y: geometry.size.height / 2 + CGFloat.getCoordinate(
                                radius: geometry.size.width * 0.8 / 2.0,
                                degrees: item.direction
                            ).1
                        )
                }
            }
        }
    }
}

#Preview {
    LandmarksView(landmarks: [])
}
