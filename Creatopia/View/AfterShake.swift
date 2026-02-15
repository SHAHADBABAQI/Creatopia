//
//  AfterShake.swift
//  Creatopia
//
//  Created by Maram Ibrahim  on 27/08/1447 AH.
//
import SwiftUI
import UIKit
struct AfterShake: View {

private let titleSize: CGFloat = 60
private let subtitleSize: CGFloat = 30
private let footerSize: CGFloat = 28
var body: some View {
ZStack {
Image("ROOM9")
.resizable()
.scaledToFill()
.ignoresSafeArea()
BubbleOverlay()
BigMovingBubblesOverlay()
VStack(spacing: 80) {
VStack(spacing: 20) {
Text("Let's create !")
.font(.system(size: titleSize, weight: .bold))
.padding(.top, 80)
Text("Your creative tools are hiding… Give your phone a gentle shake!")
.font(.system(size: subtitleSize, weight: .bold))
.multilineTextAlignment(.center)
.opacity(0.7)
.padding(.horizontal, 40)
                }

Spacer()
Text("A gentle shake… Unlock three little surprises")
.font(.system(size: footerSize, weight: .bold))
.opacity(0.5)
.padding(.bottom, 80)
            }
        }
    }
}

#Preview(traits: .landscapeLeft) {
    ContentView()
}

// MARK: - Big moving bubbles overlay (✅ with multi-images + shake)

struct BigMovingBubblesOverlay: View {

    // ✅ حطي هنا كل صور الواجهة السابقة اللي بتكون داخل الكور
    // أنصحك 6–8 صور: PREV1 ... PREV8
    private let prevPhotos = ["PREV1", "PREV2", "PREV3", "PREV4", "PREV5", "PREV6", "PREV7", "PREV8" ,"PREV9" ,"PREV10"   ]

    @State private var photo1: String = "PREV1"
    @State private var photo2: String = "PREV2"
    @State private var photo3: String = "PREV3"

    var body: some View {
        GeometryReader { geo in
            ZStack {

                MovingToolBall(image: "pencil", size: 240,
                               baseX: geo.size.width * 0.20,
                               baseY: geo.size.height * 0.50,
                               driftX: 14, driftY: 12,
                               duration: 3.2,
                               delay: 0.0,
                               insidePhoto: photo1)

                MovingToolBall(image: "glue", size: 240,
                               baseX: geo.size.width * 0.50,
                               baseY: geo.size.height * 0.50,
                               driftX: 10, driftY: 16,
                               duration: 3.8,
                               delay: 0.3,
                               insidePhoto: photo2)

                MovingToolBall(image: "ruler", size: 240,
                               baseX: geo.size.width * 0.82,
                               baseY: geo.size.height * 0.50,
                               driftX: 16, driftY: 10,
                               duration: 3.4,
                               delay: 0.15,
                               insidePhoto: photo3)
            }
        }
        .ignoresSafeArea()
        .onAppear {
            applyNewPhotos()
        }
        .onReceive(NotificationCenter.default.publisher(for: .deviceDidShakeNotification)) { _ in
            withAnimation(.easeInOut(duration: 0.25)) {
                applyNewPhotos()
            }
        }
    }

    private func applyNewPhotos() {
        let picked = pickThreeDistinct(from: prevPhotos)
        photo1 = picked[0]
        photo2 = picked[1]
        photo3 = picked[2]
    }

    private func pickThreeDistinct(from list: [String]) -> [String] {
        let unique = Array(Set(list))
        if unique.count >= 3 {
            return Array(unique.shuffled().prefix(3))
        } else if unique.count == 2 {
            let shuffled = unique.shuffled()
            return [shuffled[0], shuffled[1], shuffled[0]]
        } else if unique.count == 1 {
            return [unique[0], unique[0], unique[0]]
        } else {
            return ["ROOM9", "ROOM9", "ROOM9"]
        }
    }
}

struct MovingToolBall: View {
    let image: String
    let size: CGFloat

    let baseX: CGFloat
    let baseY: CGFloat

    let driftX: CGFloat
    let driftY: CGFloat

    let duration: Double
    let delay: Double

    let insidePhoto: String

    @State private var move = false

    var body: some View {
        BigGlossyBubble(size: size, backgroundImage: insidePhoto)
            .overlay(
                Image(image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: size * 0.45, height: size * 0.45)
                    .rotationEffect(.degrees(-12))
                    .shadow(radius: 6)
            )
            .position(
                x: baseX + (move ? driftX : -driftX),
                y: baseY + (move ? -driftY : driftY)
            )
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                    withAnimation(.easeInOut(duration: duration).repeatForever(autoreverses: true)) {
                        move = true
                    }
                }
            }
    }
}

// MARK: - Bubble styles

struct BigGlossyBubble: View {
    let size: CGFloat
    let backgroundImage: String

    var body: some View {
        ZStack {
            // ✅ الصورة داخل الكرة
            Image(backgroundImage)
                .resizable()
                .scaledToFill()
                .frame(width: size, height: size)
                .clipShape(Circle())

            // ✅ tint خفيف يعطي إحساس bubble
            Circle()
                .fill(Color(red: 0.73, green: 0.91, blue: 0.97).opacity(0.25))

            // ✅ gloss
            Circle()
                .fill(
                    RadialGradient(
                        colors: [.white.opacity(0.25), .clear],
                        center: .topLeading,
                        startRadius: 10,
                        endRadius: size * 0.7
                    )
                )

            Capsule()
                .fill(.white.opacity(0.65))
                .frame(width: size * 0.18, height: size * 0.30)
                .rotationEffect(.degrees(25))
                .offset(x: -size * 0.28, y: -size * 0.15)
                .blur(radius: 0.6)

            Capsule()
                .fill(.white.opacity(0.45))
                .frame(width: size * 0.12, height: size * 0.22)
                .rotationEffect(.degrees(25))
                .offset(x: size * 0.30, y: size * 0.18)
                .blur(radius: 0.8)
        }
        .frame(width: size, height: size)
        .clipShape(Circle())
        .shadow(color: .black.opacity(0.18), radius: 12, x: 0, y: 8)
    }
}

// MARK: - Helpers

// MARK: - Shake detection (✅ داخل نفس الملف)

extension UIWindow {
    open override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            NotificationCenter.default.post(name: .deviceDidShakeNotification, object: nil)
        }
    }
}

extension Notification.Name {
    static let deviceDidShakeNotification = Notification.Name("deviceDidShakeNotification")
}

#Preview {
   AfterShake()
}
