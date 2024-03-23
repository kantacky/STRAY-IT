import Foundation
import MapKit

public struct LocationClient {
    public var getCoordinateStream: @Sendable () -> AsyncStream<CLLocationCoordinate2D>
    public var getDegreesStream: @Sendable () -> AsyncStream<CLLocationDirection>
    public var requestWhenInUseAuthorization: @Sendable () throws -> Void
    public var getCoordinate: @Sendable () throws -> CLLocationCoordinate2D
    public var getDegrees: @Sendable () throws -> CLLocationDirection
    public var startUpdatingLocation: @Sendable () -> Void
    public var stopUpdatingLocation: @Sendable () -> Void
    public var enableBackgroundLocationUpdates: @Sendable () -> Void
    public var disableBackgroundLocationUpdates: @Sendable () -> Void

    public init(
        getCoordinateStream: @escaping @Sendable () -> AsyncStream<CLLocationCoordinate2D>,
        getDegreesStream: @escaping @Sendable () -> AsyncStream<CLLocationDirection>,
        requestWhenInUseAuthorization: @escaping @Sendable () throws -> Void,
        getCoordinate: @escaping @Sendable () throws -> CLLocationCoordinate2D,
        getDegrees: @escaping @Sendable () throws -> CLLocationDirection,
        startUpdatingLocation: @escaping @Sendable () -> Void,
        stopUpdatingLocation: @escaping @Sendable () -> Void,
        enableBackgroundLocationUpdates: @escaping @Sendable () -> Void,
        disableBackgroundLocationUpdates: @escaping @Sendable () -> Void
    ) {
        self.getCoordinateStream = getCoordinateStream
        self.getDegreesStream = getDegreesStream
        self.requestWhenInUseAuthorization = requestWhenInUseAuthorization
        self.getCoordinate = getCoordinate
        self.getDegrees = getDegrees
        self.startUpdatingLocation = startUpdatingLocation
        self.stopUpdatingLocation = stopUpdatingLocation
        self.enableBackgroundLocationUpdates = enableBackgroundLocationUpdates
        self.disableBackgroundLocationUpdates = disableBackgroundLocationUpdates
    }
}
