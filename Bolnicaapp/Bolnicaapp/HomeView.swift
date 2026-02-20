import SwiftUI

struct HomeView: View {
    @Environment(AuthManager.self) private var auth

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 24) {
                    headerSection
                    emergencyBanner
                    quickCategoriesSection
                    frequentlyUsedSection
                    personalDataSection
                }
                .padding(.bottom, 24)
            }
            .background(Color(.systemBackground))
            .navigationBarHidden(true)
        }
    }

    // MARK: - Header

    private var headerSection: some View {
        HStack(spacing: 12) {
            NavigationLink(destination: CabinetView()) {
                HStack(spacing: 12) {
                    ZStack {
                        Circle().fill(Color.appBlue).frame(width: 52, height: 52)
                        Image(systemName: "person.fill").font(.title2).foregroundColor(.white)
                    }
                    VStack(alignment: .leading, spacing: 4) {
                        Text(auth.currentUserName.isEmpty ? "İstifadəçi" : auth.currentUserName)
                            .font(.headline).fontWeight(.semibold).foregroundColor(Color(.label))
                        HStack(spacing: 4) {
                            Text("Kabinetim")
                                .font(.caption).foregroundColor(.appBlue)
                            Image(systemName: "chevron.right")
                                .font(.system(size: 9)).foregroundColor(.appBlue)
                        }
                    }
                }
            }
            Spacer()
        }
        .padding(.horizontal)
        .padding(.top, 16)
        .fadeIn(delay: 0.05)
    }

    // MARK: - Emergency banner

    private var emergencyBanner: some View {
        Button {
            if let url = URL(string: "tel://103") {
                UIApplication.shared.open(url)
            }
        } label: {
            HStack(spacing: 14) {
                ZStack {
                    Circle()
                        .fill(Color.red.opacity(0.15))
                        .frame(width: 48, height: 48)
                    Image(systemName: "cross.case.fill")
                        .font(.title3)
                        .foregroundColor(.red)
                }
                VStack(alignment: .leading, spacing: 2) {
                    Text("Təcili tibbi yardım")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(Color(.label))
                    Text("Ambulans çağırın")
                        .font(.caption)
                        .foregroundColor(Color(.secondaryLabel))
                }
                Spacer()
                Text("103")
                    .font(.title2)
                    .fontWeight(.black)
                    .foregroundColor(.red)
                Image(systemName: "phone.fill")
                    .foregroundColor(.red)
            }
            .padding(14)
            .background(Color.red.opacity(0.07))
            .clipShape(RoundedRectangle(cornerRadius: 18))
            .overlay(
                RoundedRectangle(cornerRadius: 18)
                    .stroke(Color.red.opacity(0.2), lineWidth: 1)
            )
        }
        .padding(.horizontal)
        .fadeIn(delay: 0.08)
    }

    // MARK: - Quick categories

    private var quickCategoriesSection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(Array(SampleData.appointmentCategories.enumerated()), id: \.element.id) { index, cat in
                    NavigationLink(destination: ClinicPickerView()) {
                        VStack(spacing: 6) {
                            Image(systemName: cat.icon)
                                .font(.title3)
                                .foregroundColor(Color.appBlue)
                        }
                        .frame(width: 110, height: 80)
                        .background(Color.appBlue.opacity(0.12))
                        .cornerRadius(18)
                    }
                    .fadeIn(delay: Double(index) * 0.06)
                }
            }
            .padding(.horizontal)
        }
    }

    // MARK: - Frequently used

    private var frequentlyUsedSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Ən çox istifadə edilənlər")
                .font(.title3).fontWeight(.bold).padding(.horizontal)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(Array(frequentItems.enumerated()), id: \.offset) { index, item in
                        NavigationLink(destination: ClinicPickerView()) {
                            FrequentCard(title: item.title, icon: item.icon,
                                         iconColor: item.iconColor, bgColor: item.bgColor)
                        }
                        .fadeIn(delay: Double(index) * 0.06)
                    }
                }
                .padding(.horizontal)
            }
        }
        .fadeIn(delay: 0.15)
    }

    // MARK: - Personal data

    private var personalDataSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Mənim şəxsi məlumatlarım")
                .font(.title3).fontWeight(.bold).padding(.horizontal)

            HStack(alignment: .top, spacing: 12) {
                // Left column
                VStack(spacing: 12) {
                    NavigationLink(destination: MedicalCardView()) {
                        PersonalDataCard(title: "Sənədlər",
                            gradient: [Color(red: 0.55, green: 0.6, blue: 0.7), Color(red: 0.35, green: 0.4, blue: 0.55)],
                            icon: "folder.fill", height: 160)
                    }
                    NavigationLink(destination: ClinicPickerView()) {
                        PersonalDataCard(title: "Qeydlər",
                            gradient: [Color(red: 0.75, green: 0.78, blue: 0.85), Color(red: 0.55, green: 0.58, blue: 0.68)],
                            icon: "calendar", height: 160)
                    }
                    NavigationLink(destination: ReferralDetailView()) {
                        PersonalDataCard(title: "Göndərişlər",
                            gradient: [Color(red: 0.6, green: 0.72, blue: 0.85), Color(red: 0.4, green: 0.52, blue: 0.72)],
                            icon: "arrow.triangle.branch", height: 160)
                    }
                }
                // Right column
                VStack(spacing: 12) {
                    NavigationLink(destination: ClinicPickerView()) {
                        PersonalDataCard(title: "İnstrumental diaqnostika",
                            gradient: [Color(red: 0.5, green: 0.62, blue: 0.78), Color(red: 0.3, green: 0.42, blue: 0.65)],
                            icon: "waveform.path.ecg.rectangle.fill", height: 252)
                    }
                    NavigationLink(destination: ClinicPickerView()) {
                        PersonalDataCard(title: "Laboratoriya",
                            gradient: [Color(red: 0.65, green: 0.75, blue: 0.6), Color(red: 0.42, green: 0.58, blue: 0.42)],
                            icon: "testtube.2", height: 160)
                    }
                    NavigationLink(destination: ClinicPickerView()) {
                        PersonalDataCard(title: "Analizlər",
                            gradient: [Color(red: 0.78, green: 0.65, blue: 0.55), Color(red: 0.6, green: 0.45, blue: 0.38)],
                            icon: "drop.triangle.fill", height: 160)
                    }
                }
            }
            .padding(.horizontal)
        }
        .fadeIn(delay: 0.25)
    }

    // MARK: - Data

    private var frequentItems: [(title: String, icon: String, iconColor: Color, bgColor: Color)] {
        [
            ("Müraciətlər", "stethoscope",
             Color(red: 0.6, green: 0.5, blue: 0.95), Color(red: 0.93, green: 0.91, blue: 1.0)),
            ("Göndərişlər", "doc.on.doc.fill",
             Color(red: 0.75, green: 0.5, blue: 0.9), Color(red: 0.96, green: 0.91, blue: 1.0)),
            ("Laboratoriya", "allergens",
             Color(red: 0.85, green: 0.65, blue: 0.1), Color(red: 1.0, green: 0.97, blue: 0.88)),
            ("Növbə al", "calendar.badge.plus",
             Color(red: 0.2, green: 0.7, blue: 0.5), Color(red: 0.88, green: 0.97, blue: 0.93)),
        ]
    }
}

