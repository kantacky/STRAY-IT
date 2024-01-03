import Resources
import SwiftUI

struct LaunchView: View {
    var body: some View {
        Image.logo
            .resizable()
            .scaledToFit()
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.background)
    }
}

#Preview {
    LaunchView()
}
