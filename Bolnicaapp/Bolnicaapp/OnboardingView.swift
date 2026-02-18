import SwiftUI
import Combine

struct OnboardingPage: Identifiable {
    let id = UUID()
    let title: String
    let icon: String
    let iconColor: Color
    let secondaryIcon: String?
}

private let onboardingPages: [OnboardingPage] = [
    .init(
        title: "Tibb müəssisəsinə\nonlayn növbə alın",
        icon: "calendar.badge.clock",
        iconColor: .appBlue,
        secondaryIcon: "stethoscope.circle.fill"
    ),
    .init(
        title: "Laboratoriya\nnəticələrinizi onlayn\nalın",
        icon: "testtube.2",
        iconColor: Color(red: 0.2, green: 0.5, blue: 0.9),
        secondaryIcon: "doc.text.magnifyingglass"
    ),
    .init(
        title: "Göndərişlə ziyarət\nedəcəyiniz tibb\nmüəssisəsini seçin",
        icon: "building.2.fill",
        iconColor: .appBlue,
        secondaryIcon: "cross.circle.fill"
    ),
]

struct OnboardingView: View {
    @Environment(AuthManager.self) private var auth
    @State private var currentPage = 0
    @State private var appeared = false
    @State private var timer: Timer?

    var body: some View {
        VStack(spacing: 0) {
            // Progress bars
            HStack(spacing: 6) {
                ForEach(0..<onboardingPages.count, id: \.self) { index in
                    Capsule()
                        .fill(index <= currentPage ? Color.appBlue : Color(.tertiarySystemFill))
                        .frame(height: 4)
                }
            }
            .padding(.horizontal)
            .padding(.top, 8)
            .animation(.easeInOut(duration: 0.3), value: currentPage)

            // Page content — crossfade instead of TabView for smooth looping
            ZStack {
                ForEach(Array(onboardingPages.enumerated()), id: \.element.id) { index, page in
                    if index == currentPage {
                        OnboardingPageView(page: page)
                            .transition(.asymmetric(
                                insertion: .opacity.combined(with: .offset(x: 40)),
                                removal: .opacity.combined(with: .offset(x: -40))
                            ))
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .contentShape(Rectangle())
            .onTapGesture {
                advancePage()
                resetTimer()
            }
            .animation(.easeInOut(duration: 0.4), value: currentPage)

            Spacer()

            // Terms text
            VStack(spacing: 4) {
                Text("\"Digital ID\" düyməsini klikləməklə,")
                    .font(.caption)
                    .foregroundColor(Color(.secondaryLabel))
                HStack(spacing: 0) {
                    Text("istifadə şərtləri və məxfilik siyasəti")
                        .font(.caption)
                        .underline()
                        .foregroundColor(Color(.secondaryLabel))
                    Text(" ilə razılaşırsınız.")
                        .font(.caption)
                        .foregroundColor(Color(.secondaryLabel))
                }
            }
            .multilineTextAlignment(.center)
            .padding(.horizontal)
            .padding(.bottom, 12)
            .opacity(appeared ? 1 : 0)
            .animation(.easeIn.delay(0.5), value: appeared)

            // Digital login button
            Button(action: {
                timer?.invalidate()
                withAnimation(.spring(response: 0.4)) {
                    auth.hasSeenOnboarding = true
                    auth.isLoggedIn = true
                }
            }) {
                HStack(spacing: 8) {
                    Text("digital id")
                        .font(.title3)
                        .fontWeight(.bold)
                    Circle()
                        .fill(.white.opacity(0.3))
                        .frame(width: 8, height: 8)
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 18)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.appBlue)
                )
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
            .opacity(appeared ? 1 : 0)
            .offset(y: appeared ? 0 : 30)
            .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.3), value: appeared)
        }
        .background(Color(.systemBackground))
        .onAppear {
            withAnimation(.spring(response: 0.6)) {
                appeared = true
            }
            startTimer()
        }
        .onDisappear {
            timer?.invalidate()
        }
    }

    private func advancePage() {
        withAnimation(.easeInOut(duration: 0.4)) {
            currentPage = (currentPage + 1) % onboardingPages.count
        }
    }

    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { _ in
            advancePage()
        }
    }

    private func resetTimer() {
        timer?.invalidate()
        startTimer()
    }
}

struct OnboardingPageView: View {
    let page: OnboardingPage

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 6) {
                Image(systemName: "globe")
                    .font(.subheadline)
                    .foregroundColor(.appBlue)
                Text("Təbibimə xoş gəlmisiniz")
                    .font(.subheadline)
                    .foregroundColor(Color(.secondaryLabel))
            }
            .padding(.top, 20)
            .padding(.horizontal)

            Text(page.title)
                .font(.system(size: 34, weight: .bold))
                .foregroundColor(Color(.label))
                .padding(.horizontal)
                .padding(.top, 12)

            Spacer()

            ZStack {
                Circle()
                    .fill(page.iconColor.opacity(0.08))
                    .frame(width: 240, height: 240)

                Image(systemName: page.icon)
                    .font(.system(size: 100, weight: .light))
                    .foregroundStyle(page.iconColor.gradient)

                if let secondary = page.secondaryIcon {
                    Image(systemName: secondary)
                        .font(.system(size: 40))
                        .foregroundColor(page.iconColor.opacity(0.7))
                        .offset(x: 80, y: -80)
                }
            }
            .frame(maxWidth: .infinity)

            Spacer()
        }
    }
}

#Preview {
    OnboardingView()
        .environment(AuthManager())
}
