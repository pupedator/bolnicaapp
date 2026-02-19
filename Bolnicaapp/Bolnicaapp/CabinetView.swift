import SwiftUI

struct CabinetView: View {
    @Environment(AuthManager.self) private var auth
    @Environment(\.dismiss) private var dismiss
    @State private var editingName = false
    @State private var draftName = ""

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 24) {
                // Avatar + name
                avatarSection

                // Info cards
                infoSection

                // Stats row
                statsRow

                // Account actions
                actionsSection
            }
            .padding(.vertical)
        }
        .background(Color.sectionBackground)
        .navigationTitle("Mənim kabinetim")
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Avatar

    private var avatarSection: some View {
        VStack(spacing: 12) {
            ZStack(alignment: .bottomTrailing) {
                Circle()
                    .fill(LinearGradient(
                        colors: [Color.appBlue, Color.appBlueDark],
                        startPoint: .topLeading, endPoint: .bottomTrailing))
                    .frame(width: 90, height: 90)
                Image(systemName: "person.fill")
                    .font(.system(size: 40))
                    .foregroundColor(.white)

                Circle()
                    .fill(Color.cardBackground)
                    .frame(width: 28, height: 28)
                    .overlay(
                        Image(systemName: "pencil")
                            .font(.caption)
                            .foregroundColor(.appBlue)
                    )
            }

            if editingName {
                HStack(spacing: 8) {
                    TextField("Adınız", text: $draftName)
                        .font(.headline)
                        .multilineTextAlignment(.center)
                        .textFieldStyle(.roundedBorder)
                        .frame(maxWidth: 200)
                    Button {
                        auth.currentUserName = draftName.trimmingCharacters(in: .whitespaces)
                        editingName = false
                    } label: {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.appBlue)
                            .font(.title3)
                    }
                }
            } else {
                Button {
                    draftName = auth.currentUserName
                    editingName = true
                } label: {
                    HStack(spacing: 6) {
                        Text(auth.currentUserName.isEmpty ? "Ad əlavə edin" : auth.currentUserName)
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(Color(.label))
                        Image(systemName: "pencil")
                            .font(.caption)
                            .foregroundColor(.appBlue)
                    }
                }
            }

            Text(auth.currentUserPhone.isEmpty ? "–" : auth.currentUserPhone)
                .font(.subheadline)
                .foregroundColor(Color(.secondaryLabel))
        }
        .padding(.top, 8)
        .fadeIn(delay: 0.05)
    }

    // MARK: - Info cards

    private var infoSection: some View {
        VStack(spacing: 0) {
            infoRow(icon: "person.text.rectangle.fill",
                    label: "Ad Soyad",
                    value: auth.currentUserName.isEmpty ? "–" : auth.currentUserName)
            Divider().padding(.leading, 56)
            infoRow(icon: "phone.fill",
                    label: "Telefon",
                    value: auth.currentUserPhone.isEmpty ? "–" : auth.currentUserPhone)
            Divider().padding(.leading, 56)
            infoRow(icon: "calendar",
                    label: "Doğum tarixi",
                    value: "–")
            Divider().padding(.leading, 56)
            infoRow(icon: "mappin.and.ellipse",
                    label: "Ünvan",
                    value: "–")
        }
        .background(Color.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .padding(.horizontal)
        .fadeIn(delay: 0.1)
    }

    // MARK: - Stats

    private var statsRow: some View {
        HStack(spacing: 12) {
            StatCard(value: "0", label: "Qeydlər", icon: "calendar.badge.checkmark", color: .appBlue)
            StatCard(value: "0", label: "Sənədlər", icon: "folder.fill", color: Color(red: 0.5, green: 0.62, blue: 0.78))
            StatCard(value: "0", label: "Göndərişlər", icon: "arrow.triangle.branch", color: Color(red: 0.6, green: 0.5, blue: 0.95))
        }
        .padding(.horizontal)
        .fadeIn(delay: 0.15)
    }

    // MARK: - Actions

    private var actionsSection: some View {
        VStack(spacing: 0) {
            actionRow(icon: "bell.fill", label: "Bildirişlər", iconColor: .orange)
            Divider().padding(.leading, 56)
            actionRow(icon: "lock.fill", label: "Şifrəni dəyiş", iconColor: .appBlue)
            Divider().padding(.leading, 56)
            actionRow(icon: "questionmark.circle.fill", label: "Yardım", iconColor: Color(red: 0.3, green: 0.7, blue: 0.5))
        }
        .background(Color.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .padding(.horizontal)
        .fadeIn(delay: 0.2)
    }

    // MARK: - Helpers

    private func infoRow(icon: String, label: String, value: String) -> some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .font(.body)
                .foregroundColor(.appBlue)
                .frame(width: 30)
            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(.caption)
                    .foregroundColor(Color(.secondaryLabel))
                Text(value)
                    .font(.subheadline)
                    .foregroundColor(Color(.label))
            }
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }

    private func actionRow(icon: String, label: String, iconColor: Color) -> some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .font(.body)
                .foregroundColor(iconColor)
                .frame(width: 30)
            Text(label)
                .font(.subheadline)
                .foregroundColor(Color(.label))
            Spacer()
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(Color(.tertiaryLabel))
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .contentShape(Rectangle())
    }
}

// MARK: - Stat Card

private struct StatCard: View {
    let value: String
    let label: String
    let icon: String
    let color: Color

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(color)
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(Color(.label))
            Text(label)
                .font(.caption2)
                .foregroundColor(Color(.secondaryLabel))
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(Color.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

#Preview {
    NavigationStack {
        CabinetView()
            .environment(AuthManager())
    }
}
