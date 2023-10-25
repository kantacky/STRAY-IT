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
}
