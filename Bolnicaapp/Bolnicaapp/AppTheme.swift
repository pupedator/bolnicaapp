import SwiftUI

// MARK: - Colors

extension Color {
    static let appBlue      = Color(red: 41/255,  green: 98/255,  blue: 255/255)
    static let appBlueDark  = Color(red: 21/255,  green: 101/255, blue: 192/255)
    static let cardBackground    = Color(.secondarySystemGroupedBackground)
    static let sectionBackground = Color(.systemGroupedBackground)
    static let badgeBackground   = Color(.tertiarySystemFill)
}

// MARK: - Fade-in ViewModifier

struct FadeInModifier: ViewModifier {
    let delay: Double
    let offsetY: Double
    @State private var visible = false

    func body(content: Content) -> some View {
        content
            .opacity(visible ? 1 : 0)
            .offset(y: visible ? 0 : offsetY)
            .animation(.spring(response: 0.5, dampingFraction: 0.8).delay(delay), value: visible)
            .onAppear { visible = true }
    }
}

extension View {
    func fadeIn(delay: Double = 0, y: Double = 12) -> some View {
        modifier(FadeInModifier(delay: delay, offsetY: y))
    }
}
