import Assets
import ComposableArchitecture
import Models
import SwiftUI

struct LandmarksView: View {
    private let landmarks: [Landmark]

    init(landmarks: [Landmark]) {
        self.landmarks = landmarks
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ImageAssets.circle
                    .resizable()
                    .scaledToFit()
                    .frame(width: geometry.size.width * 0.8, height: geometry.size.width * 0.8)
                    .position(x: geometry.size.width / 2, y: geometry.size.height / 2)

                ForEach(self.landmarks) { item in
                    item.category.image
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                        .position(
                            x: geometry.size.width / 2 + LocationLogic.getPosition(geometry.size.width * 0.8 / 2.0, item.direction).0,
                            y: geometry.size.height / 2 + LocationLogic.getPosition(geometry.size.width * 0.8 / 2.0, item.direction).1
                        )
                }
            }
        }
    }
}

#if DEBUG
#Preview {
    LandmarksView(landmarks: [])
}
#endif
