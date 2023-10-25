import Navigation
import SwiftUI

struct TutorialPage2: View {
    @AppStorage("hasShownTutorial")
    private var hasShownTutorial: Bool = .init(false)

    var body: some View {
        Button(action: { hasShownTutorial = true }, label: {
            SearchButton()
        })
    }
}

#if DEBUG
#Preview {
    TutorialPage2()
}
#endif
