import Resource
import SwiftUI

public struct SliderIndicator: View {
    @State private var page: Int

    public init(page: Int) {
        self._page = .init(initialValue: page)
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
                .foregroundColor(Asset.Colors.accent.swiftUIColor)
            }
        }
        .padding()
    }
}

public struct SwiftUIView_Previews: PreviewProvider {
    public static var previews: some View {
        SliderIndicator(page: 0)
    }
}
