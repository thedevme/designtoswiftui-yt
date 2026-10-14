import SwiftUI

struct LabListView: View {
    var body: some View {
        NavigationStack {
            List {
                if #available(iOS 27.1, *) {
                    NavigationLink("A: Split (recipe)") { SplitLabView() }
                    NavigationLink("B: Overlay (weather)") { OverlayLabView() }
                } else {
                    Text("These tests need iOS 27.1")
                }
            }
            .navigationTitle("ArrangementLab")
        }
    }
}
