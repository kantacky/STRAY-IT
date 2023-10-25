import Assets
import SwiftUI

struct SliderIndicator: View {
    @Binding private var page: Int

    init(page: Binding<Int>) {
        self._page = page
    }

    var body: some View {
        HStack {
            ForEach(0...2, id: \.self) { index in
                VStack {
                    if index == page {
                        Image(systemName: "circle.fill")
                    } else {
                        Image(systemName: "circle")
                    }
                }
                .padding()
                .font(.caption)
                .foregroundStyle(ColorAssets.accent)
            }
        }
        .padding()
    }
}

#if DEBUG
#Preview {
    SliderIndicator(page: .constant(0))
}
#endif