// MARK: - Frequent Card

struct FrequentCard: View {
    let title: String
    let icon: String
    let iconColor: Color
    let bgColor: Color

    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        VStack(spacing: 10) {
            ZStack {
                Circle().fill(iconColor.opacity(0.2)).frame(width: 52, height: 52)
                Image(systemName: icon).font(.title3).foregroundColor(iconColor)
            }
            Text(title)
                .font(.caption).fontWeight(.medium)
                .foregroundColor(colorScheme == .dark ? .white : .black)
                .multilineTextAlignment(.center)
        }
        .frame(width: 110, height: 120)
        .background(colorScheme == .dark ? iconColor.opacity(0.15) : bgColor)
        .cornerRadius(20)
    }
}

// MARK: - Personal Data Card

struct PersonalDataCard: View {
    let title: String
    let gradient: [Color]
    let icon: String
    let height: CGFloat

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            LinearGradient(colors: gradient, startPoint: .topTrailing, endPoint: .bottomLeading)
            Image(systemName: icon)
                .font(.system(size: 64))
                .foregroundColor(.white.opacity(0.15))
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                .padding(.top, 16).padding(.trailing, 12)
            Text(title)
                .font(.subheadline).fontWeight(.bold).foregroundColor(.white)
                .padding(14)
        }
        .frame(maxWidth: .infinity)
        .frame(height: height)
        .cornerRadius(20)
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
            Image(systemName: icon).font(.title3).foregroundColor(.appBlue).frame(width: 32, height: 32)
            VStack(alignment: .leading, spacing: 2) {
                Text(title).font(.body).foregroundColor(Color(.label))
                if let subtitle {
                    Text(subtitle).font(.caption).foregroundColor(Color(.secondaryLabel))
                }
            }
            Spacer()
            if let badge {
                Text("\(badge)")
                    .font(.subheadline).foregroundColor(Color(.secondaryLabel))
                    .padding(.horizontal, 8).padding(.vertical, 2)
                    .background(Color.badgeBackground).clipShape(Capsule())
            }
            Image(systemName: "chevron.right").font(.caption).foregroundColor(Color(.tertiaryLabel))
        }
        .padding(.horizontal, 16).padding(.vertical, 12)
        .contentShape(Rectangle())
    }
}

#Preview {
    HomeView()
        .environment(AuthManager())
        .environment(LocationManager())
        .environment(ClinicViewModel())
}
