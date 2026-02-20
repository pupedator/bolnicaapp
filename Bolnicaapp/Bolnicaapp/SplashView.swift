import SwiftUI

struct SplashView: View {
    @State private var logoScale: CGFloat = 0.5
    @State private var logoOpacity: Double = 0
    @State private var textOpacity: Double = 0
    @State private var finished = false

    var onFinished: () -> Void

    var body: some View {
        ZStack {
            Color.appBlue
                .ignoresSafeArea()

            VStack(spacing: 16) {
                // App icon
                ZStack {
                    Circle()
                        .fill(.white.opacity(0.15))
                        .frame(width: 120, height: 120)

                    Image(systemName: "cross.case.circle.fill")
                        .font(.system(size: 64))
                        .foregroundColor(.white)
                }
                .scaleEffect(logoScale)
                .opacity(logoOpacity)

                // App name
                VStack(spacing: 4) {
                    Text("eTebib")
                        .font(.system(size: 36, weight: .bold, design: .rounded))
                        .foregroundColor(.white)

                    Text("Tibbi xidmətlər portalı")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.7))
                }
                .opacity(textOpacity)
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                logoScale = 1
                logoOpacity = 1
            }
            withAnimation(.easeIn(duration: 0.4).delay(0.3)) {
                textOpacity = 1
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
                withAnimation(.easeOut(duration: 0.3)) {
                    finished = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    onFinished()
                }
            }
        }
        .opacity(finished ? 0 : 1)
        .scaleEffect(finished ? 1.1 : 1)
    }
}

#Preview {
    SplashView(onFinished: {})
}
