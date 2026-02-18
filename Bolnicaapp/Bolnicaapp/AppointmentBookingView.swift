import SwiftUI

struct AppointmentBookingView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedSegment = 0
    @State private var appeared = false

    let segments = ["Məqsəd", "Göndəriş", "Həkim"]

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Segmented control
                HStack(spacing: 0) {
                    ForEach(Array(segments.enumerated()), id: \.offset) { index, title in
                        Button(action: {
                            withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                                selectedSegment = index
                            }
                        }) {
                            HStack(spacing: 4) {
                                Text(title)
                                    .font(.subheadline)
                                    .fontWeight(selectedSegment == index ? .semibold : .regular)
                                if index == 1 {
                                    Text("6")
                                        .font(.caption2)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 5)
                                        .padding(.vertical, 1)
                                        .background(Color.appBlue)
                                        .clipShape(Capsule())
                                }
                            }
                            .foregroundColor(selectedSegment == index ? Color(.label) : Color(.secondaryLabel))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 10)
                            .background(
                                selectedSegment == index
                                    ? Color.cardBackground
                                    : Color.clear
                            )
                            .cornerRadius(10)
                        }
                    }
                }
                .padding(4)
                .background(Color(.tertiarySystemFill))
                .cornerRadius(12)
                .padding(.horizontal)
                .padding(.top, 12)

                // Content based on segment
                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        if selectedSegment == 0 {
                            goalListView
                        } else if selectedSegment == 1 {
                            referralListView
                        } else {
                            doctorListView
                        }
                    }
                    .opacity(appeared ? 1 : 0)
                    .offset(y: appeared ? 0 : 10)
                }
            }
            .background(Color.sectionBackground)
            .navigationTitle("Növbə")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark")
                            .foregroundColor(Color(.label))
                    }
                }
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.8).delay(0.15)) {
                appeared = true
            }
        }
    }

    // MARK: - Goal List (Məqsəd tab)

    var goalListView: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Müraciət məqsədləri")
                .font(.title3)
                .fontWeight(.bold)
                .padding(.horizontal)
                .padding(.top, 20)
                .padding(.bottom, 4)

            Text("Poliklinikaya qeydiyyat")
                .font(.subheadline)
                .foregroundColor(Color(.secondaryLabel))
                .padding(.horizontal)
                .padding(.bottom, 12)

            VStack(spacing: 0) {
                ForEach(Array(SampleData.appointmentGoals.enumerated()), id: \.element.id) { index, goal in
                    HStack(spacing: 12) {
                        Image(systemName: goal.icon)
                            .font(.title3)
                            .foregroundColor(.appBlue)
                            .frame(width: 28, height: 28)

                        VStack(alignment: .leading, spacing: 2) {
                            Text(goal.title)
                                .font(.body)
                                .foregroundColor(Color(.label))
                            if let subtitle = goal.subtitle {
                                Text(subtitle)
                                    .font(.caption)
                                    .foregroundColor(Color(.secondaryLabel))
                            }
                        }

                        Spacer()

                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundColor(Color(.tertiaryLabel))
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)

                    if index < SampleData.appointmentGoals.count - 1 {
                        Divider().padding(.leading, 56)
                    }
                }
            }

            // Yığ link
            Button(action: {}) {
                HStack {
                    Text("Yığ")
                        .font(.subheadline)
                    Image(systemName: "chevron.up")
                        .font(.caption)
                }
                .foregroundColor(.appBlue)
                .padding(.horizontal)
                .padding(.vertical, 8)
            }

            Divider()
                .padding(.vertical, 8)

            // Additional items
            VStack(spacing: 0) {
                additionalRow(icon: "mouth", title: "Stomatoloqa qeydiyyat")
                Divider().padding(.leading, 56)
                additionalRow(icon: "allergens", title: "Dermatoloqa qeydiyyat")
            }
            .padding(.bottom, 20)
        }
    }

    @ViewBuilder
    func additionalRow(icon: String, title: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(.appBlue)
                .frame(width: 28, height: 28)
            Text(title)
                .font(.body)
                .foregroundColor(Color(.label))
            Spacer()
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(Color(.tertiaryLabel))
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }

    // MARK: - Referral List (Göndəriş tab)

    var referralListView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Göndərişlər")
                .font(.title3)
                .fontWeight(.bold)
                .padding(.horizontal)
                .padding(.top, 20)

            VStack(spacing: 0) {
                NavigationLink(destination: ReferralDetailView()) {
                    HStack(spacing: 12) {
                        Image(systemName: "drop.triangle")
                            .font(.title3)
                            .foregroundColor(.appBlue)
                            .frame(width: 28)
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Venoz qan götürülməsi")
                                .font(.body)
                                .foregroundColor(Color(.label))
                            Text("24 dek-dək")
                                .font(.caption)
                                .foregroundColor(Color(.secondaryLabel))
                        }
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundColor(Color(.tertiaryLabel))
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                }

                Divider().padding(.leading, 56)

                HStack(spacing: 12) {
                    Image(systemName: "waveform.path.ecg")
                        .font(.title3)
                        .foregroundColor(.appBlue)
                        .frame(width: 28)
                    VStack(alignment: .leading, spacing: 2) {
                        Text("EKQ")
                            .font(.body)
                            .foregroundColor(Color(.label))
                        Text("30 dek-dək")
                            .font(.caption)
                            .foregroundColor(Color(.secondaryLabel))
                    }
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundColor(Color(.tertiaryLabel))
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
            }
            .background(Color.cardBackground)
            .cornerRadius(18)
            .padding(.horizontal)
        }
    }

    // MARK: - Doctor List (Həkim tab)

    var doctorListView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Həkim seçin")
                .font(.title3)
                .fontWeight(.bold)
                .padding(.horizontal)
                .padding(.top, 20)

            VStack(spacing: 0) {
                NavigationLink(destination: DoctorTimeSlotsView()) {
                    doctorRow(name: "Məmmədova Aynur Elçin qızı", specialty: "Ümumi təcrübə həkimi")
                }
                Divider().padding(.leading, 72)
                doctorRow(name: "Həsənova Leyla Rəşid qızı", specialty: "Terapevt")
                Divider().padding(.leading, 72)
                doctorRow(name: "Əliyev Murad Kamil oğlu", specialty: "Cərrah")
            }
            .background(Color.cardBackground)
            .cornerRadius(18)
            .padding(.horizontal)
        }
    }

    @ViewBuilder
    func doctorRow(name: String, specialty: String) -> some View {
        HStack(spacing: 12) {
            Circle()
                .fill(Color(.tertiarySystemFill))
                .frame(width: 44, height: 44)
                .overlay(
                    Image(systemName: "person.fill")
                        .foregroundColor(Color(.secondaryLabel))
                )

            VStack(alignment: .leading, spacing: 2) {
                Text(name)
                    .font(.body)
                    .foregroundColor(Color(.label))
                Text(specialty)
                    .font(.caption)
                    .foregroundColor(Color(.secondaryLabel))
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(Color(.tertiaryLabel))
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }
}

#Preview {
    AppointmentBookingView()
}
