import SwiftUI

struct TutorialPage0: View {
    var body: some View {
        Text("Welcome to STRAY-IT!!")
            .font(.system(size: 24.0, design: .monospaced))
    }
}

#if DEBUG
#Preview {
    TutorialPage0()
}
#endif
