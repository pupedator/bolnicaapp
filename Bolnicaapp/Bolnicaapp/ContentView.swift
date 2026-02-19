import SwiftUI

struct ContentView: View {
    @Environment(AuthManager.self) private var auth
    @State private var selectedTab = 0
    @State private var showSplash = true

    var body: some View {
        ZStack {
            if showSplash {
                SplashView(onFinished: { showSplash = false })
                    .transition(.opacity)
            } else {
                mainContent
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.3), value: showSplash)
        .preferredColorScheme(auth.appearanceMode.colorScheme)
    }

    @ViewBuilder
    private var mainContent: some View {
        Group {
            if !auth.hasSeenOnboarding {
                OnboardingView()
                    .transition(.opacity)
            } else if !auth.isLoggedIn {
                LoginView()
                    .transition(.opacity.combined(with: .move(edge: .trailing)))
            } else {
                TabView(selection: $selectedTab) {
                    HomeView()
                        .tabItem {
                            Image(systemName: selectedTab == 0 ? "house.fill" : "house")
                            Text("Əsas")
                        }
                        .tag(0)

                    MedicalCardView()
                        .tabItem {
                            Image(systemName: selectedTab == 1 ? "heart.fill" : "heart")
                            Text("Tibbi kart")
                        }
                        .tag(1)

                    ClinicsMapView()
                        .tabItem {
                            Image(systemName: selectedTab == 2 ? "map.fill" : "map")
                            Text("Xəritə")
                        }
                        .tag(2)

                    MoreView()
                        .tabItem {
                            Image(systemName: "ellipsis")
                            Text("Əlavə")
                        }
                        .tag(3)
                }
                .tint(.appBlue)
                .transition(.opacity.combined(with: .scale(scale: 0.95)))
            }
        }
        .animation(.smooth(duration: 0.5), value: auth.hasSeenOnboarding)
        .animation(.smooth(duration: 0.5), value: auth.isLoggedIn)
    }
}

#Preview {
    ContentView()
        .environment(AuthManager())
}
