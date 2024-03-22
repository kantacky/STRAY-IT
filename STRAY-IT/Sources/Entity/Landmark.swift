import MapKit

public struct Landmark: Identifiable, Equatable {
    public let id: UUID
    public let coordinate: CLLocationCoordinate2D
    public let category: MKPointOfInterestCategory
    public let direction: Double

    public init(
        id: UUID,
        coordinate: CLLocationCoordinate2D,
        category: MKPointOfInterestCategory,
        direction: Double
    ) {
        self.id = id
        self.coordinate = coordinate
        self.category = category
        self.direction = direction
    }
}
