import SwiftUI

@available(iOS 27.1, *)
struct OverlayLabView: View {
    enum Mode: String, CaseIterable, Identifiable {
        case overlay = "Overlay"
        case horizontal = "Overlay · horizontal"
        case vertical = "Overlay · vertical"

        var id: Self { self }

        var style: OverlayArrangementViewStyle {
            switch self {
            case .overlay: .overlay
            case .horizontal: .overlay.axes(.horizontal)
            case .vertical: .overlay.axes(.vertical)
            }
        }

        var readout: String {
            switch self {
            case .overlay: "overlay"
            case .horizontal: "overlay.horizontal"
            case .vertical: "overlay.vertical"
            }
        }
    }

    enum Edge: String, CaseIterable, Identifiable {
        case none = "None"
        case bottom = "Bottom"
        case leading = "Leading"
        case trailing = "Trailing"

        var id: Self { self }
    }

    @State private var mode: Mode = .overlay
    @State private var edge: Edge = .none

    var body: some View {
        ArrangementView {
            primary
        } secondary: {
            SkyLabBlock()
        }
        .arrangementViewStyle(mode.style)
        .labFoldReadout()
        .overlay(alignment: .bottom) {
            Text("mode: \(mode.readout) · edge: \(edge.rawValue.lowercased())")
                .font(.caption.monospaced())
                .foregroundStyle(.white)
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(.black.opacity(0.75), in: .capsule)
                .padding(.bottom, 8)
                .allowsHitTesting(false)
        }
        .navigationTitle("B: Overlay")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItemGroup(placement: .topBarTrailing) {
                Menu("Mode") {
                    Picker("Mode", selection: $mode) {
                        ForEach(Mode.allCases) { Text($0.rawValue).tag($0) }
                    }
                }
                Menu("Edge") {
                    Picker("Edge", selection: $edge) {
                        ForEach(Edge.allCases) { Text($0.rawValue).tag($0) }
                    }
                }
            }
        }
    }

    @ViewBuilder
    private var primary: some View {
        switch edge {
        case .none:
            ConditionsLabCard()
        case .bottom:
            ConditionsLabCard().overlayArrangementEdge(VerticalEdge.bottom)
        case .leading:
            ConditionsLabCard().overlayArrangementEdge(HorizontalEdge.leading)
        case .trailing:
            ConditionsLabCard().overlayArrangementEdge(HorizontalEdge.trailing)
        }
    }
}

@available(iOS 27.1, *)
struct ConditionsLabCard: View {
    @Environment(\.overlayArrangementZIndex) private var zIndex
    @State private var size: CGSize = .zero
    @State private var foldIsActive = false

    private let hours = ["Now", "5P", "6P", "7P", "8P", "9P", "10P", "11P", "12A", "1A", "2A", "3A"]

    var body: some View {
        Group {
            if isCompact {
                compact
            } else {
                expanded
            }
        }
        .foregroundStyle(.white)
        .background {
            Color.clear
                .onGeometryChange(for: Bool.self) { proxy in
                    proxy.reservedRegions(kind: .division, options: .includeInactive)
                        .first(where: { $0.isActive }) != nil
                } action: { isActive in
                    foldIsActive = isActive
                }
        }
    }

    /// zIndex wins when it reports layering; otherwise an active fold means side by side, so expand.
    private var isCompact: Bool {
        zIndex > 0 || !foldIsActive
    }

    private var compact: some View {
        VStack(spacing: 6) {
            Text("Conditions · compact").font(.headline)
            Text("68°").font(.system(size: 56, weight: .bold))
            Text("H 72° L 58°").font(.subheadline)
            readouts
        }
        .padding(20)
        .frame(maxWidth: 360)
        .background(Color.orange.opacity(0.55), in: .rect(cornerRadius: 24))
        .overlay {
            RoundedRectangle(cornerRadius: 24).strokeBorder(.white, lineWidth: 2)
        }
        .onGeometryChange(for: CGSize.self) { $0.size } action: { size = $0 }
        .padding(20)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
    }

    private var expanded: some View {
        ZStack {
            Color.orange.opacity(0.55)
            Rectangle().strokeBorder(.white, lineWidth: 2)
            VStack(spacing: 8) {
                Text("Conditions · expanded").font(.headline)
                Text("68°").font(.system(size: 72, weight: .bold))
                Text("H 72° L 58°").font(.subheadline)
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 6) {
                        ForEach(hours, id: \.self) { hour in
                            Text(hour)
                                .font(.caption.bold())
                                .padding(.horizontal, 8)
                                .padding(.vertical, 6)
                                .background(.white.opacity(0.25), in: .rect(cornerRadius: 8))
                        }
                    }
                    .padding(.horizontal, 16)
                }
                .fixedSize(horizontal: false, vertical: true)
                readouts
            }
        }
        .onGeometryChange(for: CGSize.self) { $0.size } action: { size = $0 }
    }

    private var readouts: some View {
        VStack(spacing: 2) {
            Text("overlay zIndex: \(zIndex)")
            Text("branch: \(isCompact ? "compact" : "expanded")")
            Text("branch from: \(zIndex > 0 ? "zIndex" : "fold")")
            Text("\(Int(size.width)) × \(Int(size.height)) pt")
        }
        .font(.caption.monospaced())
    }
}

/// Like LabBlock, but also prints the overlay z-index it sees.
@available(iOS 27.1, *)
struct SkyLabBlock: View {
    @Environment(\.overlayArrangementZIndex) private var zIndex
    @State private var size: CGSize = .zero

    var body: some View {
        ZStack {
            Color.indigo.opacity(0.85)
            VStack(spacing: 6) {
                Text("Sky").font(.title.bold())
                Text("\(Int(size.width)) × \(Int(size.height)) pt")
                    .font(.caption.monospaced())
                Text("overlay zIndex: \(zIndex)")
                    .font(.caption.monospaced())
            }
            .foregroundStyle(.white)
        }
        .onGeometryChange(for: CGSize.self) { $0.size } action: { size = $0 }
    }
}
