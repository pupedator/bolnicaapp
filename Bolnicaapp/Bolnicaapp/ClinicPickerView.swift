import SwiftUI

struct ClinicPickerView: View {
    @Environment(LocationManager.self) private var locationManager
    @Environment(ClinicViewModel.self) private var clinicVM

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 10) {
                if clinicVM.isLoading {
                    ProgressView("Poliklinikalar axtarılır...").padding(40)
                } else {
                    ForEach(Array(clinicVM.clinics.enumerated()), id: \.element.id) { index, clinic in
                        NavigationLink(destination: ClinicDetailView(clinic: clinic)) {
                            ClinicListRow(clinic: clinic)
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
