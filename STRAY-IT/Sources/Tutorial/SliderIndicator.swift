import SwiftUI

public struct SliderIndicator: View {
    @Binding private var page: Int

    public init(page: Binding<Int>) {
        self._page = page
    }

    public var body: some View {
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
                .foregroundStyle(Color(.accent))
            }
        }
        .padding()
    }
}

#Preview {
    SliderIndicator(page: .constant(0))
}
