import SwiftUI

public struct DebugUtilsView: View {
    @Environment(\.dismiss) private var dismiss

    public init() {}

    public var body: some View {
        NavigationStack {
            List {}
                .navigationTitle("Debug Utils")
                .toolbar {
#if os(iOS)
                    ToolbarItem(
                        placement: .navigationBarTrailing
                    ) {
                        Button("Close", action: dismiss.callAsFunction)
                    }
#elseif os(watchOS)
#endif
                }
        }
    }
}

#Preview {
    DebugUtilsView()
}
