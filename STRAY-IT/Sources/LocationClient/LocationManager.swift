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
        self.locationManager.delegate = self
        if let coordinate = self.getCoordinate() {
            self.coordinateChangeHandler(coordinate)
        }
        if let degrees = self.getDegrees() {
            self.degreesChangeHandler(degrees)
        }
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.distanceFilter = 1
        self.locationManager.activityType = .fitness
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let coordinate = locations.first?.coordinate {
            self.coordinateChangeHandler(coordinate)
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateHeading heading: CLHeading) {
        let degrees = heading.magneticHeading
        self.degreesChangeHandler(degrees)
    }

    func requestWhenInUseAuthorization() -> Bool {
        self.locationManager.requestWhenInUseAuthorization()
        return self.isValidAuthoriztionStatus
    }

    var isValidAuthoriztionStatus: Bool {
        self.locationManager.authorizationStatus == .authorizedWhenInUse || self.locationManager.authorizationStatus == .authorizedAlways
    }

    func getCoordinate() -> CLLocationCoordinate2D? {
        self.locationManager.location?.coordinate
    }

    func getDegrees() -> CLLocationDirection? {
        self.locationManager.heading?.magneticHeading
    }

    func startUpdatingLocation() {
        self.locationManager.startUpdatingLocation()
        self.locationManager.startUpdatingHeading()
    }

    func stopUpdatingLocation() {
        self.locationManager.stopUpdatingLocation()
        self.locationManager.stopUpdatingHeading()
    }

    func enableBackgroundLocationUpdates() {
        self.locationManager.allowsBackgroundLocationUpdates = true
    }

    func disableBackgroundLocationUpdates() {
        self.locationManager.allowsBackgroundLocationUpdates = false
    }
}
