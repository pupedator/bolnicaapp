import SwiftUI

struct MoreView: View {
    @Environment(AuthManager.self) private var auth

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 16) {

                    // MARK: - Appearance
                    sectionHeader("Görünüş")
                    appearancePicker
                        .padding(.horizontal)
                        .fadeIn(delay: 0.05)

                    // MARK: - Registered polyclinic
                    sectionHeader("Qeydiyyat poliklinikası")
                    registeredClinicCard
                        .padding(.horizontal)
                        .fadeIn(delay: 0.1)

                    // MARK: - Covered services
                    sectionHeader("Sığorta ilə ödənilən xidmətlər")
                    coveredServicesCard
                        .padding(.horizontal)
                        .fadeIn(delay: 0.15)

                    // MARK: - Logout
                    Button {
                        withAnimation(.spring(response: 0.4)) { auth.resetOnboarding() }
                    } label: {
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
                    .padding(.top, 4)
                    .fadeIn(delay: 0.3)
                }
                .padding(.bottom, 24)
            }
            .background(Color.sectionBackground)
            .navigationTitle("Əlavə")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    // MARK: - Section header

    private func sectionHeader(_ title: String) -> some View {
        Text(title)
            .font(.subheadline)
            .fontWeight(.semibold)
            .foregroundColor(Color(.secondaryLabel))
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)
            .padding(.top, 4)
    }

    // MARK: - Appearance picker

    private var appearancePicker: some View {
        HStack(spacing: 0) {
            ForEach([AppearanceMode.system, .light, .dark], id: \.rawValue) { mode in
                Button {
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                        auth.appearanceMode = mode
                    }
                } label: {
                    VStack(spacing: 4) {
                        Image(systemName: mode.icon).font(.body)
                        Text(mode.label).font(.caption)
                    }
                    .foregroundColor(auth.appearanceMode == mode ? .white : Color(.label))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(auth.appearanceMode == mode ? Color.appBlue : Color.clear)
                    .cornerRadius(12)
                }
            }
        }
        .padding(4)
        .background(Color(.tertiarySystemFill))
        .cornerRadius(14)
    }

    // MARK: - Registered clinic card

    private var registeredClinicCard: some View {
        VStack(spacing: 0) {
            HStack(spacing: 14) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.appBlue.opacity(0.1))
                        .frame(width: 44, height: 44)
                    Image(systemName: "building.2.fill")
                        .foregroundColor(.appBlue)
                }

                VStack(alignment: .leading, spacing: 3) {
                    Text("Qeydiyyatda olduğum poliklinika")
                        .font(.caption)
                        .foregroundColor(Color(.secondaryLabel))
                    Text(auth.registeredClinicName.isEmpty ? "Seçilməyib" : auth.registeredClinicName)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(auth.registeredClinicName.isEmpty ? Color(.tertiaryLabel) : Color(.label))
                        .lineLimit(1)
                }

                Spacer()

                NavigationLink(destination: ClinicRegistrationPickerView()) {
                    Text(auth.registeredClinicName.isEmpty ? "Seç" : "Dəyiş")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.appBlue)
                        .clipShape(Capsule())
                }
            }
            .padding(14)
        }
        .background(Color.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }

    // MARK: - Covered services card

    private var coveredServicesCard: some View {
        VStack(spacing: 0) {
            ForEach(Array(coveredServices.enumerated()), id: \.offset) { index, item in
                HStack(spacing: 14) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(item.color.opacity(0.12))
                            .frame(width: 38, height: 38)
                        Image(systemName: item.icon)
                            .font(.subheadline)
                            .foregroundColor(item.color)
                    }
                    VStack(alignment: .leading, spacing: 2) {
                        Text(item.title)
                            .font(.subheadline)
                            .foregroundColor(Color(.label))
                        Text(item.detail)
                            .font(.caption)
                            .foregroundColor(Color(.secondaryLabel))
                    }
                    Spacer()
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                        .font(.subheadline)
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 11)
                .fadeIn(delay: 0.15 + Double(index) * 0.04)

                if index < coveredServices.count - 1 {
                    Divider().padding(.leading, 66)
                }
            }
        }
        .background(Color.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }

    private var coveredServices: [(title: String, detail: String, icon: String, color: Color)] {
        [
            ("Ailə həkimi", "İlkin müayinə və yönləndirmə", "person.fill.checkmark", .appBlue),
            ("Ambulatoriya müayinəsi", "Mütəxəssis həkim qəbulları", "stethoscope", Color(red: 0.6, green: 0.5, blue: 0.95)),
            ("Laboratoriya analizləri", "200-dən çox analiz növü", "testtube.2", Color(red: 0.3, green: 0.7, blue: 0.4)),
            ("Diaqnostika", "Rentgen, USM, EKQ", "waveform.path.ecg.rectangle.fill", Color(red: 0.5, green: 0.62, blue: 0.78)),
            ("Cərrahiyyə", "1100-dən çox əməliyyat", "cross.case.fill", .red),
            ("Hamiləlik və doğuş", "Tam müşayiət", "heart.fill", Color(red: 0.9, green: 0.4, blue: 0.6)),
            ("Təcili tibbi yardım", "103 xidməti", "cross.vial.fill", .orange),
        ]
    }
}

// MARK: - Clinic registration picker

struct ClinicRegistrationPickerView: View {
    @Environment(AuthManager.self) private var auth
    @Environment(LocationManager.self) private var locationManager
    @Environment(ClinicViewModel.self) private var clinicVM
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 10) {
                if clinicVM.isLoading {
                    ProgressView("Poliklinikalar axtarılır...").padding(40)
                } else {
                    ForEach(Array(clinicVM.clinics.enumerated()), id: \.element.id) { index, clinic in
                        Button {
                            auth.registeredClinicName = clinic.name
                            dismiss()
                        } label: {
                            HStack {
                                ClinicListRow(clinic: clinic)
                                if auth.registeredClinicName == clinic.name {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.appBlue)
                                        .padding(.trailing, 12)
                                }
                            }
                        }
                        .fadeIn(delay: Double(index) * 0.05)
                    }
                }
            }
            .padding()
        }
        .background(Color.sectionBackground)
        .navigationTitle("Poliklinika seçin")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            locationManager.requestPermission()
            await clinicVM.loadIfNeeded(locationManager: locationManager)
        }
    }
}

#Preview {
    MoreView()
        .environment(AuthManager())
        .environment(LocationManager())
        .environment(ClinicViewModel())
}
