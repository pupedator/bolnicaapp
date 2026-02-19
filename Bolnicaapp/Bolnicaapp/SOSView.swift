import SwiftUI
import CoreLocation

struct SOSView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(LocationManager.self) private var locationManager
    @State private var confirmingNumber: EmergencyContact? = nil
    @State private var pulse = false

    let contacts = EmergencyContact.all

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Top SOS badge
                VStack(spacing: 16) {
                    ZStack {
                        Circle()
                            .fill(Color.red.opacity(0.15))
                            .frame(width: 120, height: 120)
                            .scaleEffect(pulse ? 1.2 : 1.0)
                            .animation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true), value: pulse)
                        Circle()
                            .fill(Color.red.opacity(0.25))
                            .frame(width: 90, height: 90)
                        Circle()
                            .fill(Color.red)
                            .frame(width: 68, height: 68)
                        Text("SOS")
                            .font(.system(size: 22, weight: .black))
                            .foregroundColor(.white)
                    }
                    .padding(.top, 32)

                    Text("Təcili yardım")
                        .font(.title2)
                        .fontWeight(.bold)
                    Text("Zəng etmək üçün nömrəni seçin")
                        .font(.subheadline)
                        .foregroundColor(Color(.secondaryLabel))
                }
                .frame(maxWidth: .infinity)
                .padding(.bottom, 32)

                // Location pill
                locationPill
                    .padding(.horizontal)
                    .padding(.bottom, 28)

                // Emergency number buttons
                VStack(spacing: 14) {
                    ForEach(contacts) { contact in
                        EmergencyButton(contact: contact) {
                            confirmingNumber = contact
                        }
                        .padding(.horizontal)
                    }
                }

                Spacer()

                Button("Bağla") { dismiss() }
                    .font(.subheadline)
                    .foregroundColor(Color(.secondaryLabel))
                    .padding(.bottom, 32)
            }
            .background(Color(.systemBackground))
            .navigationBarHidden(true)
            .onAppear { pulse = true }
            .confirmationDialog(
                confirmingNumber.map { "Zəng: \($0.number)" } ?? "",
                isPresented: Binding(
                    get: { confirmingNumber != nil },
                    set: { if !$0 { confirmingNumber = nil } }
                ),
                titleVisibility: .visible
            ) {
                if let contact = confirmingNumber {
                    Button("Zəng et \(contact.number)", role: .destructive) {
                        call(contact.number)
                    }
                    Button("Ləğv et", role: .cancel) { confirmingNumber = nil }
                }
            } message: {
                if let contact = confirmingNumber {
                    Text("\(contact.label) – \(contact.number)")
                }
            }
        }
    }

    // MARK: - Location pill

    private var locationPill: some View {
        HStack(spacing: 8) {
            Image(systemName: "location.fill")
                .font(.caption)
                .foregroundColor(.appBlue)
            if let loc = locationManager.userLocation {
                Text(String(format: "%.5f, %.5f", loc.latitude, loc.longitude))
                    .font(.caption)
                    .foregroundColor(Color(.secondaryLabel))
            } else {
                Text("Yer məlumatı əldə edilir...")
                    .font(.caption)
                    .foregroundColor(Color(.secondaryLabel))
            }
            Spacer()
            Image(systemName: "doc.on.doc")
                .font(.caption)
                .foregroundColor(.appBlue)
                .onTapGesture {
                    if let loc = locationManager.userLocation {
                        UIPasteboard.general.string = "\(loc.latitude), \(loc.longitude)"
                    }
                }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        .background(Color.appBlue.opacity(0.08))
        .clipShape(Capsule())
    }

    private func call(_ number: String) {
        guard let url = URL(string: "tel://\(number)") else { return }
        UIApplication.shared.open(url)
    }
}

// MARK: - Emergency Button

struct EmergencyButton: View {
    let contact: EmergencyContact
    let action: () -> Void
    @State private var pressed = false

    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(contact.color.opacity(0.15))
                        .frame(width: 52, height: 52)
                    Image(systemName: contact.icon)
                        .font(.title3)
                        .foregroundColor(contact.color)
                }

                VStack(alignment: .leading, spacing: 3) {
                    Text(contact.label)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(Color(.label))
                    Text(contact.description)
                        .font(.caption)
                        .foregroundColor(Color(.secondaryLabel))
                }

                Spacer()

                Text(contact.number)
                    .font(.title2)
                    .fontWeight(.black)
                    .foregroundColor(contact.color)
            }
            .padding(16)
            .background(contact.color.opacity(0.07))
            .clipShape(RoundedRectangle(cornerRadius: 18))
            .overlay(
                RoundedRectangle(cornerRadius: 18)
                    .stroke(contact.color.opacity(0.25), lineWidth: 1)
            )
        }
        .scaleEffect(pressed ? 0.97 : 1)
        .animation(.spring(response: 0.25), value: pressed)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in pressed = true }
                .onEnded { _ in pressed = false }
        )
    }
}

// MARK: - Model

struct EmergencyContact: Identifiable {
    let id = UUID()
    let label: String
    let description: String
    let number: String
    let icon: String
    let color: Color

    static let all: [EmergencyContact] = [
        .init(label: "Təcili tibbi yardım",
              description: "Ambulans çağırın",
              number: "103",
              icon: "cross.case.fill",
              color: .red),
        .init(label: "Polis",
              description: "Polis xidməti",
              number: "102",
              icon: "shield.fill",
              color: Color(red: 0.2, green: 0.4, blue: 0.8)),
        .init(label: "Vahid xilasedici xidmət",
              description: "Yanğın, qaz, həyat təhlükəsi",
              number: "112",
              icon: "flame.fill",
              color: .orange),
        .init(label: "Qaz xidməti",
              description: "Qaz sızması",
              number: "104",
              icon: "wind",
              color: Color(red: 0.3, green: 0.7, blue: 0.4)),
    ]
}

#Preview {
    SOSView()
        .environment(LocationManager())
}
