import Foundation

public struct Alert: Identifiable, Equatable {
    public var id: UUID
    public var title: String
    public var message: String

    public init(title: String, message: String, id: UUID = .init()) {
        self.title = title
        self.message = message
        self.id = id
    }
}
