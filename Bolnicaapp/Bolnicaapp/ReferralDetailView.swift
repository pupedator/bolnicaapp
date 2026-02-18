import SwiftUI

struct ReferralDetailView: View {
    @State private var appeared = false
    @State private var progressWidth: CGFloat = 0

    let tests = [
        "Ümumi bilirubin",
        "Ümumi klinik qan analizi (skrininq)",
        "Ümumi xolesterin",
        "Aşağı sıxlıqlı lipoproteinlər (ASLP-beta)",
    ]

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    // MARK: - Title
                    Text("Venoz qan götürülməsi")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.horizontal)
                        .padding(.top, 12)
                        .opacity(appeared ? 1 : 0)
                        .offset(y: appeared ? 0 : 10)

                    // MARK: - Date range + progress bar
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("24 noy – 24 dek")
                                .font(.subheadline)
                                .foregroundColor(Color(.label))
                            Spacer()
                            Text("daha 10 gün")
                                .font(.subheadline)
                                .foregroundColor(Color(.secondaryLabel))
                        }

                        // Progress bar with animation
                        GeometryReader { geo in
                            ZStack(alignment: .leading) {
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(Color(.tertiarySystemFill))
                                    .frame(height: 8)
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(Color.appBlue)
                                    .frame(width: progressWidth, height: 8)
                            }
                            .onAppear {
                                withAnimation(.easeOut(duration: 1.0).delay(0.3)) {
                                    progressWidth = geo.size.width * 0.67
                                }
                            }
                        }
                        .frame(height: 8)
                    }
                    .padding(.horizontal)
                    .opacity(appeared ? 1 : 0)
                    .animation(.spring(response: 0.5).delay(0.1), value: appeared)

                    // MARK: - Tests list
                    VStack(alignment: .leading, spacing: 0) {
                        ForEach(Array(tests.enumerated()), id: \.offset) { index, test in
                            HStack(alignment: .top, spacing: 8) {
                                Text("•")
                                    .font(.body)
                                    .foregroundColor(Color(.label))
                                Text(test)
                                    .font(.body)
                                    .foregroundColor(Color(.label))
                            }
                            .padding(.vertical, 6)
                            .opacity(appeared ? 1 : 0)
                            .offset(x: appeared ? 0 : -20)
                            .animation(
                                .spring(response: 0.4, dampingFraction: 0.8)
                                .delay(0.2 + Double(index) * 0.08),
                                value: appeared
                            )
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 8)

                    Divider()
                        .padding(.top, 16)

                    // MARK: - Preparation link
                    HStack {
                        Text("Tədqiqata necə hazırlaşmalı")
                            .font(.body)
                            .foregroundColor(Color(.label))
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundColor(Color(.tertiaryLabel))
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                    .opacity(appeared ? 1 : 0)
                }
            }

            // MARK: - Bottom button
            Button(action: {}) {
                Text("Növbə al")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(Color.appBlue)
                    .cornerRadius(16)
            }
            .padding(.horizontal)
            .padding(.bottom, 16)
            .padding(.top, 8)
            .opacity(appeared ? 1 : 0)
            .scaleEffect(appeared ? 1 : 0.95)
            .animation(.spring(response: 0.5).delay(0.5), value: appeared)
        }
        .background(Color(.systemBackground))
        .navigationTitle("Göndəriş")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                appeared = true
            }
        }
    }
}

#Preview {
    NavigationStack {
        ReferralDetailView()
    }
}
