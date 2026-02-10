//
//  ContentView.swift
//  ShakeDetector
//
//  Created by reham naif  on 19/08/1447 AH.
import SwiftUI
import UIKit

struct shake: View {

    private let titleSize: CGFloat = 60
    private let subtitleSize: CGFloat = 30
    private let footerSize: CGFloat = 28

    @State private var didShake = false

    var body: some View {
        ZStack {
            Image("ROOM9")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            BubbleOverlay()

            ZStack {
                MiniIPadRealCard(shakeNow: didShake)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .offset(y: 80)

            VStack(spacing: 100) {

                VStack(spacing: 80) {
                    Text("Let's Create !")
                        .font(.system(size: titleSize, weight: .bold))
                        .padding(.top, 100)

                    Text("Your creative tools are hiding… Give your phone a gentle shake!")
                        .font(.system(size: subtitleSize, weight: .bold))
                        .multilineTextAlignment(.center)
                        .opacity(0.9)
                        .padding(.horizontal, 20)
                }

                Spacer()

                Text("A gentle shake… Unlock three little surprises")
                    .font(.system(size: footerSize, weight: .bold))
                    .opacity(0.9)
                    .padding(.bottom, 80)
            }

            BigSurprisesOverlay(show: didShake)
                .allowsHitTesting(false)
        }
        .modifier(ShakeDetector {
            withAnimation(.spring(response: 0.25, dampingFraction: 0.60)) {
                didShake = true
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                withAnimation(.easeOut(duration: 0.2)) {
                    didShake = false
                }
            }
        })
    }
}

struct MiniIPadRealCard: View {

    let shakeNow: Bool
    @State private var wiggle = false

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(Color(hex: "#A9D8F6"))
                .frame(width: 500, height: 300)
                .overlay(
                    RoundedRectangle(cornerRadius: 28, style: .continuous)
                        .stroke(Color.black.opacity(0.9), lineWidth: 8)
                )
                .shadow(color: .black.opacity(0.25), radius: 18, x: 0, y: 12)
                .rotationEffect(.degrees(wiggle ? -14 : -10))

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
        .onChange(of: shakeNow) { _, newValue in
            guard newValue else { return }

            withAnimation(.easeInOut(duration: 0.10).repeatCount(6, autoreverses: true)) {
                wiggle.toggle()
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                wiggle = false
            }
        }
    }
}

struct ShakeHintArrows: View {

    private let cardRotation: Angle = .degrees(-10)
    @State private var animate = false

    var body: some View {
        ZStack {
            LCornerStack()
                .offset(x: 240, y: -95)

            LCornerStack()
                .scaleEffect(x: -1, y: -1)
                .offset(x: -250, y: 105)
        }
        .rotationEffect(cardRotation)
        .opacity(animate ? 1.0 : 0.55)
        .offset(x: animate ? 5 : -5, y: animate ? -2 : 2)
        .animation(.easeInOut(duration: 0.55).repeatForever(autoreverses: true), value: animate)
        .onAppear { animate = true }
        .allowsHitTesting(false)
    }
}

struct LCornerStack: View {
    var body: some View {
        ZStack {
            LCorner(size: 46, line: 6).offset(x: 0,  y: 0)
            LCorner(size: 38, line: 6).offset(x: 10, y: 10)
            LCorner(size: 30, line: 6).offset(x: 20, y: 20)
        }
        .foregroundColor(.black.opacity(0.9))
    }
}

struct LCorner: View {
    let size: CGFloat
    let line: CGFloat

    var body: some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 3)
                .frame(width: size, height: line)

            RoundedRectangle(cornerRadius: 3)
                .frame(width: line, height: size)
        }
    }
}

struct BigSurprisesOverlay: View {
    let show: Bool

    var body: some View {
        GeometryReader { geo in
            ZStack {
                if show {
                    BigToolBall(image: "pencil",  size: 170)
                        .position(x: geo.size.width * 0.40, y: geo.size.height * 0.55)

                    BigToolBall(image: "paper",   size: 190)
                        .position(x: geo.size.width * 0.55, y: geo.size.height * 0.52)

                    BigToolBall(image: "box",     size: 175)
                        .position(x: geo.size.width * 0.70, y: geo.size.height * 0.56)
                }
            }
        }
        .animation(.spring(response: 0.55, dampingFraction: 0.78), value: show)
    }
}

