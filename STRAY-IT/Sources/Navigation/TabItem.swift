import Resources
import SwiftUI

public enum TabItem: Identifiable, CaseIterable {
    case direction
//    case adventure
    case cheating

    public var tabButtonIconFilledSymbol: Image {
        switch self {
        case .direction:
            return Image.starFill

//        case .adventure:
//            return Image.telescopeFill

        case .cheating:
            return Image.satelliteFill
        }
    }

    public var tabButtonIconSymbol: Image {
        switch self {
        case .direction:
            return Image.star

//        case .adventure:
//            return Image.telescope

        case .cheating:
            return Image.satellite
        }
    }

    public var title: String {
        switch self {
        case .direction:
            return "Direction"

//        case .adventure:
//            return "Adventure"

        case .cheating:
            return "Cheating"
        }
    }

    public var id: Self { self }
}
