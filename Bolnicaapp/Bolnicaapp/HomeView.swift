import SwiftUI

struct HomeView: View {
    @Environment(AuthManager.self) private var auth
    @State private var showAppointmentBooking = false
    @State private var appeared = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    // MARK: - Qeydiyyat section
                    HStack {
                        Text("Növbə")
                            .font(.title2)
                            .fontWeight(.bold)
                        Spacer()
                        Button("Bütün məqsədlər") {}
                            .foregroundColor(.appBlue)
                    }
                    .padding(.horizontal)
                    .padding(.top, 16)
                    .padding(.bottom, 12)
                    .opacity(appeared ? 1 : 0)
                    .offset(y: appeared ? 0 : 10)

                    // Horizontal category cards
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(Array(SampleData.appointmentCategories.enumerated()), id: \.element.id) { index, cat in
                                CategoryCard(title: cat.title, icon: cat.icon)
                                    .opacity(appeared ? 1 : 0)
                                    .offset(y: appeared ? 0 : 20)
                                    .animation(
                                        .spring(response: 0.5, dampingFraction: 0.8)
                                        .delay(Double(index) * 0.06),
                                        value: appeared
                                    )
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding(.bottom, 16)

                    // Növbə al button
                    Button(action: { showAppointmentBooking = true }) {
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
                    .opacity(appeared ? 1 : 0)
                    .scaleEffect(appeared ? 1 : 0.95)

                    // MARK: - Qeydlər / Göndərişlər card
                    VStack(spacing: 0) {
                        NavigationLink(destination: DoctorTimeSlotsView()) {
                            MenuRowView(
                                icon: "calendar.badge.clock",
                                title: "Qeydlər",
                                subtitle: "Ən yaxın: 22 dekabr",
                                badge: 5
                            )
                        }
                        Divider().padding(.leading, 56)
                        NavigationLink(destination: ReferralDetailView()) {
                            MenuRowView(
                                icon: "arrow.triangle.branch",
                                title: "Göndərişlər",
                                subtitle: nil,
                                badge: 2
                            )
                        }
                    }
                    .background(Color.cardBackground)
                    .cornerRadius(18)
                    .padding(.horizontal)
                    .padding(.bottom, 24)
                    .opacity(appeared ? 1 : 0)
                    .offset(y: appeared ? 0 : 15)
                    .animation(.spring(response: 0.5, dampingFraction: 0.8).delay(0.2), value: appeared)

                    // MARK: - Dərmanlar section
                    Text("Dərmanlar")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.horizontal)
                        .padding(.bottom, 12)
                        .opacity(appeared ? 1 : 0)

                    VStack(spacing: 0) {
                        MenuRowView(icon: "pills.circle", title: "Həb qutusu", subtitle: nil, badge: nil)
                        Divider().padding(.leading, 56)
                        MenuRowView(icon: "doc.text", title: "Reseptlər", subtitle: nil, badge: nil)
                        Divider().padding(.leading, 56)
                        MenuRowView(icon: "house.fill", title: "Aptek sifarişləri", subtitle: nil, badge: 5)
                    }
                    .background(Color.cardBackground)
                    .cornerRadius(18)
                    .padding(.horizontal)
                    .padding(.bottom, 24)
                    .opacity(appeared ? 1 : 0)
                    .offset(y: appeared ? 0 : 15)
                    .animation(.spring(response: 0.5, dampingFraction: 0.8).delay(0.3), value: appeared)

                    // MARK: - Sizin üçün xidmətlər section
                    Text("Sizin üçün xidmətlər")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.horizontal)
                        .padding(.bottom, 12)
                        .opacity(appeared ? 1 : 0)

                    VStack(spacing: 0) {
                        MenuRowView(icon: "stethoscope", title: "Dispanserizasiya", subtitle: nil, badge: nil)
                        Divider().padding(.leading, 56)
                        MenuRowView(icon: "person.badge.clock", title: "Dispanser müşahidəsi", subtitle: nil, badge: nil)
                        Divider().padding(.leading, 56)
                        MenuRowView(icon: "wrench.and.screwdriver", title: "Şəxsi köməkçi", subtitle: nil, badge: nil)
                        Divider().padding(.leading, 56)
                        MenuRowView(icon: "cross.case", title: "COVID-19 ekspress-test", subtitle: nil, badge: nil)
                    }
                    .background(Color.cardBackground)
                    .cornerRadius(18)
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                    .opacity(appeared ? 1 : 0)
                    .offset(y: appeared ? 0 : 15)
                    .animation(.spring(response: 0.5, dampingFraction: 0.8).delay(0.4), value: appeared)
                }
            }
            .background(Color.sectionBackground)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {}) {
                        HStack(spacing: 4) {
                            Image(systemName: "creditcard")
                            Text("Sığortam")
                                .fontWeight(.semibold)
                            Image(systemName: "chevron.right")
                                .font(.caption)
                        }
                        .foregroundColor(.white)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack(spacing: 16) {
                        Button(action: {}) {
                            Image(systemName: "qrcode")
                                .foregroundColor(.white)
                        }
                        Button(action: {}) {
                            Image(systemName: "bell")
                                .foregroundColor(.white)
                        }
                    }
                }
            }
            .toolbarBackground(Color.appBlue, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
        }
        .sheet(isPresented: $showAppointmentBooking) {
            AppointmentBookingView()
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                appeared = true
            }
        }
    }
}

// MARK: - Category Card

struct CategoryCard: View {
    let title: String
    let icon: String
    @State private var pressed = false

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.appBlue)
                .frame(height: 28)
            Text(title)
                .font(.caption)
                .multilineTextAlignment(.center)
                .foregroundColor(Color(.label))
                .lineLimit(2)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(width: 110, height: 90)
        .background(Color.cardBackground)
        .cornerRadius(18)
        .scaleEffect(pressed ? 0.95 : 1)
        .onTapGesture {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                pressed = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    pressed = false
                }
            }
        }
    }
}

// MARK: - Reusable Menu Row

struct MenuRowView: View {
    let icon: String
    let title: String
    let subtitle: String?
    let badge: Int?

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(.appBlue)
                .frame(width: 32, height: 32)

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.body)
                    .foregroundColor(Color(.label))
                if let subtitle {
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(Color(.secondaryLabel))
                }
            }

            Spacer()

            if let badge {
                Text("\(badge)")
                    .font(.subheadline)
                    .foregroundColor(Color(.secondaryLabel))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 2)
                    .background(Color.badgeBackground)
                    .clipShape(Capsule())
            }

            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(Color(.tertiaryLabel))
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .contentShape(Rectangle())
    }
}

#Preview {
    HomeView()
        .environment(AuthManager())
}
