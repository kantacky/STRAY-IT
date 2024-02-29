import Resources
import SwiftUI

struct SliderIndicator: View {
    @Binding var page: Int

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
                .foregroundStyle(Color.primaryFont)
            }
        }
        .padding()
    }
}

#Preview {
    SliderIndicator(page: .constant(0))
}
