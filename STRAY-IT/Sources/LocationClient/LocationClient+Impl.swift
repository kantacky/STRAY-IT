import Dependencies

extension LocationClient: DependencyKey {
    public static let liveValue = {
        let locationManager = LocationManager()

        return LocationClient(
            getCoordinateStream: {
                locationManager.coordinate
            },
            getDegreesStream: {
                locationManager.degrees
            },
            requestWhenInUseAuthorization: {
                if locationManager.requestWhenInUseAuthorization() {
                    return
                }
                throw LocationClientError.requestWhenInUseAuthorizationError
            },
            getCoordinate: {
                guard let coordinate = locationManager.getCoordinate() else {
                    throw LocationClientError.getCoordinateError
                }
                return coordinate
            },
            getDegrees: {
                guard let degrees = locationManager.getDegrees() else {
                    throw LocationClientError.getDegreesError
                }
                return degrees
            },
            startUpdatingLocation: {
                locationManager.startUpdatingLocation()
            },
            stopUpdatingLocation: {
                locationManager.stopUpdatingLocation()
            },
            enableBackgroundLocationUpdates: {
                locationManager.enableBackgroundLocationUpdates()
            },
            disableBackgroundLocationUpdates: {
                locationManager.disableBackgroundLocationUpdates()
            }
        )
    }()
}

extension LocationClient: TestDependencyKey {
    public static let testValue: LocationClient = unimplemented()
}
