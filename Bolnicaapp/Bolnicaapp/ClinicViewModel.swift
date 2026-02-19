import SwiftUI
import CoreLocation

// MARK: - Shared clinic state (single instance injected via environment)

@Observable
final class ClinicViewModel {
    private(set) var clinics: [Clinic] = []
    private(set) var isLoading = false
    private var hasLoaded = false
    private let service = ClinicService()

    @MainActor
    func loadIfNeeded(locationManager: LocationManager) async {
        guard !hasLoaded else { return }
        hasLoaded = true
        isLoading = true
        let lat = locationManager.userLocation?.latitude ?? 40.4093
        let lng = locationManager.userLocation?.longitude ?? 49.8671
        let results = await service.fetchNearbyClinics(latitude: lat, longitude: lng)
        withAnimation {
            clinics = results
            isLoading = false
        }
    }
}

// MARK: - Unified clinic list row (used by ClinicsMapView & ClinicPickerView)

struct ClinicListRow: View {
    let clinic: Clinic
    @Environment(LocationManager.self) private var locationManager

    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.appBlue.opacity(0.1))
                    .frame(width: 48, height: 48)
                Image(systemName: "building.2.fill")
                    .font(.title3)
                    .foregroundColor(.appBlue)
            }

            VStack(alignment: .leading, spacing: 3) {
                Text(clinic.name)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(Color(.label))
                    .lineLimit(1)
                Text(clinic.address)
                    .font(.caption)
                    .foregroundColor(Color(.secondaryLabel))
                    .lineLimit(1)

                HStack(spacing: 8) {
                    if let rating = clinic.rating {
                        HStack(spacing: 2) {
                            Image(systemName: "star.fill").font(.caption2).foregroundColor(.orange)
                            Text(String(format: "%.1f", rating)).font(.caption).foregroundColor(Color(.secondaryLabel))
                        }
                    }
                    if let isOpen = clinic.isOpen {
                        Text(isOpen ? "Açıqdır" : "Bağlıdır")
                            .font(.caption)
                            .foregroundColor(isOpen ? .green : .red)
                    }
                }
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 2) {
                if let dist = locationManager.distanceTo(lat: clinic.latitude, lng: clinic.longitude) {
                    Text(dist).font(.caption).fontWeight(.semibold).foregroundColor(.appBlue)
                }
                Image(systemName: "chevron.right").font(.caption).foregroundColor(Color(.tertiaryLabel))
            }
        }
        .padding(12)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}
