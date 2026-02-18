import SwiftUI

struct MoreView: View {
    @Environment(AuthManager.self) private var auth
    @State private var appeared = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    // MARK: - Appearance mode picker
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Görünüş")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(Color(.secondaryLabel))
                            .padding(.horizontal, 4)

                        HStack(spacing: 0) {
                            ForEach([AppearanceMode.system, .light, .dark], id: \.rawValue) { mode in
                                Button(action: {
                                    withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                                        auth.appearanceMode = mode
                                    }
                                }) {
                                    VStack(spacing: 4) {
                                        Image(systemName: mode.icon)
                                            .font(.body)
                                        Text(mode.label)
                                            .font(.caption)
                                    }
                                    .foregroundColor(auth.appearanceMode == mode ? .white : Color(.label))
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 10)
                                    .background(
                                        auth.appearanceMode == mode
                                            ? Color.appBlue
                                            : Color.clear
                                    )
                                    .cornerRadius(12)
                                }
                            }
                        }
                        .padding(4)
                        .background(Color(.tertiarySystemFill))
                        .cornerRadius(14)
                    }
                    .padding(.horizontal)
                    .padding(.top, 8)
                    .opacity(appeared ? 1 : 0)
                    .offset(y: appeared ? 0 : 10)
                    .animation(.spring(response: 0.5, dampingFraction: 0.8).delay(0.05), value: appeared)

                    // MARK: - Policy list
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Sığorta polisləri")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(Color(.secondaryLabel))
                            .padding(.horizontal, 4)

                        VStack(spacing: 0) {
                            ForEach(Array(SampleData.policies.enumerated()), id: \.element.id) { index, policy in
                                PolicyRow(policy: policy)
                                    .opacity(appeared ? 1 : 0)
                                    .offset(x: appeared ? 0 : 20)
                                    .animation(
                                        .spring(response: 0.5, dampingFraction: 0.8)
                                        .delay(0.1 + Double(index) * 0.06),
                                        value: appeared
                                    )
                                if index < SampleData.policies.count - 1 {
                                    Divider().padding(.leading, 68)
                                }
                            }
                        }
                        .background(Color.cardBackground)
                        .cornerRadius(18)
                    }
                    .padding(.horizontal)

                    // Add new policy
                    Button(action: {}) {
                        HStack {
                            Image(systemName: "plus")
                            Text("Yeni polis əlavə et")
                        }
                        .font(.headline)
                        .foregroundColor(.appBlue)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Color.appBlue.opacity(0.12))
                        .cornerRadius(16)
                    }
                    .padding(.horizontal)
                    .opacity(appeared ? 1 : 0)
                    .animation(.spring(response: 0.5).delay(0.4), value: appeared)

                    // Logout
                    Button(action: {
                        withAnimation(.spring(response: 0.4)) {
                            auth.resetOnboarding()
                        }
                    }) {
                        HStack {
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                            Text("Çıxış")
                        }
                        .font(.body)
                        .foregroundColor(.red)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Color(.tertiarySystemFill))
                        .cornerRadius(16)
                    }
                    .padding(.horizontal)
                    .padding(.top, 8)
                    .opacity(appeared ? 1 : 0)
                    .animation(.spring(response: 0.5).delay(0.5), value: appeared)
                }
                .padding(.bottom, 20)
            }
            .background(Color.sectionBackground)
            .navigationTitle("Əlavə")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear {
            withAnimation {
                appeared = true
            }
        }
    }
}

struct PolicyRow: View {
    let policy: InsurancePolicy

    var body: some View {
        HStack(spacing: 14) {
            Text(policy.initials)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(Color(.secondaryLabel))
                .frame(width: 44, height: 44)
                .background(Color(.tertiarySystemFill))
                .clipShape(RoundedRectangle(cornerRadius: 14))

            VStack(alignment: .leading, spacing: 3) {
                Text(policy.name)
                    .font(.body)
                    .fontWeight(.medium)
                    .foregroundColor(Color(.label))
                Text(policy.policyNumber)
                    .font(.subheadline)
                    .foregroundColor(Color(.secondaryLabel))
                if policy.hasAccess {
                    Text("Tibbi karta giriş var")
                        .font(.caption)
                        .foregroundColor(.green)
                }
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(Color(.tertiaryLabel))
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }
}

#Preview {
    MoreView()
        .environment(AuthManager())
}
