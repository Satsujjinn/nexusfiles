import SwiftUI

struct AppTheme: ViewModifier {
    func body(content: Content) -> some View {
        content
            .accentColor(.green)
            .foregroundColor(.black)
            .preferredColorScheme(.light)
            .background(Color.white)
    }
}

extension View {
    func applyAppTheme() -> some View {
        modifier(AppTheme())
    }
}
