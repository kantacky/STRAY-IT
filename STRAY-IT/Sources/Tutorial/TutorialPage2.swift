import Composed
import SwiftUI

public struct TutorialPage2: View {
    @AppStorage("hasShownTutorial")
    private var hasShownTutorial: Bool = .init(false)

    public var body: some View {
        Button(action: { hasShownTutorial = true }, label: {
            SearchButton()
        })
    }
}

#Preview {
    TutorialPage2()
}
