import SwiftUI

// MARK: - Appearance

enum AppearanceMode: Int {
    case system = 0
    case light  = 1
    case dark   = 2

    var colorScheme: ColorScheme? {
        switch self {
        case .system: return nil
        case .light:  return .light
        case .dark:   return .dark
        }
    }

    var label: String {
        switch self {
        case .system: return "Sistem"
        case .light:  return "Açıq"
        case .dark:   return "Tünd"
        }
    }

    var icon: String {
        switch self {
        case .system: return "circle.lefthalf.filled"
        case .light:  return "sun.max.fill"
        case .dark:   return "moon.fill"
        }
    }
}

// MARK: - Login result

enum LoginResult: Equatable {
    case success
    case invalidInput
    case lockedOut(until: Date)
}

// MARK: - AuthManager

@Observable
class AuthManager {

    // Non-sensitive UI preferences — UserDefaults is fine
    var hasSeenOnboarding: Bool {
        didSet { UserDefaults.standard.set(hasSeenOnboarding, forKey: "hasSeenOnboarding") }
    }
    var appearanceMode: AppearanceMode {
        didSet { UserDefaults.standard.set(appearanceMode.rawValue, forKey: "appearanceMode") }
    }
    var registeredClinicName: String {
        didSet { UserDefaults.standard.set(registeredClinicName, forKey: "registeredClinicName") }
    }

    // Sensitive identity data — Keychain
    var isLoggedIn: Bool {
        didSet { KeychainHelper.saveBool(isLoggedIn, forKey: KeychainHelper.Keys.isLoggedIn) }
    }
    var currentUserName: String {
        didSet { KeychainHelper.save(currentUserName, forKey: KeychainHelper.Keys.userName) }
    }
    var currentUserPhone: String {
        didSet { KeychainHelper.save(currentUserPhone, forKey: KeychainHelper.Keys.userPhone) }
    }

    // Rate limiting — UserDefaults (non-sensitive, cleared on logout)
    private var loginAttemptCount: Int {
        didSet { UserDefaults.standard.set(loginAttemptCount, forKey: "loginAttemptCount") }
    }
    private var lockoutUntil: Date? {
        didSet { UserDefaults.standard.set(lockoutUntil, forKey: "lockoutUntil") }
    }

    private let maxLoginAttempts = 5
    private let lockoutDuration: TimeInterval = 5 * 60 // 5 minutes

    var isLockedOut: Bool {
        guard let until = lockoutUntil else { return false }
        return Date() < until
    }

    var lockoutRemainingSeconds: Int {
        guard let until = lockoutUntil, Date() < until else { return 0 }
        return Int(until.timeIntervalSinceNow)
    }

    // MARK: - Init

    init() {
        self.hasSeenOnboarding    = UserDefaults.standard.bool(forKey: "hasSeenOnboarding")
        self.appearanceMode       = AppearanceMode(rawValue: UserDefaults.standard.integer(forKey: "appearanceMode")) ?? .system
        self.registeredClinicName = UserDefaults.standard.string(forKey: "registeredClinicName") ?? ""

        self.isLoggedIn      = KeychainHelper.readBool(forKey: KeychainHelper.Keys.isLoggedIn) ?? false
        self.currentUserName = KeychainHelper.read(forKey: KeychainHelper.Keys.userName) ?? ""
        self.currentUserPhone = KeychainHelper.read(forKey: KeychainHelper.Keys.userPhone) ?? ""

        self.loginAttemptCount = UserDefaults.standard.integer(forKey: "loginAttemptCount")
        self.lockoutUntil      = UserDefaults.standard.object(forKey: "lockoutUntil") as? Date
    }

    // MARK: - Validation

    static func isValidAzerbaijaniPhone(_ phone: String) -> Bool {
        let normalized = phone.filter { $0.isNumber || $0 == "+" }
        let pattern = #"^(\+994\d{9}|0\d{9})$"#
        return normalized.range(of: pattern, options: .regularExpression) != nil
    }

    static func isValidPassword(_ password: String) -> Bool {
        guard password.count >= 8 else { return false }
        return password.contains(where: { $0.isNumber })
    }

    // MARK: - Login

    func login(phone: String, password: String) -> LoginResult {
        // Check lockout first
        if let until = lockoutUntil {
            if Date() < until {
                return .lockedOut(until: until)
            } else {
                // Expired — reset
                lockoutUntil = nil
                loginAttemptCount = 0
            }
        }

        guard !phone.isEmpty, !password.isEmpty,
              AuthManager.isValidAzerbaijaniPhone(phone) else {
            recordFailedAttempt()
            return .invalidInput
        }

        // Prototype: any valid phone + non-empty password succeeds.
        // Replace this block with real credential verification against a backend.
        loginAttemptCount = 0
        currentUserPhone = phone
        isLoggedIn = true
        return .success
    }

    private func recordFailedAttempt() {
        loginAttemptCount += 1
        if loginAttemptCount >= maxLoginAttempts {
            lockoutUntil = Date().addingTimeInterval(lockoutDuration)
            loginAttemptCount = 0
        }
    }

    // MARK: - Register

    func register(name: String, phone: String, password: String) -> Bool {
        guard !name.trimmingCharacters(in: .whitespaces).isEmpty,
              AuthManager.isValidAzerbaijaniPhone(phone),
              AuthManager.isValidPassword(password) else { return false }

        currentUserName  = name.trimmingCharacters(in: .whitespaces)
        currentUserPhone = phone
        isLoggedIn = true
        return true
    }

    // MARK: - Logout

    func logout() {
        isLoggedIn = false
        currentUserName = ""
        currentUserPhone = ""
        KeychainHelper.delete(forKey: KeychainHelper.Keys.isLoggedIn)
        KeychainHelper.delete(forKey: KeychainHelper.Keys.userName)
        KeychainHelper.delete(forKey: KeychainHelper.Keys.userPhone)
    }

    func resetOnboarding() {
        hasSeenOnboarding = false
        logout()
    }
}
