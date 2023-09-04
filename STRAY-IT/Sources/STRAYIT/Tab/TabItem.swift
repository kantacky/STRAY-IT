import Resource

public enum TabItem: String, CaseIterable {
    case direction, adventure, cheating

    public var tabButtonIconFilledSymbol: SymbolAsset {
        switch self {
        case .direction:
            return Asset.Symbols.starFill

        case .adventure:
            return Asset.Symbols.telescopeFill

        case .cheating:
            return Asset.Symbols.satelliteFill
        }
    }

    public var tabButtonIconSymbol: SymbolAsset {
        switch self {
        case .direction:
            return Asset.Symbols.star

        case .adventure:
            return Asset.Symbols.telescope

        case .cheating:
            return Asset.Symbols.satellite
        }
    }
}
