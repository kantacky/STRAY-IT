import MapKit

public struct Landmark: Equatable {
    public var id: UUID
    public var coordinate: CLLocationCoordinate2D
    public var category: MKPointOfInterestCategory

    public init(coordinate: CLLocationCoordinate2D, category: MKPointOfInterestCategory, id: UUID = .init()) {
        self.id = id
        self.coordinate = coordinate
        self.category = category
    }

    public init(latitude: CLLocationDegrees, longitude: CLLocationDegrees, category: MKPointOfInterestCategory, id: UUID = .init()) {
        self.id = id
        self.coordinate = CLLocationCoordinate2DMake(latitude, longitude)
        self.category = category
    }
}
