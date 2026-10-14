import SwiftUI

/// Shows whether the fold (the device's division region) is active, and where it sits.
@available(iOS 27.1, *)
struct LabFoldReadout: View {
    @State private var fold: CGRect?

    var body: some View {
        Text(label)
            .font(.caption.monospaced())
            .foregroundStyle(.white)
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(.black.opacity(0.75), in: .capsule)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .background {
                Color.clear
                    .onGeometryChange(for: CGRect?.self) { proxy in
                        proxy.reservedRegions(kind: .division, options: .includeInactive)
                            .first(where: { $0.isActive })?.frame
                    } action: { frame in
                        fold = frame
                    }
            }
    }

    private var label: String {
        guard let fold else { return "fold: inactive" }
        return "fold: active, x = \(Int(fold.minX))–\(Int(fold.maxX)) pt"
    }
}

@available(iOS 27.1, *)
extension View {
    /// Overlays the fold readout at the top center of this view.
    func labFoldReadout() -> some View {
        overlay {
            LabFoldReadout()
                .allowsHitTesting(false)
        }
    }
}
