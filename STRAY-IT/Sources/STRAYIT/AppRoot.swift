import ComposableArchitecture
import Core
import DebugUtils
import Foundation
import SwiftUI

public struct AppRoot: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    private let store: StoreOf<Core> = Store(initialState: Core.State()) { Core() }
#if DEBUG
    @State private var isDebugUtilsPresented = false
#endif

    public init() {}

    public var body: some Scene {
        WindowGroup {
            CoreView(store: store)
#if DEBUG
                .fullScreenCover(isPresented: $isDebugUtilsPresented) {
                    DebugUtilsView()
                }
                .onReceive(NotificationCenter.default.publisher(for: .deviceDidShakeNotification)) { _ in
                    isDebugUtilsPresented.toggle()
                }
#endif
        }
    }
}

#if DEBUG
extension NSNotification.Name {
    static let deviceDidShakeNotification = NSNotification.Name("DeviceDidShakeNotification")
}

extension UIWindow {
    open override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        super.motionEnded(motion, with: event)
        NotificationCenter.default.post(name: .deviceDidShakeNotification, object: event)
    }
}
#endif
