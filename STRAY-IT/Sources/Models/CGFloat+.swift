import Foundation

extension CGFloat {
    public static func radian(from deg: Self) -> CGFloat {
        CGFloat.pi / 180.0 * deg
    }

    public var radian: CGFloat {
        CGFloat.pi / 180.0 * self
    }

    public static func getCoordinate(radius: CGFloat, degrees: CGFloat) -> (CGFloat, CGFloat) {
        let theta: Double = CGFloat.radian(from: degrees)
        let positionX: CGFloat = radius * cos(theta)
        let positionY: CGFloat = radius * sin(theta)

        return (positionX, positionY)
    }
}
