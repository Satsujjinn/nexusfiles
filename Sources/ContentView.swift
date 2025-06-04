import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            TractorInfoView()
                .tabItem { Label("Trekkerinligting", systemImage: "table") }
            CalibrationView()
                .tabItem { Label("Kalibrasie", systemImage: "list.bullet.rectangle") }
            RecommendationView()
                .tabItem { Label("Aanbeveling", systemImage: "checklist") }
        }
    }
}
