import MapKit

extension MKCoordinateRegion {
    public static func getRegion(from coordinates: [CLLocationCoordinate2D]) -> Self {
        let minLatitude: Double = coordinates.sorted { $0.latitude < $1.latitude }[0].latitude
        let maxLatitude: Double = coordinates.sorted { $0.latitude > $1.latitude }[0].latitude
        let minLongitude: Double = coordinates.sorted { $0.longitude < $1.longitude }[0].longitude
        let maxLongitude: Double = coordinates.sorted { $0.longitude > $1.longitude }[0].longitude

        let latitudeDelta: Double = maxLatitude - minLatitude
        let longitudeDelta: Double = maxLongitude - minLongitude

        return .init(
            center: CLLocationCoordinate2D(
                latitude: latitudeDelta / 2 + minLatitude,
                longitude: longitudeDelta / 2 + minLongitude
            ),
            span: MKCoordinateSpan(
                latitudeDelta: latitudeDelta * 1.4,
                longitudeDelta: longitudeDelta * 1.4
            )
        )
    }
}
