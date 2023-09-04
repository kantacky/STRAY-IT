import CoreLocation

public struct Points: Codable {
    public var start: CLLocationCoordinate2D?
    public var goal: CLLocationCoordinate2D?

    public init(start: CLLocationCoordinate2D? = nil, goal: CLLocationCoordinate2D? = nil) {
        self.start = start
        self.goal = goal
    }
}
