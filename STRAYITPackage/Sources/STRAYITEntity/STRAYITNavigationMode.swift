import STRAYITResource
import SwiftUI

public enum STRAYITNavigationMode: Identifiable, CaseIterable {
    case direction
    case cheating

    public var tabButtonIconFilledSymbol: Image {
        switch self {
        case .direction:
            return Image.starFill

        case .cheating:
            return Image.satelliteFill
        }
    }

    public var tabButtonIconSymbol: Image {
        switch self {
        case .direction:
            return Image.star

        case .cheating:
            return Image.satellite
        }
    }

    public var title: String {
        switch self {
        case .direction:
            return "Direction"

        case .cheating:
            return "Cheating"
        }
    }

    public var id: Self { self }
}
