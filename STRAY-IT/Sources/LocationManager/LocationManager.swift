import CoreLocation

public class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager: CLLocationManager

    private var coordinateChangeHandler: ((CLLocationCoordinate2D) -> Void)?
    public var coordinate: AsyncStream<CLLocationCoordinate2D> {
        get {
            AsyncStream { continuation in
                self.coordinateChangeHandler = { value in
                    continuation.yield(value)
                }
            }
        }
    }

    private var degreesChangeHandler: ((CLLocationDirection) -> Void)?
    public var degrees:  AsyncStream<CLLocationDirection> {
        get {
            AsyncStream { continuation in
                self.degreesChangeHandler = { value in
                    continuation.yield(value)
                }
            }
        }
    }

    public override init() {
        self.locationManager = .init()
        super.init()
        self.locationManager.delegate = self
        self.requestWhenInUseAuthorization()
        if let coordinate = self.getCoordinate() {
            self.coordinateChangeHandler?(coordinate)
        }
        if let degrees = self.getHeading() {
            self.degreesChangeHandler?(degrees)
        }
        self.locationManager.allowsBackgroundLocationUpdates = true
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.distanceFilter = 1
        self.locationManager.activityType = .fitness
    }

    private func requestWhenInUseAuthorization() {
        if self.locationManager.authorizationStatus == .notDetermined {
            self.locationManager.requestWhenInUseAuthorization()
        }
    }

    public func getCoordinate() -> CLLocationCoordinate2D? {
        self.locationManager.location?.coordinate
    }

    public func getHeading() -> CLLocationDirection? {
        self.locationManager.heading?.magneticHeading
    }

    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let coordinate = locations.first?.coordinate {
            self.coordinateChangeHandler?(coordinate)
        }
    }

    public func locationManager(_ manager: CLLocationManager, didUpdateHeading heading: CLHeading) {
        let degrees = heading.magneticHeading
        self.degreesChangeHandler?(degrees)
    }

    public func startUpdatingLocation() {
        self.locationManager.startUpdatingLocation()
        self.locationManager.startUpdatingHeading()
    }

    public func stopUpdatingLocation() {
        self.locationManager.stopUpdatingLocation()
        self.locationManager.stopUpdatingHeading()
    }
}
