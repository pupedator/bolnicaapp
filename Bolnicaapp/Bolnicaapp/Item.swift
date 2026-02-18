import Foundation

// MARK: - Appointment Categories (Home screen horizontal cards)

struct AppointmentCategory: Identifiable {
    let id = UUID()
    let title: String
    let icon: String
}

// MARK: - Document Records (Medical Card)

struct DocumentRecord: Identifiable {
    let id = UUID()
    let title: String
    let icon: String
    let count: Int?
}

// MARK: - Insurance Policies (More tab)

struct InsurancePolicy: Identifiable {
    let id = UUID()
    let name: String
    let initials: String
    let policyNumber: String
    let hasAccess: Bool
}

// MARK: - Doctor Time Slots

struct DayOption: Identifiable {
    let id = UUID()
    let dayOfWeek: String
    let dayNumber: Int
    let isAvailable: Bool
}

struct TimeSlot: Identifiable {
    let id = UUID()
    let time: String
}

// MARK: - Appointment Goals

struct AppointmentGoal: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String?
    let icon: String
}

// MARK: - Sample Data (Azerbaijani)

enum SampleData {
    static let appointmentCategories: [AppointmentCategory] = [
        .init(title: "Soyuqdəymə\nəlamətləri", icon: "thermometer.medium"),
        .init(title: "Ağrı, pis\nözünühiss", icon: "bolt.fill"),
        .init(title: "Planlı qəbul\nşikayətsiz", icon: "clipboard"),
        .init(title: "Sənədlərin\nrəsmiləşdirilməsi", icon: "doc.badge.plus"),
        .init(title: "Resept\nyazılması", icon: "pills"),
        .init(title: "Stomatoloqa\nqeydiyyat", icon: "mouth"),
    ]

    static let documents: [DocumentRecord] = [
        .init(title: "COVID-19 testləri", icon: "testtube.2", count: 3),
        .init(title: "Qəbullar", icon: "stethoscope", count: 14),
        .init(title: "Analizlər", icon: "drop.triangle", count: 3),
        .init(title: "Tədqiqatlar", icon: "waveform.path.ecg", count: 15),
        .init(title: "Hospitalizasiyalar", icon: "building.2", count: 5),
        .init(title: "Stasionardan çıxarışlar", icon: "doc.plaintext", count: 5),
        .init(title: "Təcili yardım çağırışları", icon: "cross.case", count: 2),
        .init(title: "Həkim konsultasiyaları", icon: "person.2", count: 1),
        .init(title: "Arayışlar", icon: "doc.badge.plus", count: 6),
        .init(title: "Reseptlər", icon: "pills", count: 1),
        .init(title: "Vaksinasiya", icon: "syringe", count: nil),
        .init(title: "Xəstəlik vərəqələri", icon: "bed.double", count: 3),
    ]

    static let policies: [InsurancePolicy] = [
        .init(name: "Mənim polisim", initials: "MP", policyNumber: "7700 •••• •••• 0383", hasAccess: true),
        .init(name: "Aynur", initials: "A", policyNumber: "7705 •••• •••• 0698", hasAccess: false),
        .init(name: "Rəşad", initials: "R", policyNumber: "7708 •••• •••• 0220", hasAccess: true),
        .init(name: "Nənə", initials: "N", policyNumber: "7700 •••• •••• 1212", hasAccess: false),
        .init(name: "Baba", initials: "B", policyNumber: "7700 •••• •••• 2355", hasAccess: false),
    ]

    static let days: [DayOption] = [
        .init(dayOfWeek: "Cş", dayNumber: 22, isAvailable: true),
        .init(dayOfWeek: "C", dayNumber: 23, isAvailable: true),
        .init(dayOfWeek: "Şn", dayNumber: 24, isAvailable: false),
        .init(dayOfWeek: "B", dayNumber: 25, isAvailable: false),
        .init(dayOfWeek: "BE", dayNumber: 26, isAvailable: true),
        .init(dayOfWeek: "ÇA", dayNumber: 27, isAvailable: true),
        .init(dayOfWeek: "Ç", dayNumber: 1, isAvailable: false),
        .init(dayOfWeek: "Cş", dayNumber: 2, isAvailable: true),
        .init(dayOfWeek: "C", dayNumber: 3, isAvailable: true),
        .init(dayOfWeek: "Şn", dayNumber: 4, isAvailable: true),
        .init(dayOfWeek: "B", dayNumber: 5, isAvailable: false),
    ]

    static let morningSlots: [TimeSlot] = [
        "08:00", "08:15", "08:30", "09:00", "09:15", "09:45",
        "10:00", "10:15", "10:30", "10:45", "11:00", "11:30",
        "11:45", "12:00",
    ].map { TimeSlot(time: $0) }

    static let afternoonSlots: [TimeSlot] = [
        "12:15", "12:30", "12:45", "13:00", "13:15", "13:30",
        "13:45", "14:00", "14:30", "14:45", "15:30", "16:00",
        "16:15", "16:30", "16:45", "17:00",
    ].map { TimeSlot(time: $0) }

    static let eveningSlots: [TimeSlot] = [
        "17:15", "17:30", "17:45", "18:00", "18:15", "18:30",
        "18:45", "19:00", "19:45", "20:00",
    ].map { TimeSlot(time: $0) }

    static let appointmentGoals: [AppointmentGoal] = [
        .init(title: "Soyuqdəymə əlamətləri", subtitle: nil, icon: "thermometer.medium"),
        .init(title: "Pis özünühiss və ya ağrı", subtitle: "O cümlədən xroniki xəstəliyin kəskinləşməsi və ya diaqnostika prosesində təkrar qəbul", icon: "bolt.fill"),
        .init(title: "Planlı dispanser qəbulu şikayətsiz", subtitle: nil, icon: "clipboard"),
        .init(title: "Resept yazılması", subtitle: "Dərmanlar və tibbi məhsullar üçün", icon: "pills"),
        .init(title: "Dispanserizasiya", subtitle: nil, icon: "stethoscope"),
        .init(title: "Sənədlərin rəsmiləşdirilməsi", subtitle: "Arayışlar, tibbi-sosial ekspertiza və s.", icon: "doc.badge.plus"),
        .init(title: "Silah / sürücülük arayışı üçün qeydiyyat", subtitle: nil, icon: "doc.text.magnifyingglass"),
        .init(title: "Vaksinasiya", subtitle: nil, icon: "syringe"),
        .init(title: "Uşağa baxım üzrə konsultasiya", subtitle: nil, icon: "figure.and.child.holdinghands"),
    ]
}
