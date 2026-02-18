import SwiftUI
import MapKit

struct ClinicsMapView: View {
    @State private var locationManager = LocationManager()
    @State private var clinics: [Clinic] = []
    @State private var isLoading = true
    @State private var selectedClinic: Clinic?
    @State private var showList = true
    @State private var appeared = false
    @State private var cameraPosition: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 40.4093, longitude: 49.8671),
            span: MKCoordinateSpan(latitudeDelta: 0.06, longitudeDelta: 0.06)
        )
    )

    private let service = ClinicService()

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                // Map
                Map(position: $cameraPosition) {
                    // User location
                    UserAnnotation()

                    // Clinic markers
                    ForEach(clinics) { clinic in
                        Annotation(clinic.name, coordinate: CLLocationCoordinate2D(latitude: clinic.latitude, longitude: clinic.longitude)) {
                            Button(action: { selectedClinic = clinic }) {
                                ZStack {
                                    Circle()
                                        .fill(Color.appBlue)
                                        .frame(width: 36, height: 36)
                                        .shadow(color: .appBlue.opacity(0.4), radius: 4, y: 2)
                                    Image(systemName: "cross.fill")
                                        .font(.system(size: 14, weight: .bold))
                                        .foregroundColor(.white)
                                }
                            }
                        }
                    }
                }
                .mapControls {
                    MapUserLocationButton()
                    MapCompass()
                }

                // Bottom sheet — clinic list
                if showList {
                    clinicListSheet
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Text("Poliklinikalar")
                        .font(.headline)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        withAnimation(.spring(response: 0.35)) {
                            showList.toggle()
                        }
                    }) {
                        Image(systemName: showList ? "map.fill" : "list.bullet")
                            .foregroundColor(.appBlue)
                    }
                }
            }
            .navigationDestination(item: $selectedClinic) { clinic in
                ClinicDetailView(clinic: clinic, locationManager: locationManager)
            }
            .onAppear {
                locationManager.requestPermission()
                loadClinics()
                withAnimation(.spring(response: 0.5).delay(0.2)) {
                    appeared = true
                }
            }
        }
    }

    private var clinicListSheet: some View {
        VStack(spacing: 0) {
            // Handle
            Capsule()
                .fill(Color(.tertiaryLabel))
                .frame(width: 36, height: 4)
                .padding(.top, 8)
                .padding(.bottom, 12)

            if isLoading {
                ProgressView("Poliklinikalar axtarılır...")
                    .padding(40)
            } else {
                ScrollView {
                    VStack(spacing: 8) {
                        ForEach(Array(clinics.enumerated()), id: \.element.id) { index, clinic in
                            Button(action: { selectedClinic = clinic }) {
                                ClinicRow(clinic: clinic, locationManager: locationManager)
                            }
                            .opacity(appeared ? 1 : 0)
                            .offset(y: appeared ? 0 : 15)
                            .animation(
                                .spring(response: 0.4, dampingFraction: 0.8)
                                .delay(Double(index) * 0.05),
                                value: appeared
                            )
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 16)
                }
            }
        }
        .frame(maxHeight: 340)
        .background(Color.cardBackground)
        .cornerRadius(24)
        .shadow(color: .black.opacity(0.1), radius: 12, y: -4)
        .padding(.horizontal, 8)
        .padding(.bottom, 4)
    }

    private func loadClinics() {
        Task {
            let lat = locationManager.userLocation?.latitude ?? 40.4093
            let lng = locationManager.userLocation?.longitude ?? 49.8671
            let results = await service.fetchNearbyClinics(latitude: lat, longitude: lng)
            withAnimation {
                clinics = results
                isLoading = false
            }
            if let first = results.first {
                withAnimation {
                    cameraPosition = .region(MKCoordinateRegion(
                        center: CLLocationCoordinate2D(latitude: first.latitude, longitude: first.longitude),
                        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                    ))
                }
            }
        }
    }
}

struct ClinicRow: View {
    let clinic: Clinic
    let locationManager: LocationManager

    var body: some View {
        HStack(spacing: 12) {
            // Icon
            ZStack {
                RoundedRectangle(cornerRadius: 14)
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
                            Image(systemName: "star.fill")
                                .font(.caption2)
                                .foregroundColor(.orange)
                            Text(String(format: "%.1f", rating))
                                .font(.caption)
                                .foregroundColor(Color(.secondaryLabel))
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

            // Distance
            VStack(alignment: .trailing, spacing: 2) {
                if let dist = locationManager.distanceTo(lat: clinic.latitude, lng: clinic.longitude) {
                    Text(dist)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.appBlue)
                }
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(Color(.tertiaryLabel))
            }
        }
        .padding(12)
        .background(Color(.systemBackground))
        .cornerRadius(16)
    }
}

#Preview {
    ClinicsMapView()
}
