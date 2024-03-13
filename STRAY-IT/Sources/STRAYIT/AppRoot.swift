import ComposableArchitecture
import Core
import DebugUtils
import FirebaseAnalytics
import FirebaseCore
import FirebaseMessaging
import Foundation
import SwiftUI

public struct AppRoot: App {
    private let store: StoreOf<Core> = Store(initialState: Core.State()) { Core() }
#if DEBUG
    @State private var isDebugUtilsPresented = false
#endif

    public init() {
        FirebaseApp.configure(
            options: .init(
                contentsOfFile: Bundle.module.path(
                    forResource: "GoogleService-Info",
                    ofType: "plist"
                )!
            )!
        )

        Messaging.messaging().delegate = UIApplication.shared.delegate as? MessagingDelegate

        UNUserNotificationCenter.current().delegate = UIApplication.shared.delegate as? UNUserNotificationCenterDelegate

        UNUserNotificationCenter.current().requestAuthorization(
            options: [.alert, .badge, .sound]
        ) { granted, error in
            if let error {
                debugPrint(print("Error: \(error)"))
                return
            }
            debugPrint(print("Permission granted: \(granted)"))
        }

        UIApplication.shared.registerForRemoteNotifications()
    }

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
