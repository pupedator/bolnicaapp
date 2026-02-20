import SwiftUI

@main
struct BolnicaappApp: App {
    @State private var authManager = AuthManager()
    @State private var locationManager = LocationManager()
    @State private var clinicViewModel = ClinicViewModel()

    init() {
        // Reset state for UI tests to ensure a clean, predictable environment
        if ProcessInfo.processInfo.arguments.contains("--uitesting") {
            KeychainHelper.delete(forKey: KeychainHelper.Keys.isLoggedIn)
            KeychainHelper.delete(forKey: KeychainHelper.Keys.userPhone)
            KeychainHelper.delete(forKey: KeychainHelper.Keys.userName)
            UserDefaults.standard.set(true, forKey: "hasSeenOnboarding")
            UserDefaults.standard.set(0, forKey: "loginAttemptCount")
            UserDefaults.standard.removeObject(forKey: "lockoutUntil")
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(authManager)
                .environment(locationManager)
                .environment(clinicViewModel)
        }
    }
}
