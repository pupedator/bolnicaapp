import SwiftUI

struct MedicalCardView: View {
    @State private var appeared = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    // MARK: - Sənədlər header
                    Text("Sənədlər")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.horizontal)
                        .padding(.top, 16)
                        .padding(.bottom, 12)
                        .opacity(appeared ? 1 : 0)

                    // COVID tests (standalone card)
                    VStack(spacing: 0) {
                        documentRow(
                            icon: SampleData.documents[0].icon,
                            title: SampleData.documents[0].title,
                            count: SampleData.documents[0].count
                        )
                    }
                    .background(Color.cardBackground)
                    .cornerRadius(18)
                    .padding(.horizontal)
                    .padding(.bottom, 12)
                    .opacity(appeared ? 1 : 0)
                    .offset(y: appeared ? 0 : 15)
                    .animation(.spring(response: 0.5, dampingFraction: 0.8).delay(0.1), value: appeared)

                    // Main documents list
                    VStack(spacing: 0) {
                        ForEach(Array(SampleData.documents.dropFirst().enumerated()), id: \.element.id) { index, doc in
                            documentRow(icon: doc.icon, title: doc.title, count: doc.count)
                            if index < SampleData.documents.count - 2 {
                                Divider().padding(.leading, 56)
                            }
                        }
                    }
                    .background(Color.cardBackground)
                    .cornerRadius(18)
                    .padding(.horizontal)
                    .padding(.bottom, 12)
                    .opacity(appeared ? 1 : 0)
                    .offset(y: appeared ? 0 : 15)
                    .animation(.spring(response: 0.5, dampingFraction: 0.8).delay(0.2), value: appeared)

                    // Yüklənmiş sənədlər
                    VStack(spacing: 0) {
                        HStack(spacing: 12) {
                            Image(systemName: "arrow.up.circle")
                                .font(.title3)
                                .foregroundColor(.appBlue)
                                .frame(width: 32, height: 32)
                            Text("Yüklənmiş sənədlər")
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
                    .background(Color.cardBackground)
                    .cornerRadius(18)
                    .padding(.horizontal)
                    .padding(.bottom, 24)
                    .opacity(appeared ? 1 : 0)
                    .offset(y: appeared ? 0 : 15)
                    .animation(.spring(response: 0.5, dampingFraction: 0.8).delay(0.3), value: appeared)

                    // MARK: - Anamnez section
                    Text("Anamnez")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.horizontal)
                        .padding(.bottom, 12)
                        .opacity(appeared ? 1 : 0)

                    VStack(spacing: 0) {
                        anamnezRow(title: "Xroniki xəstəliklər")
                        Divider().padding(.leading, 56)
                        anamnezRow(title: "Allergiyalar")
                        Divider().padding(.leading, 56)
                        anamnezRow(title: "Qan qrupu")
                    }
                    .background(Color.cardBackground)
                    .cornerRadius(18)
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                    .opacity(appeared ? 1 : 0)
                    .offset(y: appeared ? 0 : 15)
                    .animation(.spring(response: 0.5, dampingFraction: 0.8).delay(0.4), value: appeared)
                }
            }
            .background(Color.sectionBackground)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {}) {
                        HStack(spacing: 4) {
                            Image(systemName: "creditcard")
                            Text("Sığortam")
                                .fontWeight(.semibold)
                            Image(systemName: "chevron.right")
                                .font(.caption)
                        }
                        .foregroundColor(.white)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {}) {
                        Image(systemName: "qrcode")
                            .foregroundColor(.white)
                    }
                }
            }
            .toolbarBackground(Color.appBlue, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                appeared = true
            }
        }
    }

    @ViewBuilder
    func documentRow(icon: String, title: String, count: Int?) -> some View {
        NavigationLink(destination: ClinicPickerView()) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(.appBlue)
                    .frame(width: 32, height: 32)

                Text(title)
                    .font(.body)
                    .foregroundColor(Color(.label))

                Spacer()

                if let count {
                    Text("\(count)")
                        .font(.subheadline)
                        .foregroundColor(Color(.secondaryLabel))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(Color.badgeBackground)
                        .clipShape(Capsule())
                }

                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(Color(.tertiaryLabel))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
    }

    @ViewBuilder
    func anamnezRow(title: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: "heart.text.clipboard")
                .font(.title3)
                .foregroundColor(.appBlue)
                .frame(width: 32, height: 32)

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
}

#Preview {
    MedicalCardView()
}
