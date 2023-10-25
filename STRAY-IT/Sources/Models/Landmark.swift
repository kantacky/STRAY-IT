import MapKit

public struct Landmark: Identifiable, Equatable {
    public var id: UUID
    public var coordinate: CLLocationCoordinate2D
    public var category: MKPointOfInterestCategory
    public var direction: Double

    public init(
        id: UUID = .init(),
        coordinate: CLLocationCoordinate2D,
        category: MKPointOfInterestCategory,
        direction: Double = 0
    ) {
        self.id = id
        self.coordinate = coordinate
        self.category = category
        self.direction = direction
    }

    public init(
        id: UUID = .init(),
        latitude: CLLocationDegrees,
        longitude: CLLocationDegrees,
        category: MKPointOfInterestCategory,
        direction: Double = 0
    ) {
        self.id = id
        self.coordinate = CLLocationCoordinate2DMake(latitude, longitude)
        self.category = category
        self.direction = direction
    }
}
