import SwiftUI

struct LoginView: View {
    @Environment(AuthManager.self) private var auth
    @State private var phone = ""
    @State private var password = ""
    @State private var showRegister = false
    @State private var showError = false
    @State private var showForgotPassword = false
    @State private var errorMessage = ""
    @State private var appeared = false
    @State private var showDigitalID = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        // Logo + Title
                        VStack(spacing: 10) {
                            Image(systemName: "cross.case.circle")
                                .font(.system(size: 56))
                                .foregroundColor(.appBlue)
                                .opacity(appeared ? 1 : 0)
                                .scaleEffect(appeared ? 1 : 0.5)

                            Text("eTebib")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(Color(.label))

                            Text("Tibbi xidmətlər portalı")
                                .font(.subheadline)
                                .foregroundColor(Color(.secondaryLabel))
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.top, 40)
                        .padding(.bottom, 36)
                        .opacity(appeared ? 1 : 0)
                        .offset(y: appeared ? 0 : -10)

                        // Form
                        VStack(alignment: .leading, spacing: 20) {
                            Text("Daxil ol")
                                .font(.title2)
                                .fontWeight(.bold)

                            // Phone
                            VStack(alignment: .leading, spacing: 6) {
                                Text("Telefon nömrəsi")
                                    .font(.subheadline)
                                    .foregroundColor(Color(.secondaryLabel))
                                HStack(spacing: 10) {
                                    Image(systemName: "phone")
                                        .foregroundColor(.appBlue)
                                        .frame(width: 24)
                                    TextField("+994 XX XXX XX XX", text: $phone)
                                        .keyboardType(.phonePad)
                                }
                                .padding(14)
                                .background(Color(.tertiarySystemFill))
                                .cornerRadius(14)
                            }

                            // Password
                            VStack(alignment: .leading, spacing: 6) {
                                Text("Şifrə")
                                    .font(.subheadline)
                                    .foregroundColor(Color(.secondaryLabel))
                                HStack(spacing: 10) {
                                    Image(systemName: "lock")
                                        .foregroundColor(.appBlue)
                                        .frame(width: 24)
                                    SecureField("Şifrənizi daxil edin", text: $password)
                                }
                                .padding(14)
                                .background(Color(.tertiarySystemFill))
                                .cornerRadius(14)
                            }

                            // Forgot password
                            HStack {
                                Spacer()
                                Button("Şifrəni unutdun?") {
                                    showForgotPassword = true
                                }
                                .font(.subheadline)
                                .foregroundColor(.appBlue)
                            }
                        }
                        .padding(.horizontal)
                        .opacity(appeared ? 1 : 0)
                        .offset(y: appeared ? 0 : 15)
                        .animation(.spring(response: 0.5, dampingFraction: 0.8).delay(0.15), value: appeared)

                        Spacer().frame(height: 24)

                        // Register link
                        HStack(spacing: 4) {
                            Text("Hesabın yoxdur?")
                                .font(.subheadline)
                                .foregroundColor(Color(.secondaryLabel))
                            Button("Qeydiyyatdan keç") {
                                showRegister = true
                            }
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.appBlue)
                        }
                        .frame(maxWidth: .infinity)
                        .opacity(appeared ? 1 : 0)
                        .animation(.spring(response: 0.5).delay(0.3), value: appeared)
                    }
                }

                // Lockout warning
                if auth.isLockedOut {
                    HStack(spacing: 6) {
                        Image(systemName: "lock.fill")
                            .font(.caption)
                        Text("Hesab müvəqqəti bloklanıb. \(auth.lockoutRemainingSeconds)s")
                            .font(.caption)
                    }
                    .foregroundColor(.orange)
                    .padding(.vertical, 6)
                }

                // Bottom buttons
                VStack(spacing: 12) {
                    // Main login button
                    Button(action: handleLogin) {
                        Text("Daxil ol")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(auth.isLockedOut ? Color.gray : Color.appBlue)
                            .cornerRadius(16)
                    }
                    .disabled(auth.isLockedOut)

                    // OR divider
                    HStack(spacing: 12) {
                        Rectangle()
                            .fill(Color(.separator))
                            .frame(height: 1)
                        Text("və ya")
                            .font(.caption)
                            .foregroundColor(Color(.tertiaryLabel))
                        Rectangle()
                            .fill(Color(.separator))
                            .frame(height: 1)
                    }

                    // Digital ID button
                    Button(action: { showDigitalID = true }) {
                        HStack(spacing: 8) {
                            Image(systemName: "person.crop.rectangle.badge.checkmark")
                                .font(.body)
                            Text("digital login")
                                .font(.system(size: 16, weight: .semibold))
                            Text("•")
                                .font(.system(size: 18, weight: .bold))
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.appBlue)
                        .cornerRadius(16)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 16)
                .padding(.top, 8)
                .opacity(appeared ? 1 : 0)
                .scaleEffect(appeared ? 1 : 0.95)
                .animation(.spring(response: 0.5).delay(0.35), value: appeared)
            }
            .background(Color(.systemBackground))
            .alert("Xəta", isPresented: $showError) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(errorMessage)
            }
            .alert("Şifrəni sıfırla", isPresented: $showForgotPassword) {
                Button("Bağla", role: .cancel) {}
            } message: {
                Text("Şifrənizi bərpa etmək üçün +994 12 000 00 00 nömrəsinə zəng edin və ya destek@etebib.az ünvanına e-poçt göndərin.")
            }
            .navigationDestination(isPresented: $showRegister) {
                RegisterView()
            }
            .navigationDestination(isPresented: $showDigitalID) {
                DigitalIDView()
            }
            .onAppear {
                withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                    appeared = true
                }
            }
        }
    }

    private func handleLogin() {
        withAnimation(.spring(response: 0.3)) {
            let result = auth.login(phone: phone, password: password)
            switch result {
            case .success:
                break
            case .invalidInput:
                errorMessage = "Düzgün telefon nömrəsi (+994XXXXXXXXX) və şifrə daxil edin"
                showError = true
            case .lockedOut(let until):
                let formatter = DateFormatter()
                formatter.timeStyle = .short
                errorMessage = "Hesab müvəqqəti bloklanıb. \(formatter.string(from: until)) tarixinə qədər cəhd edin."
                showError = true
            }
        }
    }
}

#Preview {
    LoginView()
        .environment(AuthManager())
}
