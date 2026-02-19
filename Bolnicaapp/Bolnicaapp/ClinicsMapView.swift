import SwiftUI
import MapKit

struct ClinicsMapView: View {
    @Environment(LocationManager.self) private var locationManager
    @Environment(ClinicViewModel.self) private var clinicVM
    @State private var selectedClinic: Clinic?
    @State private var showList = true
    @State private var cameraPosition: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 40.4093, longitude: 49.8671),
            span: MKCoordinateSpan(latitudeDelta: 0.06, longitudeDelta: 0.06)
        )
    )

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                Map(position: $cameraPosition) {
                    UserAnnotation()
                    ForEach(clinicVM.clinics) { clinic in
                        Annotation(clinic.name, coordinate: CLLocationCoordinate2D(
                            latitude: clinic.latitude, longitude: clinic.longitude)) {
                            Button { selectedClinic = clinic } label: {
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

                if showList {
                    clinicListSheet
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Text("Poliklinikalar").font(.headline)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        withAnimation(.spring(response: 0.35)) { showList.toggle() }
                    } label: {
                        Image(systemName: showList ? "map.fill" : "list.bullet")
                            .foregroundColor(.appBlue)
                    }
                }
            }
            .navigationDestination(item: $selectedClinic) { clinic in
                ClinicDetailView(clinic: clinic)
            }
            .task {
                locationManager.requestPermission()
                await clinicVM.loadIfNeeded(locationManager: locationManager)
                if let first = clinicVM.clinics.first {
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

    private var clinicListSheet: some View {
        VStack(spacing: 0) {
            Capsule()
                .fill(Color(.tertiaryLabel))
                .frame(width: 36, height: 4)
                .padding(.top, 8)
                .padding(.bottom, 12)

            if clinicVM.isLoading {
                ProgressView("Poliklinikalar axtarılır...").padding(40)
            } else {
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 8) {
                        ForEach(Array(clinicVM.clinics.enumerated()), id: \.element.id) { index, clinic in
                            Button { selectedClinic = clinic } label: {
                                ClinicListRow(clinic: clinic)
                            }
                            .fadeIn(delay: Double(index) * 0.05)
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
}

#Preview {
    ClinicsMapView()
        .environment(LocationManager())
        .environment(ClinicViewModel())
}
