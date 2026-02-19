import SwiftUI

enum AppearanceMode: Int {
    case system = 0
    case light = 1
    case dark = 2

    var colorScheme: ColorScheme? {
        switch self {
        case .system: return nil
        case .light: return .light
        case .dark: return .dark
        }
    }

    var label: String {
        switch self {
        case .system: return "Sistem"
        case .light: return "Açıq"
        case .dark: return "Tünd"
        }
    }

    var icon: String {
        switch self {
        case .system: return "circle.lefthalf.filled"
        case .light: return "sun.max.fill"
        case .dark: return "moon.fill"
        }
    }
}

@Observable
class AuthManager {
    var hasSeenOnboarding: Bool {
        didSet { UserDefaults.standard.set(hasSeenOnboarding, forKey: "hasSeenOnboarding") }
    }

    var isLoggedIn: Bool {
        didSet { UserDefaults.standard.set(isLoggedIn, forKey: "isLoggedIn") }
    }

    var currentUserName: String {
        didSet { UserDefaults.standard.set(currentUserName, forKey: "userName") }
    }

    var currentUserPhone: String {
        didSet { UserDefaults.standard.set(currentUserPhone, forKey: "userPhone") }
    }

    var appearanceMode: AppearanceMode {
        didSet { UserDefaults.standard.set(appearanceMode.rawValue, forKey: "appearanceMode") }
    }

    var registeredClinicName: String {
        didSet { UserDefaults.standard.set(registeredClinicName, forKey: "registeredClinicName") }
    }

    init() {
        self.hasSeenOnboarding = UserDefaults.standard.bool(forKey: "hasSeenOnboarding")
        self.isLoggedIn = UserDefaults.standard.bool(forKey: "isLoggedIn")
        self.currentUserName = UserDefaults.standard.string(forKey: "userName") ?? ""
        self.currentUserPhone = UserDefaults.standard.string(forKey: "userPhone") ?? ""
        self.appearanceMode = AppearanceMode(rawValue: UserDefaults.standard.integer(forKey: "appearanceMode")) ?? .system
        self.registeredClinicName = UserDefaults.standard.string(forKey: "registeredClinicName") ?? ""
    }

    func login(phone: String, password: String) -> Bool {
        guard !phone.isEmpty, !password.isEmpty else { return false }
        currentUserPhone = phone
        isLoggedIn = true
        return true
    }

    func register(name: String, phone: String, password: String) -> Bool {
        guard !name.isEmpty, !phone.isEmpty, password.count >= 6 else { return false }
        currentUserName = name
        currentUserPhone = phone
        isLoggedIn = true
        return true
    }

    func logout() {
        isLoggedIn = false
        currentUserName = ""
        currentUserPhone = ""
    }

    func resetOnboarding() {
        hasSeenOnboarding = false
        logout()
    }
}
