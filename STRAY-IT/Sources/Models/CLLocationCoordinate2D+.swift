import CoreLocation

extension CLLocationCoordinate2D: Equatable, Codable {
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        lhs.latitude == rhs.latitude
        && lhs.longitude == rhs.longitude
    }

    public func encode(to encoder: Encoder) throws {
        var container: UnkeyedEncodingContainer = encoder.unkeyedContainer()
        try container.encode(latitude)
        try container.encode(longitude)
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
        var direction: Double

        let originalLatitude: Double = CGFloat.radian(from: self.latitude)
        let originalLongitude: Double = CGFloat.radian(from: self.longitude)
        let targetLatitude: Double = CGFloat.radian(from: coordinate.latitude)
        let targetLongitude: Double = CGFloat.radian(from: coordinate.longitude)

        let longitudeDelta: Double = targetLongitude - originalLongitude
        let y: Double = sin(longitudeDelta)
        let x: Double = cos(originalLatitude) * tan(targetLatitude) - sin(originalLatitude) * cos(longitudeDelta)
        let p: Double = atan2(y, x) * 180 / CGFloat.pi

        if p < 0 {
            direction = 360 + atan2(y, x) * 180 / CGFloat.pi
        } else {
            direction = atan2(y, x) * 180 / CGFloat.pi
        }

        direction -= heading

        return direction
    }
}
