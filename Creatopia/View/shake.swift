import SwiftUI

// MARK: - Shake (entry screen)

struct Shake: View {

    @State private var navigateToAfterShake = false

    var body: some View {
        NavigationStack {
            ZStack {

                // ── Background ──
                Image("ROOM9")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()

                // ── Card ──
                ShakeCard()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .offset(y: 80)

                // ── Text ──
                VStack(spacing: 80) {
                    Text("Let's Create !")
                        .font(.system(size: 60, weight: .bold))
                        .padding(.top, 100)

                    Text("Your creative tools are hiding…\nGive your phone a gentle shake!")
                        .font(.system(size: 30, weight: .bold))
                        .multilineTextAlignment(.center)
                        .opacity(0.9)
                        .padding(.horizontal, 20)

                    Spacer()
                }

                // ── Navigation trigger ──
                NavigationLink(destination: AfterShake(), isActive: $navigateToAfterShake) {
                    EmptyView()
                }
                .hidden()

                // ── Yellow arrow button ──
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button {
                            navigateToAfterShake = true
                        } label: {
                            Image(systemName: "arrow.right")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.black)
                                .frame(width: 70, height: 80)
                                .background(Color.yellow)
                                .clipShape(Circle())
                                .shadow(color: .black.opacity(0.25), radius: 8, x: 0, y: 6)
                        }
                        .padding(.trailing, 90)
                        .padding(.bottom, 90)
                    }
                }
            }
            .navigationBarBackButtonHidden(true)
            .onShake {
                // Small delay lets the spring animation settle before push
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    navigateToAfterShake = true
                }
            }
        }
    }
}

// MARK: - Shake Card

private struct ShakeCard: View {
    var body: some View {
        ZStack {
            // Card background
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(Color(hex: "#A9D8F6"))
                .frame(width: 500, height: 300)
                .overlay(
                    RoundedRectangle(cornerRadius: 28, style: .continuous)
                        .stroke(Color.black.opacity(0.9), lineWidth: 8)
                )
                .shadow(color: .black.opacity(0.25), radius: 18, x: 0, y: 12)
                .rotationEffect(.degrees(-10))

            // SHAKE text stack
            ZStack {
                Text("SHAKE")
                    .font(.system(size: 28, weight: .heavy))
                    .foregroundColor(.white)
                    .opacity(0.92)
                    .offset(x: -55, y: -75)

                Text("SHAKE")
                    .font(.system(size: 62, weight: .heavy))
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.12), radius: 2, x: 0, y: 2)
                    .offset(x: -75, y: -8)

                Text("SHAKE")
                    .font(.system(size: 28, weight: .heavy))
                    .foregroundColor(.white)
                    .opacity(0.92)
                    .offset(x: 90, y: 25)
            }
            .rotationEffect(.degrees(-30))
        }
    }
}

// MARK: - Preview

#Preview(traits: .landscapeLeft) {
    Shake()
}
