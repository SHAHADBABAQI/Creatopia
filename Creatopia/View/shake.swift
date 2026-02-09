//
//  shake.swift
//  Creatopia
//
//  Created by reham naif  on 21/08/1447 AH.
//

import SwiftUI
import Combine

struct ShakeDetector: View {
    private let footerSize: CGFloat = 28
    @State private var didShake = false

    var body: some View {
        ZStack {
            Image("ROOM9")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            if didShake {
                VStack {
                    Spacer()
                    Text("Shaken!")
                        .font(.system(size: footerSize, weight: .bold))
                        .padding(.bottom, 16)
                }
                .transition(.opacity)
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .deviceDidShake)) { _ in
            didShake = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                didShake = false
            }
        }
    }
}

#if os(iOS)
import UIKit

extension UIWindow {
    open override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        super.motionEnded(motion, with: event)
        if motion == .motionShake {
            NotificationCenter.default.post(name: .deviceDidShake, object: nil)
        }
    }
}

extension Notification.Name {
    static let deviceDidShake = Notification.Name("DeviceDidShakeNotification")
}
#endif
#Preview {
    ShakeDetector()
}
