import SwiftUI
import MapKit

// MARK: - Clinic Detail

struct ClinicDetailView: View {
    let clinic: Clinic
    @Environment(LocationManager.self) private var locationManager

    private var specialties: [String] {
        var seen = Set<String>()
        return clinic.doctors.compactMap { doc in
            seen.insert(doc.specialty).inserted ? doc.specialty : nil
        }
    }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 20) {
                mapPreview
                infoCard
                specialtyList
            }
            .padding(.vertical)
        }
        .navigationTitle(clinic.name)
        .navigationBarTitleDisplayMode(.inline)
        .background(Color.sectionBackground)
    }

    private var mapPreview: some View {
        Map {
            Annotation(clinic.name, coordinate: CLLocationCoordinate2D(
                latitude: clinic.latitude, longitude: clinic.longitude)) {
                ZStack {
                    Circle().fill(Color.appBlue).frame(width: 36, height: 36)
                        .shadow(color: .appBlue.opacity(0.4), radius: 4, y: 2)
                    Image(systemName: "cross.fill")
                        .font(.system(size: 14, weight: .bold)).foregroundColor(.white)
                }
            }
        }
        .frame(height: 180)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .padding(.horizontal)
    }

    private var infoCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    if let rating = clinic.rating {
                        HStack(spacing: 4) {
                            Image(systemName: "star.fill").foregroundColor(.orange).font(.subheadline)
                            Text(String(format: "%.1f", rating)).font(.subheadline).fontWeight(.semibold)
                        }
                    }
                    if let isOpen = clinic.isOpen {
                        Text(isOpen ? "Açıqdır" : "Bağlıdır")
                            .font(.caption)
                            .foregroundColor(isOpen ? .green : .red)
                            .padding(.horizontal, 8).padding(.vertical, 3)
                            .background((isOpen ? Color.green : Color.red).opacity(0.12))
                            .clipShape(Capsule())
                    }
                }
                Spacer()
                if let dist = locationManager.distanceTo(lat: clinic.latitude, lng: clinic.longitude) {
                    VStack(alignment: .trailing, spacing: 2) {
                        Image(systemName: "location.fill").foregroundColor(.appBlue).font(.subheadline)
                        Text(dist).font(.subheadline).fontWeight(.semibold).foregroundColor(.appBlue)
                    }
                }
            }
            Divider()
            Label(clinic.address, systemImage: "mappin.and.ellipse")
                .font(.subheadline).foregroundColor(Color(.secondaryLabel))
            if let phone = clinic.phoneNumber {
                Label(phone, systemImage: "phone.fill")
                    .font(.subheadline).foregroundColor(.appBlue)
            }
        }
        .padding()
        .background(Color.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .padding(.horizontal)
    }

    private var specialtyList: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Xidmət növünü seçin")
                .font(.headline)
                .padding(.horizontal)

            ForEach(specialties, id: \.self) { specialty in
                let doctors = clinic.doctors.filter { $0.specialty == specialty }
                NavigationLink(destination: SpecialtyDoctorsView(
                    specialty: specialty, doctors: doctors)) {
                    SpecialtyRow(specialty: specialty, doctorCount: doctors.count)
                }
                .padding(.horizontal)
            }
        }
    }
}

// MARK: - Specialty Row

struct SpecialtyRow: View {
    let specialty: String
    let doctorCount: Int

    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.appBlue.opacity(0.12))
                    .frame(width: 48, height: 48)
                Image(systemName: icon(for: specialty))
                    .font(.title3).foregroundColor(.appBlue)
            }
            VStack(alignment: .leading, spacing: 3) {
                Text(specialty).font(.subheadline).fontWeight(.semibold).foregroundColor(Color(.label))
                Text("\(doctorCount) həkim mövcuddur").font(.caption).foregroundColor(Color(.secondaryLabel))
            }
            Spacer()
            Image(systemName: "chevron.right").font(.caption).foregroundColor(Color(.tertiaryLabel))
        }
        .padding(14)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private func icon(for specialty: String) -> String {
        let s = specialty.lowercased()
        if s.contains("kardio")  { return "heart.fill" }
        if s.contains("nevro")   { return "brain.head.profile" }
        if s.contains("pediatr") { return "figure.and.child.holdinghands" }
        if s.contains("stomato") { return "mouth.fill" }
        if s.contains("cərrah")  { return "scalpel" }
        if s.contains("oftolmo") || s.contains("göz") { return "eye.fill" }
        return "stethoscope"
    }
}

// MARK: - Specialty Doctors

struct SpecialtyDoctorsView: View {
    let specialty: String
    let doctors: [Doctor]

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 12) {
                ForEach(Array(doctors.enumerated()), id: \.element.id) { index, doctor in
                    NavigationLink(destination: DoctorTimeSlotsView(doctor: doctor)) {
                        DoctorCard(doctor: doctor)
                    }
                    .fadeIn(delay: Double(index) * 0.06)
                }
            }
            .padding()
        }
        .background(Color.sectionBackground)
        .navigationTitle(specialty)
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Doctor Card

struct DoctorCard: View {
    let doctor: Doctor

    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                Circle().fill(Color.appBlue.opacity(0.12)).frame(width: 56, height: 56)
                Image(systemName: "person.fill").font(.title2).foregroundColor(.appBlue)
            }
            VStack(alignment: .leading, spacing: 4) {
                Text(doctor.name).font(.subheadline).fontWeight(.semibold).foregroundColor(Color(.label))
                Text(doctor.specialty).font(.caption).foregroundColor(Color(.secondaryLabel))
                HStack(spacing: 10) {
                    HStack(spacing: 3) {
                        Image(systemName: "star.fill").font(.caption2).foregroundColor(.orange)
                        Text(String(format: "%.1f", doctor.rating)).font(.caption).foregroundColor(Color(.secondaryLabel))
                    }
                    HStack(spacing: 3) {
                        Image(systemName: "clock.fill").font(.caption2).foregroundColor(.appBlue)
                        Text(doctor.experience).font(.caption).foregroundColor(Color(.secondaryLabel))
                    }
                    HStack(spacing: 3) {
                        Image(systemName: "calendar.badge.checkmark").font(.caption2).foregroundColor(.green)
                        Text("\(doctor.availableSlots.count) vaxt").font(.caption).foregroundColor(Color(.secondaryLabel))
                    }
                }
            }
            Spacer()
            Image(systemName: "chevron.right").font(.caption).foregroundColor(Color(.tertiaryLabel))
        }
        .padding(14)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }
}
