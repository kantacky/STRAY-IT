import CoreLocation

extension CLLocationCoordinate2D: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }

    public init(from decoder: Decoder) throws {
        var container: UnkeyedDecodingContainer = try decoder.unkeyedContainer()
        let latitude: CLLocationDegrees = try container.decode(CLLocationDegrees.self)
        let longitude: CLLocationDegrees = try container.decode(CLLocationDegrees.self)
        self.init(latitude: latitude, longitude: longitude)
    }

    public func distance(from coordinate: Self) -> CLLocationDistance {
        let selfLocation = CLLocation(latitude: self.latitude, longitude: self.longitude)
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)

        return selfLocation.distance(from: location)
    }

    public func directionDelta(from coordinate: CLLocationCoordinate2D, heading: Double) -> Double {
        let direction: Double

        let originalLatitude = CGFloat.radian(from: self.latitude)
        let originalLongitude = CGFloat.radian(from: self.longitude)
        let targetLatitude = CGFloat.radian(from: coordinate.latitude)
        let targetLongitude = CGFloat.radian(from: coordinate.longitude)

        let longitudeDelta = targetLongitude - originalLongitude
        let positionY = sin(longitudeDelta)
        let positionX = cos(originalLatitude) * tan(targetLatitude) - sin(originalLatitude) * cos(longitudeDelta)
        let pValue = atan2(positionY, positionX) * 180 / CGFloat.pi

        if pValue < 0 {
            direction = 360 + atan2(positionY, positionX) * 180 / CGFloat.pi
        } else {
            direction = atan2(positionY, positionX) * 180 / CGFloat.pi
        }

        return direction - heading
    }
}
