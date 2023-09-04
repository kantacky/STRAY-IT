import CoreLocation

public class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    let locationManager: CLLocationManager
//    @Published public private (set) var coordinate: CLLocationCoordinate2D?
//    @Published public private (set) var degrees: CLLocationDirection?

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
        self.locationManager.allowsBackgroundLocationUpdates = true
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
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

    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let coordinate = locations.first?.coordinate {
            self.coordinateChangeHandler?(coordinate)
        }
    }

    public func locationManager(_ manager: CLLocationManager, didUpdateHeading: CLHeading) {
        let degrees = didUpdateHeading.trueHeading
        self.degreesChangeHandler?(degrees)
    }

    public func startUpdatingLocation() {
        self.locationManager.startUpdatingLocation()
    }

    public func stopUpdatingLocation() {
        self.locationManager.stopUpdatingLocation()
    }
}
