import SwiftUI

public struct Landmarks: View {
    public var body: some View {
        GeometryReader { geometry in
            ZStack {
                Image("Circle")
                    .resizable()
                    .scaledToFit()
                    .frame(width: geometry.size.width * 0.8, height: geometry.size.width * 0.8)
                    .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
//                ForEach(locationManager.localSearchManagerByLocation.landmarks) { item in
//                    if (item.getPointOfInterestCategoryImageName() != nil) {
//                        Image(item.getPointOfInterestCategoryImageName()!)
//                            .resizable()
//                            .scaledToFit()
//                            .frame(width: 50, height: 50)
//                            .position(
//                                x: geometry.size.width / 2 + Location.getPosition(geometry.size.width * 0.8 / 2, item.direction)[0],
//                                y: geometry.size.height / 2 + Location.getPosition(geometry.size.width * 0.8 / 2, item.direction)[1])
//                    }
//                }
            }
        }
    }
}

public struct Landmarks_Previews: PreviewProvider {
    public static var previews: some View {
        Landmarks()
    }
}
