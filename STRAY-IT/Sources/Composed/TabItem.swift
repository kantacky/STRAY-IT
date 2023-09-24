import SwiftUI

public enum TabItem: String, CaseIterable {
    case direction, adventure, cheating

    public var tabButtonIconFilledSymbol: Image {
        switch self {
        case .direction:
            return Image(.starFill)

        case .adventure:
            return Image(.telescopeFill)

        case .cheating:
            return Image(.satelliteFill)
        }
    }

    public var tabButtonIconSymbol: Image {
        switch self {
        case .direction:
            return Image(.star)

        case .adventure:
            return Image(.telescope)

        case .cheating:
            return Image(.satellite)
        }
    }
}
