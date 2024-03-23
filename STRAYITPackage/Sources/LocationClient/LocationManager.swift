import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()

    private var coordinateChangeHandler: (CLLocationCoordinate2D) -> Void = { _ in }
    var coordinate: AsyncStream<CLLocationCoordinate2D> {
        AsyncStream { continuation in
            coordinateChangeHandler = { continuation.yield($0) }
        }
    }

    private var degreesChangeHandler: (CLLocationDirection) -> Void = { _ in }
    var degrees: AsyncStream<CLLocationDirection> {
        AsyncStream { continuation in
            degreesChangeHandler = { continuation.yield($0) }
        }
    }

    override init() {
        super.init()
        locationManager.delegate = self
        if let coordinate = getCoordinate() {
            coordinateChangeHandler(coordinate)
        }
        if let degrees = getDegrees() {
            degreesChangeHandler(degrees)
        }
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 1
        locationManager.activityType = .fitness
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let coordinate = locations.first?.coordinate {
            coordinateChangeHandler(coordinate)
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateHeading heading: CLHeading) {
        let degrees = heading.magneticHeading
        degreesChangeHandler(degrees)
    }

    func requestWhenInUseAuthorization() -> Bool {
        locationManager.requestWhenInUseAuthorization()
        return isValidAuthoriztionStatus
    }

    var isValidAuthoriztionStatus: Bool {
        locationManager.authorizationStatus == .authorizedWhenInUse
        || locationManager.authorizationStatus == .authorizedAlways
    }

    func getCoordinate() -> CLLocationCoordinate2D? {
        locationManager.location?.coordinate
    }

    func getDegrees() -> CLLocationDirection? {
        locationManager.heading?.magneticHeading
    }

    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
        locationManager.startUpdatingHeading()
    }

    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
        locationManager.stopUpdatingHeading()
    }

    func enableBackgroundLocationUpdates() {
        locationManager.allowsBackgroundLocationUpdates = true
    }

    func disableBackgroundLocationUpdates() {
        locationManager.allowsBackgroundLocationUpdates = false
    }
}
