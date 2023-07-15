import Resource
import SwiftUI

public struct TutorialPage2: View {
    @AppStorage("hasShownTutorial")
    private var hasShownTutorial: Bool = .init(false)

    public var body: some View {
        VStack {
            Button(action: { hasShownTutorial = true }, label: {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .padding(.trailing, 8.0)
                    Text("GO STRAY-IT!!")
                }
                .padding()
                .padding(.horizontal, 16.0)
                .font(.system(.title, design: .monospaced, weight: .bold))
                .foregroundColor(Asset.Colors.background.swiftUIColor)
            })
            .background(Asset.Colors.accent.swiftUIColor)
            .cornerRadius(64.0)
        }
    }
}

#Preview {
    TutorialPage2()
}
