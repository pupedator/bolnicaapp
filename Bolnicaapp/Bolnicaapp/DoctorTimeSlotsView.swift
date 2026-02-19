import SwiftUI

struct DoctorTimeSlotsView: View {
    var doctor: Doctor? = nil
    @State private var selectedDayIndex = 0
    @State private var selectedSlot: String? = nil
    @State private var appeared = false

    let columns = Array(repeating: GridItem(.flexible(), spacing: 8), count: 6)

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // MARK: - Date picker
                VStack(alignment: .leading, spacing: 12) {
                    // Month labels
                    HStack {
                        Text("Dekabr")
                            .font(.headline)
                        Spacer()
                        Text("Yanvar 2024")
                            .font(.headline)
                    }
                    .padding(.horizontal)
                    .opacity(appeared ? 1 : 0)

                    // Horizontal day picker
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 6) {
                            ForEach(Array(SampleData.days.enumerated()), id: \.element.id) { index, day in
                                DayCell(
                                    dayOfWeek: day.dayOfWeek,
                                    dayNumber: day.dayNumber,
                                    isSelected: index == selectedDayIndex,
                                    isAvailable: day.isAvailable
                                )
                                .onTapGesture {
                                    if day.isAvailable {
                                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                            selectedDayIndex = index
                                        }
                                    }
                                }
                                .opacity(appeared ? 1 : 0)
                                .scaleEffect(appeared ? 1 : 0.8)
                                .animation(
                                    .spring(response: 0.4, dampingFraction: 0.7)
                                    .delay(Double(index) * 0.04),
                                    value: appeared
                                )
                            }
                        }
                        .padding(.horizontal)
                    }

                    // Calendar link
                    Button(action: {}) {
                        HStack(spacing: 4) {
                            Image(systemName: "calendar")
                            Text("Təqvimdən seç")
                        }
                        .font(.subheadline)
                        .foregroundColor(.appBlue)
                    }
                    .padding(.horizontal)
                    .opacity(appeared ? 1 : 0)
                }

                // MARK: - Time slots
                timeSlotSection(title: "Səhər", slots: SampleData.morningSlots, delay: 0.15)
                timeSlotSection(title: "Gündüz", slots: SampleData.afternoonSlots, delay: 0.25)
                timeSlotSection(title: "Axşam", slots: SampleData.eveningSlots, delay: 0.35)
            }
            .padding(.top, 8)
            .padding(.bottom, 20)
        }
        .background(Color.sectionBackground)
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                VStack(spacing: 2) {
                    Text(doctor?.name ?? "Həkim")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                    Text(doctor?.specialty ?? "")
                        .font(.caption)
                        .foregroundColor(Color(.secondaryLabel))
                }
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                appeared = true
            }
        }
    }

    @ViewBuilder
    func timeSlotSection(title: String, slots: [TimeSlot], delay: Double) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.headline)
                .padding(.horizontal)

            LazyVGrid(columns: columns, spacing: 8) {
                ForEach(slots) { slot in
                    Text(slot.time)
                        .font(.subheadline)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(
                            selectedSlot == slot.time
                                ? Color.appBlue
                                : Color(.tertiarySystemFill)
                        )
                        .foregroundColor(
                            selectedSlot == slot.time
                                ? .white
                                : Color(.label)
                        )
                        .cornerRadius(12)
                        .onTapGesture {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                selectedSlot = slot.time
                            }
                        }
                }
            }
            .padding(.horizontal)
        }
        .opacity(appeared ? 1 : 0)
        .offset(y: appeared ? 0 : 20)
        .animation(.spring(response: 0.5, dampingFraction: 0.8).delay(delay), value: appeared)
    }
}

struct DayCell: View {
    let dayOfWeek: String
    let dayNumber: Int
    let isSelected: Bool
    let isAvailable: Bool

    var body: some View {
        VStack(spacing: 4) {
            Text(dayOfWeek)
                .font(.caption)
                .foregroundColor(textColor)
            Text("\(dayNumber)")
                .font(.body)
                .fontWeight(isSelected ? .bold : .regular)
                .foregroundColor(textColor)
        }
        .frame(width: 46, height: 58)
        .background(isSelected ? Color.appBlue : Color.clear)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(isAvailable && !isSelected ? Color(.separator) : Color.clear, lineWidth: 1)
        )
    }

    var textColor: Color {
        if isSelected { return .white }
        if !isAvailable { return Color(.quaternaryLabel) }
        return Color(.label)
    }
}

#Preview {
    NavigationStack {
        DoctorTimeSlotsView()
    }
}
