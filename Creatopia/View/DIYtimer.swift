//
//  DIYtimer.swift
//  Creatopia
//
//  Created by Sarah Khalid Almalki on 20/08/1447 AH.
//

import SwiftUI
import UIKit
import Combine

struct DIYtimer: View {
    @State private var animate: Bool = false
    @State private var timeRemaining = 6
    @State private var showConfetti = false

    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        ZStack{
            Image("timerBackground")
                .resizable()
                .frame(width:1370, height:1037)
            ZStack{
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.panelPink)
                    .overlay(
                        VStack(spacing: 100) {
                            Text("GO GO GO!")
                                .font(.system(size: 60, weight: .bold))
                                .foregroundColor(.white)
                                .scaleEffect(animate ? 1.5 : 1.0)
                                .onAppear {
                                    withAnimation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
                                        animate.toggle()
                                    }
                                }
                            
                            Text(timeString(from: timeRemaining))
                                .font(.system(size: 60, weight: .semibold))
                                .foregroundColor(.white)
                            
                        }
                        .onReceive(timer) { _ in
                            if timeRemaining > 0 {
                                timeRemaining -= 1
                                if timeRemaining == 0 {
                                    showConfetti = true
                                }
                            }
                        }

                    )
                    .frame(width: 760, height: 510)
                
                if showConfetti {
                    ConfettiView()
                }
            }
        }
    }

    struct ConfettiView: View {
        let colors: [Color] = [.red, .purple, .yellow, .green, .orange, .pink, .white, .mint]
        var body: some View {
            GeometryReader { geo in
                ForEach(0..<500, id: \.self) { _ in
                    ConfettiPiece(
                        color: colors.randomElement()!,
                        x: CGFloat.random(in: 0...geo.size.width),
                        delay: Double.random(in: 0...2)
                    )
                }
            }
            .ignoresSafeArea()
        }
    }
    struct ConfettiPiece: View {
        let color: Color
        let x: CGFloat
        let delay: Double

        @State private var y: CGFloat = -20
        @State private var rotation: Double = 0

        var body: some View {
            Rectangle()
                .fill(color)
                .frame(width: 8, height: 14)
                .rotationEffect(.degrees(rotation))
                .position(x: x, y: y)
                .onAppear {
                    withAnimation(
                        .easeIn(duration: 2.5)
                        .delay(delay)
                    ) {
                        y = UIScreen.main.bounds.height + 20
                        rotation = Double.random(in: 0...360)
                    }
                }
        }
    }

    // Formats seconds as HH:MM:SS
    private func timeString(from totalSeconds: Int) -> String {
        let hour = totalSeconds / 3600
        let minutes = (totalSeconds % 3600) / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d:%02d", hour, minutes, seconds)
    }
}

#Preview {
    DIYtimer()
}
