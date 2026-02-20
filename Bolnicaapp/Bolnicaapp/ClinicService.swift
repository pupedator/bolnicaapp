import Foundation
import CoreLocation

struct Clinic: Identifiable, Equatable, Hashable {
    let id: String
    let name: String
    let address: String
    let latitude: Double
    let longitude: Double
    let rating: Double?
    let isOpen: Bool?
    let phoneNumber: String?
    let doctors: [Doctor]

    static func == (lhs: Clinic, rhs: Clinic) -> Bool { lhs.id == rhs.id }
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
}

struct Doctor: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let specialty: String
    let rating: Double
    let experience: String
    let availableSlots: [String]
}

class ClinicService {
    private let apiKey = Secrets.googlePlacesAPIKey

    func fetchNearbyClinics(latitude: Double, longitude: Double) async -> [Clinic] {
        let urlString = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(latitude),\(longitude)&radius=5000&type=hospital&keyword=poliklinika|klinika|xəstəxana&language=az&key=\(apiKey)"

        guard let url = URL(string: urlString) else { return sampleClinics }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
            guard let results = json?["results"] as? [[String: Any]] else { return sampleClinics }

            var clinics: [Clinic] = []
            for result in results.prefix(15) {
                guard let name = result["name"] as? String,
                      let placeId = result["place_id"] as? String,
                      let geometry = result["geometry"] as? [String: Any],
                      let location = geometry["location"] as? [String: Any],
                      let lat = location["lat"] as? Double,
                      let lng = location["lng"] as? Double
                else { continue }

                let address = result["vicinity"] as? String ?? ""
                let rating = result["rating"] as? Double
                let openingHours = result["opening_hours"] as? [String: Any]
                let isOpen = openingHours?["open_now"] as? Bool

                let clinic = Clinic(
                    id: placeId,
                    name: name,
                    address: address,
                    latitude: lat,
                    longitude: lng,
                    rating: rating,
                    isOpen: isOpen,
                    phoneNumber: nil,
                    doctors: Self.generateDoctors(for: name)
                )
                clinics.append(clinic)
            }

            return clinics.isEmpty ? sampleClinics : clinics
        } catch {
            return sampleClinics
        }
    }

    // Sample clinics in Baku as fallback
    var sampleClinics: [Clinic] {
        [
            Clinic(id: "1", name: "Mərkəzi Poliklinika №1", address: "Nizami küç. 45, Bakı", latitude: 40.4093, longitude: 49.8671, rating: 4.2, isOpen: true, phoneNumber: "+994 12 493 0001", doctors: Self.generateDoctors(for: "Mərkəzi Poliklinika №1")),
            Clinic(id: "2", name: "Şəhər Poliklinikası №5", address: "Həsən Əliyev küç. 12, Bakı", latitude: 40.4178, longitude: 49.8525, rating: 4.0, isOpen: true, phoneNumber: "+994 12 431 0505", doctors: Self.generateDoctors(for: "Şəhər Poliklinikası №5")),
            Clinic(id: "3", name: "Respublika Klinik Xəstəxanası", address: "Yasamal r., M.Mirqasımov küç. 1", latitude: 40.3985, longitude: 49.8352, rating: 4.5, isOpen: true, phoneNumber: "+994 12 595 3700", doctors: Self.generateDoctors(for: "Respublika")),
            Clinic(id: "4", name: "MedEra Hospital", address: "8 Noyabr prospekti, Bakı", latitude: 40.4219, longitude: 49.8098, rating: 4.7, isOpen: true, phoneNumber: "+994 12 910 0000", doctors: Self.generateDoctors(for: "MedEra")),
            Clinic(id: "5", name: "Baku Medical Plaza", address: "Tbilisi prospekti 55, Bakı", latitude: 40.4033, longitude: 49.8765, rating: 4.3, isOpen: false, phoneNumber: "+994 12 310 1010", doctors: Self.generateDoctors(for: "BMP")),
            Clinic(id: "6", name: "Nərimanov Rayon Poliklinikası", address: "Təbriz küç. 89, Bakı", latitude: 40.4122, longitude: 49.8445, rating: 3.8, isOpen: true, phoneNumber: "+994 12 440 2233", doctors: Self.generateDoctors(for: "Nərimanov")),
        ]
    }

    static func generateDoctors(for clinicName: String) -> [Doctor] {
        [
            Doctor(name: "Məmmədova Aynur", specialty: "Ümumi təcrübə həkimi", rating: 4.8, experience: "12 il", availableSlots: ["09:00","09:30","10:00","10:30","11:00","14:00","14:30","15:00"]),
            Doctor(name: "Həsənov Murad", specialty: "Terapevt", rating: 4.6, experience: "8 il", availableSlots: ["08:30","09:00","09:30","11:00","11:30","13:00","16:00","16:30"]),
            Doctor(name: "Əliyeva Leyla", specialty: "Kardioloq", rating: 4.9, experience: "15 il", availableSlots: ["10:00","10:30","11:00","14:00","14:30","15:00","15:30"]),
            Doctor(name: "Quliyev Rəşad", specialty: "Nevroloq", rating: 4.5, experience: "10 il", availableSlots: ["08:00","08:30","09:00","12:00","12:30","13:00","17:00"]),
            Doctor(name: "İsmayılova Nərmin", specialty: "Pediatr", rating: 4.7, experience: "6 il", availableSlots: ["09:00","09:15","09:30","10:00","11:00","14:00","15:00","16:00"]),
        ]
    }
}
