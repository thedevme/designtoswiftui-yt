import SwiftUI

@available(iOS 27.1, *)
struct SplitLabView: View {
    var body: some View {
        ArrangementView {
            LabBlock(title: "Steps", color: .teal)
        } secondary: {
            IngredientsLabBlock()
                .splitArrangementLayoutRatio(0.35)
                .layoutPriority(1)
        }
        .arrangementViewStyle(.split)
        .labFoldReadout()
        .navigationTitle("A: Split")
        .navigationBarTitleDisplayMode(.inline)
    }
}

@available(iOS 27.1, *)
struct IngredientsLabBlock: View {
    @Environment(\.splitArrangementAxis) private var axis
    @State private var size: CGSize = .zero

    var body: some View {
        let layout: AnyLayout = usesVerticalList
            ? AnyLayout(VStackLayout(spacing: 4))
            : AnyLayout(HStackLayout(spacing: 4))
        ZStack {
            Color.orange.opacity(0.85)
            VStack(spacing: 8) {
                Text("Ingredients").font(.title.bold())
                VStack(spacing: 2) {
                    Text("split axis: \(axisLabel)")
                    Text("\(Int(size.width)) × \(Int(size.height)) pt")
                    Text("layout from: \(axis == nil ? "size" : "axis")")
                }
                .font(.caption.monospaced())
                layout {
                    ForEach(["Flour", "Eggs", "Milk"], id: \.self) { item in
                        Text(item)
                            .font(.caption.bold())
                            .padding(6)
                            .background(.white.opacity(0.25), in: .rect(cornerRadius: 6))
                    }
                }
            }
            .foregroundStyle(.white)
        }
        .onGeometryChange(for: CGSize.self) { $0.size } action: { size = $0 }
    }

    /// A horizontal split stacks the list vertically. With no axis, fall back to the block's own shape.
    private var usesVerticalList: Bool {
        switch axis {
        case .horizontal: true
        case .vertical: false
        case nil: size.height > size.width
        }
    }

    private var axisLabel: String {
        switch axis {
        case .horizontal: "horizontal"
        case .vertical: "vertical"
        case nil: "nil"
        }
    }
}
