import SwiftUI

struct RegisterView: View {
    @Environment(AuthManager.self) private var auth
    @Environment(\.dismiss) private var dismiss
    @State private var fullName = ""
    @State private var phone = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var showError = false
    @State private var errorMessage = ""
    @State private var appeared = false

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    // Header
                    VStack(spacing: 10) {
                        Image(systemName: "person.badge.plus")
                            .font(.system(size: 48))
                            .foregroundColor(.appBlue)
                            .opacity(appeared ? 1 : 0)
                            .scaleEffect(appeared ? 1 : 0.5)

                        Text("Yeni hesab yarat")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(Color(.label))

                        Text("Məlumatlarınızı daxil edin")
                            .font(.subheadline)
                            .foregroundColor(Color(.secondaryLabel))
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top, 24)
                    .padding(.bottom, 32)
                    .opacity(appeared ? 1 : 0)
                    .offset(y: appeared ? 0 : -10)

                    // Form fields
                    VStack(alignment: .leading, spacing: 18) {
                        // Full name
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Ad və Soyad")
                                .font(.subheadline)
                                .foregroundColor(Color(.secondaryLabel))
                            HStack(spacing: 10) {
                                Image(systemName: "person")
                                    .foregroundColor(.appBlue)
                                    .frame(width: 24)
                                TextField("Adınızı daxil edin", text: $fullName)
                            }
                            .padding(14)
                            .background(Color(.tertiarySystemFill))
                            .cornerRadius(14)
                        }

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
                                SecureField("Minimum 8 simvol, 1 rəqəm", text: $password)
                            }
                            .padding(14)
                            .background(Color(.tertiarySystemFill))
                            .cornerRadius(14)
                        }

                        // Confirm password
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Şifrəni təsdiqlə")
                                .font(.subheadline)
                                .foregroundColor(Color(.secondaryLabel))
                            HStack(spacing: 10) {
                                Image(systemName: "lock.rotation")
                                    .foregroundColor(.appBlue)
                                    .frame(width: 24)
                                SecureField("Şifrəni yenidən daxil edin", text: $confirmPassword)
                            }
                            .padding(14)
                            .background(Color(.tertiarySystemFill))
                            .cornerRadius(14)
                        }
                    }
                    .padding(.horizontal)
                    .opacity(appeared ? 1 : 0)
                    .offset(y: appeared ? 0 : 15)
                    .animation(.spring(response: 0.5, dampingFraction: 0.8).delay(0.15), value: appeared)

                    Spacer().frame(height: 24)

                    // Back to login link
                    HStack(spacing: 4) {
                        Text("Artıq hesabın var?")
                            .font(.subheadline)
                            .foregroundColor(Color(.secondaryLabel))
                        Button("Daxil ol") { dismiss() }
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
            Button(action: handleRegister) {
                Text("Qeydiyyatdan keç")
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
        .navigationTitle("Qeydiyyat")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { dismiss() }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.appBlue)
                }
            }
        }
        .alert("Xəta", isPresented: $showError) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(errorMessage)
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                appeared = true
            }
        }
    }

    private func handleRegister() {
        guard !fullName.trimmingCharacters(in: .whitespaces).isEmpty else {
            errorMessage = "Ad və Soyad boş ola bilməz"
            showError = true
            return
        }
        guard AuthManager.isValidAzerbaijaniPhone(phone) else {
            errorMessage = "Düzgün telefon nömrəsi daxil edin (+994XXXXXXXXX və ya 0XXXXXXXXX)"
            showError = true
            return
        }
        guard AuthManager.isValidPassword(password) else {
            errorMessage = "Şifrə minimum 8 simvol olmalı və ən azı 1 rəqəm içərməlidir"
            showError = true
            return
        }
        guard password == confirmPassword else {
            errorMessage = "Şifrələr uyğun gəlmir"
            showError = true
            return
        }

        withAnimation(.spring(response: 0.3)) {
            _ = auth.register(name: fullName, phone: phone, password: password)
        }
    }
}

#Preview {
    NavigationStack {
        RegisterView()
            .environment(AuthManager())
    }
}
