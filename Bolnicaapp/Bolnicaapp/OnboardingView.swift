import SwiftUI

struct OnboardingPage: Identifiable {
    let id = UUID()
    let title: String
    let icon: String          // SF Symbol — replace with Image asset name when 3D images are ready
    let iconColor: Color
}

private let onboardingPages: [OnboardingPage] = [
    .init(
        title: "Choose the private healthcare facility that you will visit with a referral",
        icon: "building.2.fill",
        iconColor: Color(red: 0.16, green: 0.38, blue: 1.0)
    ),
    .init(
        title: "Take an online appointment at the healthcare facility",
        icon: "calendar.badge.clock",
        iconColor: Color(red: 0.16, green: 0.38, blue: 1.0)
    ),
    .init(
        title: "Get your lab test results online",
        icon: "testtube.2",
        iconColor: Color(red: 0.16, green: 0.38, blue: 1.0)
    ),
]

struct OnboardingView: View {
    @Environment(AuthManager.self) private var auth
    @State private var currentPage = 0
    @State private var appeared = false
    @State private var timer: Timer?
    @State private var dragOffset: CGFloat = 0

    var body: some View {
        VStack(spacing: 0) {

                // MARK: Progress bars
                HStack(spacing: 5) {
                    ForEach(0..<onboardingPages.count, id: \.self) { index in
                        Capsule()
                            .fill(index <= currentPage ? Color.appBlue : Color(.systemGray5))
                            .frame(height: 3)
                            .animation(.easeInOut(duration: 0.3), value: currentPage)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 10)
                .padding(.bottom, 2)

                // MARK: Page content
                ZStack {
                    ForEach(Array(onboardingPages.enumerated()), id: \.element.id) { index, page in
                        if index == currentPage {
                            OnboardingPageView(page: page)
                                .transition(.asymmetric(
                                    insertion: .opacity.combined(with: .offset(x: 40)),
                                    removal:   .opacity.combined(with: .offset(x: -40))
                                ))
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .contentShape(Rectangle())
                .gesture(
                    DragGesture()
                        .onChanged { v in dragOffset = v.translation.width }
                        .onEnded { v in
                            if v.translation.width < -40 {
                                advancePage(forward: true)
                            } else if v.translation.width > 40 {
                                advancePage(forward: false)
                            }
                            dragOffset = 0
                            resetTimer()
                        }
                )
                .onTapGesture {
                    advancePage(forward: true)
                    resetTimer()
                }
                .animation(.easeInOut(duration: 0.35), value: currentPage)

                // MARK: Bottom area
                VStack(spacing: 14) {
                    // Terms
                    Text("By clicking the \"Digital Login\" button, you agree to the ")
                        .foregroundColor(Color(.secondaryLabel))
                    + Text("terms of use and privacy policy")
                        .foregroundColor(Color(.secondaryLabel))
                        .underline()
                    + Text(".")
                        .foregroundColor(Color(.secondaryLabel))
                }
                .font(.caption)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
                .padding(.bottom, 8)
                .opacity(appeared ? 1 : 0)
                .offset(y: appeared ? 0 : 20)
                .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.25), value: appeared)

                // Digital login button
                Button(action: {
                    timer?.invalidate()
                    withAnimation(.smooth(duration: 0.5)) {
                        auth.isLoggedIn = true
                    }
                }) {
                    HStack(spacing: 10) {
                        Text("digital login")
                            .font(.system(size: 20, weight: .semibold))
                        Text("•")
                            .font(.system(size: 24, weight: .bold))
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 20)
                    .background(Color.appBlue)
                    .cornerRadius(18)
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 32)
                .opacity(appeared ? 1 : 0)
                .offset(y: appeared ? 0 : 20)
                .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.3), value: appeared)
            }
            .background(Color(.systemBackground))
            .onAppear {
                withAnimation { appeared = true }
                startTimer()
            }
            .onDisappear {
                timer?.invalidate()
            }
    }

    private func advancePage(forward: Bool) {
        withAnimation(.easeInOut(duration: 0.35)) {
            if forward {
                currentPage = (currentPage + 1) % onboardingPages.count
            } else {
                currentPage = (currentPage - 1 + onboardingPages.count) % onboardingPages.count
            }
        }
    }

    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { _ in
            advancePage(forward: true)
        }
    }

    private func resetTimer() {
        timer?.invalidate()
        startTimer()
    }
}

// MARK: - Page View

struct OnboardingPageView: View {
    let page: OnboardingPage

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {

            // Welcome row
            HStack(spacing: 6) {
                Image(systemName: "e.circle.fill")
                    .font(.subheadline)
                    .foregroundColor(.appBlue)
                Text("Welcome to e-Tabib")
                    .font(.subheadline)
                    .foregroundColor(Color(.secondaryLabel))
            }
            .padding(.horizontal, 20)
            .padding(.top, 18)

            // Large title
            Text(page.title)
                .font(.system(size: 34, weight: .bold))
                .foregroundColor(Color(.label))
                .padding(.horizontal, 20)
                .padding(.top, 10)

            // Illustration — fills remaining space
            // TODO: Replace Image(systemName:) with Image("your_asset_name") when 3D images are ready
            ZStack {
                RadialGradient(
                    colors: [page.iconColor.opacity(0.06), Color.clear],
                    center: .center,
                    startRadius: 60,
                    endRadius: 260
                )

                Image(systemName: page.icon)
                    .font(.system(size: 180, weight: .thin))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [page.iconColor.opacity(0.85), page.iconColor.opacity(0.45)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

#Preview {
    OnboardingView()
        .environment(AuthManager())
}
