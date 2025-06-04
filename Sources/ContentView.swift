import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            TractorInfoView()
                .tabItem { Label("Tractor Info", systemImage: "table") }
            CalibrationView()
                .tabItem { Label("Calibration", systemImage: "list.bullet.rectangle") }
            RecommendationView()
                .tabItem { Label("Recommendation", systemImage: "checklist") }
        }
        .applyAppTheme()
    }
}
