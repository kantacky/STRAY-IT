import MapKit

public struct Landmark: Identifiable, Equatable {
    public let id: UUID
    public let coordinate: CLLocationCoordinate2D
    public let category: MKPointOfInterestCategory
    public let direction: Double
}
