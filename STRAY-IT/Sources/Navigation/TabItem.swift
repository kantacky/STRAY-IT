import Assets
import SwiftUI

public enum TabItem: Identifiable, CaseIterable {
    case direction
//    case adventure
    case cheating

    public var tabButtonIconFilledSymbol: Image {
        switch self {
        case .direction:
            return SymbolAssets.starFill

//        case .adventure:
//            return SymbolAssets.telescopeFill

        case .cheating:
            return SymbolAssets.satelliteFill
        }
    }

    public var tabButtonIconSymbol: Image {
        switch self {
        case .direction:
            return SymbolAssets.star

//        case .adventure:
//            return SymbolAssets.telescope

        case .cheating:
            return SymbolAssets.satellite
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
