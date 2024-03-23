import STRAYITResource
import SwiftUI

public struct LaunchView: View {
    public init() {}

    public var body: some View {
        Image.logo
            .resizable()
            .scaledToFit()
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.primaryBackground)
    }
}

#Preview {
    LaunchView()
}
