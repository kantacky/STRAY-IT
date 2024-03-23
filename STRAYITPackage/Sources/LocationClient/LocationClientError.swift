import Foundation

public enum LocationClientError: LocalizedError {
    case getCoordinateError
    case getDegreesError
    case requestWhenInUseAuthorizationError

    public var errorDescription: String? {
        switch self {
        case .getCoordinateError:
            return "Failed to get coordinate"

        case .getDegreesError:
            return "Failed to get degrees"

        case .requestWhenInUseAuthorizationError:
            return "Failed to request when in use authorization"
        }
    }
}
