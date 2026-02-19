import SwiftUI

@main
struct BolnicaappApp: App {
    @State private var authManager = AuthManager()
    @State private var locationManager = LocationManager()
    @State private var clinicViewModel = ClinicViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(authManager)
                .environment(locationManager)
                .environment(clinicViewModel)
        }
    }
}