struct BigToolBall: View {
    let image: String
    let size: CGFloat

    var body: some View {
        GlassBubble(size: size)
            .overlay(
                Image(image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: size * 0.50, height: size * 0.50)
                    .opacity(0.95)
            )
            .transition(.scale.combined(with: .opacity))
    }
}

struct BubbleOverlay: View {

    struct BubbleItem: Identifiable {
        let id = UUID()
        let image: String
        let size: CGFloat
        let x: CGFloat
        let y: CGFloat
    }

    private let bubbles: [BubbleItem] = [
        .init(image: "pencil",   size: 70,  x: 0.18, y: 0.22),
        .init(image: "ruler",    size: 110, x: 0.86, y: 0.20),
        .init(image: "glue",     size: 80,  x: 0.78, y: 0.42),
        .init(image: "eraser",   size: 95,  x: 0.16, y: 0.52),
        .init(image: "tape",     size: 85,  x: 0.38, y: 0.68),
        .init(image: "scissors", size: 120, x: 0.55, y: 0.36),
        .init(image: "brush",    size: 90,  x: 0.92, y: 0.58),
//
//        .init(image: "pencil",   size: 60,  x: 0.08, y: 0.18),
//        .init(image: "glue",     size: 65,  x: 0.62, y: 0.18),
//        .init(image: "tape",     size: 75,  x: 0.90, y: 0.75),
//        .init(image: "eraser",   size: 55,  x: 0.25, y: 0.82),
//        .init(image: "ruler",    size: 70,  x: 0.70, y: 0.84),
//
//        .init(image: "glue",     size: 95,  x: 0.10, y: 0.88),
//        .init(image: "tape",     size: 110, x: 0.22, y: 0.92),
//        .init(image: "pencil",   size: 130, x: 0.40, y: 0.90),
//        .init(image: "eraser",   size: 100, x: 0.62, y: 0.94),
//        .init(image: "ruler",    size: 115, x: 0.80, y: 0.90),
//        .init(image: "scissors", size: 135, x: 0.94, y: 0.92)
    ]

    var body: some View {
        GeometryReader { geo in
            ZStack {
                ForEach(bubbles) { item in
                    ToolBubble(
                        image: item.image,
                        size: item.size,
                        x: geo.size.width * item.x,
                        y: geo.size.height * item.y
                    )
                }
            }
        }
        .ignoresSafeArea()
    }
}

struct ToolBubble: View {
    let image: String
    let size: CGFloat
    let x: CGFloat
    let y: CGFloat

    var body: some View {
        GlassBubble(size: size)
            .overlay(
                Image(image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: size * 0.42, height: size * 0.42)
                    .opacity(0.88)
            )
            .position(x: x, y: y)
    }
}

struct GlassBubble: View {
    var size: CGFloat

    var body: some View {
        ZStack {
            Circle()
                .fill(Color(hex: "#D9D9D9").opacity(0.10))
                .background(
                    Circle()
                        .fill(.ultraThinMaterial)
                        .opacity(0.35)
                )

            Circle()
                .fill(
                    LinearGradient(
                        colors: [
                            .white.opacity(0.55),
                            .white.opacity(0.10),
                            .clear
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .padding(size * 0.16)
                .blur(radius: 2)
                .offset(x: -size * 0.06, y: -size * 0.08)
        }
        .frame(width: size, height: size)
        .shadow(color: .white.opacity(0.18), radius: 10, x: -5, y: -5)
        .shadow(color: .black.opacity(0.10), radius: 12, x: 6, y: 8)
    }
}

struct ShakeDetector: ViewModifier {
    let onShake: () -> Void

    func body(content: Content) -> some View {
        content
            .background(ShakeRepresentable(onShake: onShake))
    }
}

struct ShakeRepresentable: UIViewRepresentable {
    let onShake: () -> Void

    func makeUIView(context: Context) -> UIView {
        let view = ShakeUIView()
        view.onShake = onShake
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}

final class ShakeUIView: UIView {
    var onShake: (() -> Void)?

    override var canBecomeFirstResponder: Bool { true }

    override func didMoveToWindow() {
        super.didMoveToWindow()
        becomeFirstResponder()
    }

    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        guard motion == .motionShake else { return }
        onShake?()
    }
}

#Preview {
    shake()
}
