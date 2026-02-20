import SwiftUI

struct DigitalIDView: View {
    @Environment(AuthManager.self) private var auth
    @Environment(\.dismiss) private var dismiss
    @State private var appeared = false
    @State private var scanning = false
    @State private var scanProgress: CGFloat = 0
    @State private var scanTimer: Timer?

    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Button(action: { dismiss() }) {
                    Image(systemName: "chevron.left")
                        .font(.title3)
                        .foregroundColor(Color(.label))
                }
                Spacer()
                Image(systemName: "shield.checkered")
                    .foregroundColor(.appBlue)
                    .font(.title3)
            }
            .padding(.horizontal, 24)
            .padding(.top, 16)
            .opacity(appeared ? 1 : 0)

            Spacer()

            // Logo & title
            VStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(Color.appBlue.opacity(0.08))
                        .frame(width: 110, height: 110)
                    Circle()
                        .fill(Color.appBlue.opacity(0.14))
                        .frame(width: 84, height: 84)
                    Image(systemName: "person.crop.rectangle.badge.checkmark")
                        .font(.system(size: 38, weight: .medium))
                        .foregroundColor(.appBlue)
                }
                .scaleEffect(appeared ? 1 : 0.7)
                .opacity(appeared ? 1 : 0)

                Text("Digital ID ilə daxil ol")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(Color(.label))
                    .opacity(appeared ? 1 : 0)

                Text("Şəxsiyyət vəsiqənizdəki NFC çipini\nistifadə edərək təhlükəsiz giriş edin")
                    .font(.subheadline)
                    .foregroundColor(Color(.secondaryLabel))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
                    .opacity(appeared ? 1 : 0)
            }
            .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.1), value: appeared)

            Spacer()

            // NFC card illustration
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(
                        LinearGradient(
                            colors: [Color.appBlue, Color.appBlueDark],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 260, height: 164)
                    .shadow(color: Color.appBlue.opacity(0.35), radius: 20, y: 10)

                VStack(alignment: .leading, spacing: 0) {
                    HStack {
                        Image(systemName: "wifi")
                            .rotationEffect(.degrees(90))
                            .font(.title2)
                            .foregroundColor(.white.opacity(0.8))
                        Spacer()
                        Text("AZ")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.white.opacity(0.7))
                    }
                    Spacer()
                    VStack(alignment: .leading, spacing: 4) {
                        Text("•••• •••• •••• ••••")
                            .font(.system(size: 16, weight: .medium, design: .monospaced))
                            .foregroundColor(.white.opacity(0.7))
                        Text("VƏTƏNDAŞ / CITIZEN")
                            .font(.caption2)
                            .fontWeight(.semibold)
                            .foregroundColor(.white.opacity(0.6))
                    }
                }
                .padding(20)
                .frame(width: 260, height: 164)

                // Scan line animation
                if scanning {
                    Rectangle()
                        .fill(
                            LinearGradient(
                                colors: [.clear, .white.opacity(0.6), .clear],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(height: 2)
                        .frame(width: 260)
                        .offset(y: -82 + scanProgress * 164)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                }
            }
            .opacity(appeared ? 1 : 0)
            .animation(.spring(response: 0.7, dampingFraction: 0.8).delay(0.2), value: appeared)

            Spacer()

            // Info rows
            VStack(spacing: 12) {
                infoRow(icon: "lock.shield.fill", color: .green,
                        text: "Şifrə tələb olunmur")
                infoRow(icon: "person.text.rectangle.fill", color: .appBlue,
                        text: "Şəxsiyyətin avtomatik yoxlanması")
                infoRow(icon: "building.columns.fill", color: .orange,
                        text: "Dövlət tərəfindən təsdiqlənmiş")
            }
            .padding(.horizontal, 32)
            .opacity(appeared ? 1 : 0)
            .animation(.spring(response: 0.6).delay(0.35), value: appeared)

            Spacer()

            // Scan button
            Button(action: startScan) {
                HStack(spacing: 10) {
                    if scanning {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .scaleEffect(0.85)
                        Text("Skan edilir...")
                    } else {
                        Image(systemName: "wave.3.right")
                        Text("NFC ilə skan et")
                    }
                }
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 17)
                .background(scanning ? Color.gray : Color.appBlue)
                .cornerRadius(18)
            }
            .disabled(scanning)
            .padding(.horizontal, 24)
            .padding(.bottom, 12)
            .opacity(appeared ? 1 : 0)
            .animation(.spring(response: 0.6).delay(0.4), value: appeared)

            Text("Bu xidmət eTebib və Rəqəmsal ID platforması arasında\ntəhlükəsiz əlaqə vasitəsilə işləyir.")
                .font(.caption2)
                .foregroundColor(Color(.tertiaryLabel))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
                .padding(.bottom, 24)
                .opacity(appeared ? 1 : 0)
        }
        .background(Color(.systemBackground))
        .navigationBarHidden(true)
        .onAppear {
            withAnimation(.spring(response: 0.6)) {
                appeared = true
            }
        }
        .onDisappear {
            scanTimer?.invalidate()
        }
    }

    // MARK: - Helpers

    private func infoRow(icon: String, color: Color, text: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.subheadline)
                .foregroundColor(color)
                .frame(width: 28)
            Text(text)
                .font(.subheadline)
                .foregroundColor(Color(.secondaryLabel))
            Spacer()
        }
    }

    private func startScan() {
        scanning = true
        scanProgress = 0

        // Animate scan line
        scanTimer = Timer.scheduledTimer(withTimeInterval: 0.016, repeats: true) { t in
            scanProgress += 0.012
            if scanProgress >= 1 { scanProgress = 0 }
        }

        // Simulate NFC read then log in
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            scanTimer?.invalidate()
            withAnimation(.spring(response: 0.4)) {
                auth.hasSeenOnboarding = true
                auth.isLoggedIn = true
            }
        }
    }
}

#Preview {
    DigitalIDView()
        .environment(AuthManager())
}
