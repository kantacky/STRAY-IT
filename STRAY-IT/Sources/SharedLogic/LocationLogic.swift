import ExtendedMKModels
import MapKit

/// Shared Logic of Handling Location
public enum LocationLogic {
    /// Get Region from Coordinates
    public static func getRegion(coordinates: [CLLocationCoordinate2D]) -> MKCoordinateRegion {
        let minLatitude: Double = coordinates.sorted {
            $0.latitude < $1.latitude
        }[0].latitude
        let maxLatitude: Double = coordinates.sorted {
            $0.latitude > $1.latitude
        }[0].latitude
        let minLongitude: Double = coordinates.sorted {
            $0.longitude < $1.longitude
        }[0].longitude
        let maxLongitude: Double = coordinates.sorted {
            $0.longitude > $1.longitude
        }[0].longitude

        let latitudeDelta: Double = maxLatitude - minLatitude
        let longitudeDelta: Double = maxLongitude - minLongitude

        return MKCoordinateRegion(
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

    /// Get Distance from CLLocations
    public static func getDistance(_ origin: CLLocation, _ target: CLLocation) -> Double {
        origin.distance(from: target)
    }

    /// Get Distance from Coordinates
    public static func getDistance(originLC: CLLocationCoordinate2D, targetLC: CLLocationCoordinate2D) -> Double {
        let origin: CLLocation = .init(latitude: originLC.latitude, longitude: originLC.longitude)
        let target: CLLocation = .init(latitude: targetLC.latitude, longitude: targetLC.longitude)
        return getDistance(origin, target)
    }

    /// Get DirectionDelta from Coordinates and Heading
    public static func getDirectionDelta(_ origin: CLLocationCoordinate2D, _ target: CLLocationCoordinate2D, heading: Double) -> Double {
        var direction: CGFloat

        let originalLatitude: Double = getRadian(origin.latitude)
        let originalLongitude: Double = getRadian(origin.longitude)
        let targetLatitude: Double = getRadian(target.latitude)
        let targetLongitude: Double = getRadian(target.longitude)

        let longitudeDelta: Double = targetLongitude - originalLongitude
        // swiftlint:disable identifier_name
        let y: Double = sin(longitudeDelta)
        let x: Double = cos(originalLatitude) * tan(targetLatitude) - sin(originalLatitude) * cos(longitudeDelta)
        let p: Double = atan2(y, x) * 180 / CGFloat.pi
        // swiftlint:enable identifier_name

        if p < 0 {
            direction = 360 + atan2(y, x) * 180 / CGFloat.pi
        } else {
            direction = atan2(y, x) * 180 / CGFloat.pi
        }

        direction -= heading

        return direction
    }

    /// Get Position from r and theta
    public static func getPosition(_ radius: Double, _ degrees: Double) -> [Double] {
        let theta: Double = getRadian(degrees)
        let positionX: Double = radius * cos(theta)
        let positionY: Double = radius * sin(theta)

        return [positionX, positionY]
    }

    /// Get Radian from Angle
    public static func getRadian(_ angle: Double) -> Double { angle * CGFloat.pi / 180 }

    /// Get Bool of isSameLocation
    public static func isSameLocation(_ coordinate1: CLLocationCoordinate2D, _ coordinate2: CLLocationCoordinate2D) -> Bool {
        if coordinate1.latitude == coordinate2.longitude && coordinate1.longitude == coordinate2.latitude {
            return true
        }
        return false
    }
}
