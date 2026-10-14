import SwiftUI

/// A labeled color block that prints its own size, so clips show what each pane got.
struct LabBlock: View {
    let title: String
    let color: Color
    @State private var size: CGSize = .zero

    var body: some View {
        ZStack {
            color.opacity(0.85)
            VStack(spacing: 6) {
                Text(title).font(.title.bold())
                Text("\(Int(size.width)) × \(Int(size.height)) pt")
                    .font(.caption.monospaced())
            }
            .foregroundStyle(.white)
        }
        .onGeometryChange(for: CGSize.self) { $0.size } action: { size = $0 }
    }
}
