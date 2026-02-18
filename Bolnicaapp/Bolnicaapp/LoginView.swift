import SwiftUI

struct LoginView: View {
    @Environment(AuthManager.self) private var auth
    @State private var phone = ""
    @State private var password = ""
    @State private var showRegister = false
    @State private var showError = false
    @State private var appeared = false

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

                            Text("Təbibim")
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
                                Button("Şifrəni unutdun?") {}
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

                // Bottom button
                Button(action: handleLogin) {
                    Text("Daxil ol")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.appBlue)
                        .cornerRadius(16)
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
                Text("Telefon nömrəsi və şifrə boş ola bilməz")
            }
            .navigationDestination(isPresented: $showRegister) {
                RegisterView()
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
            if !auth.login(phone: phone, password: password) {
                showError = true
            }
        }
    }
}

#Preview {
    LoginView()
        .environment(AuthManager())
}
