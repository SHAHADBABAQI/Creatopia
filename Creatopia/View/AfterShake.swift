import SwiftUI
import UIKit

struct AfterShake: View {
    private let titleSize: CGFloat = 60
    private let subtitleSize: CGFloat = 30
    private let footerSize: CGFloat = 28
    
    @State private var showBubbles = false
    @State private var selectedImages: [String] = []
    
    // ✅ Your 12 asset images
    private let allImages = ["PREV1", "PREV2", "PREV3", "PREV4", "PREV5", "PREV6",
                            "PREV7", "PREV8", "PREV9", "PREV10", "PREV11", "PREV12"]
    
    var body: some View {
        ZStack {
            Image("room")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            // ✅ Show bubbles only after shake
            if showBubbles {
                BigMovingBubblesOverlay(imageNames: selectedImages)
            }
            
            VStack(spacing: 80) {
                VStack(spacing: 20) {
                    Text("Let's create !")
                        .font(.system(size: titleSize, weight: .bold))
                        .padding(.top, 80)
                    
                    Text(showBubbles ? "Here are your masterpieces!" : "Shake again to see your creations!")
                        .font(.system(size: subtitleSize, weight: .bold))
                        .multilineTextAlignment(.center)
                        .opacity(0.7)
                        .padding(.horizontal, 40)
                }
                
                Spacer()
                
                Text(showBubbles ? "Shake again for new surprises!" : "A gentle shake… Unlock three little surprises")
                    .font(.system(size: footerSize, weight: .bold))
                    .opacity(0.5)
                    .padding(.bottom, 80)
            }
        }
        .navigationBarBackButtonHidden(true)
        .modifier(ShakeDetector {
            withAnimation(.spring(response: 0.45, dampingFraction: 0.75)) {
                selectRandomImages()
                showBubbles = true
            }
        })
        .onAppear {
            selectRandomImages()
        }
    }
    
    private func selectRandomImages() {
        selectedImages = Array(allImages.shuffled().prefix(3))
    }
}

#Preview(traits: .landscapeLeft) {
    AfterShake()
}

// MARK: - Big moving bubbles overlay with asset images

struct BigMovingBubblesOverlay: View {
    let imageNames: [String]
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                // ✅ First bubble (left) with pencil tool
                if imageNames.count > 0 {
                    MovingBubbleWithTool(
                        toolImage: "pencil",
                        size: 200,
                        baseX: geo.size.width * 0.20,
                        baseY: geo.size.height * 0.50,
                        driftX: 14,
                        driftY: 12,
                        duration: 3.2,
                        delay: 0.0,
                        backgroundImage: imageNames[0]
                    )
                }
                
                // ✅ Second bubble (center) with paper tool
                if imageNames.count > 1 {
                    MovingBubbleWithTool(
                        toolImage: "paper",
                        size: 220,
                        baseX: geo.size.width * 0.50,
                        baseY: geo.size.height * 0.50,
                        driftX: 10,
                        driftY: 16,
                        duration: 3.8,
                        delay: 0.3,
                        backgroundImage: imageNames[1]
                    )
                }
                
                // ✅ Third bubble (right) with box tool
                if imageNames.count > 2 {
                    MovingBubbleWithTool(
                        toolImage: "box",
                        size: 210,
                        baseX: geo.size.width * 0.82,
                        baseY: geo.size.height * 0.50,
                        driftX: 16,
                        driftY: 10,
                        duration: 3.4,
                        delay: 0.15,
                        backgroundImage: imageNames[2]
                    )
                }
            }
        }
        .ignoresSafeArea()
        .transition(.scale.combined(with: .opacity))
    }
}

struct MovingBubbleWithTool: View {
    let toolImage: String  // pencil, paper, box
    let size: CGFloat
    let baseX: CGFloat
    let baseY: CGFloat
    let driftX: CGFloat
    let driftY: CGFloat
    let duration: Double
    let delay: Double
    let backgroundImage: String
    
    @State private var move = false
    
    var body: some View {
        ZStack {
            // ✅ Bubble with image background
            BigGlossyBubbleWithAssetImage(size: size, imageName: backgroundImage)
            
            // ✅ Tool overlay ON TOP of bubble
            Image(toolImage)
                .resizable()
                .scaledToFit()
                .frame(width: size * 0.55, height: size * 0.55)  // ✅ Larger for better quality
                .shadow(color: .black.opacity(0.3), radius: 8, x: 0, y: 4)  // ✅ Better shadow
        }
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

// MARK: - Bubble with asset image

struct BigGlossyBubbleWithAssetImage: View {
    let size: CGFloat
    let imageName: String
    
    var body: some View {
        ZStack {
            // ✅ Asset image as background
            Image(imageName)
                .resizable()
                .scaledToFill()
                .frame(width: size, height: size)
                .clipShape(Circle())
            
            // ✅ Bubble tint
            Circle()
                .fill(Color(red: 0.73, green: 0.91, blue: 0.97).opacity(0.25))
            
            // ✅ Gloss effect
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

// MARK: - Shake detection helpers

struct shakeDetector: ViewModifier {
    let onShake: () -> Void

    func body(content: Content) -> some View {
        content
            .background(ShakeRepresentable(onShake: onShake))
    }
}

struct shakeRepresentable: UIViewRepresentable {
    let onShake: () -> Void

    func makeUIView(context: Context) -> UIView {
        let view = ShakeUIView()
        view.onShake = onShake
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}

final class shakeUIView: UIView {
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
