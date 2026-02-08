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
    static let duration = 5
    @State private var timeRemaining = DIYtimer.duration
    @State private var showConfetti = false
    @State private var timerFinished = false
    @State private var isRunning = true

    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        ZStack {
            Image("timerBackground")
                .resizable()
                .frame(width: 1370, height: 1037)

            ZStack {
                RoundedRectangle(cornerRadius: 26)
                    .fill(Color.panelPink)
                    .frame(width: 880, height: 600)
                    .overlay(
                        VStack(spacing: 24) {
                            // Title switches when the timer finishes
                            Text(timerFinished ? "WELL DONE!" : "GO GO GO!")
                                .font(.system(size: 90, weight: .bold))
                                .foregroundColor(.white)
                                .scaleEffect(animate ? 1.3 : 1.0)
                                .onAppear {
                                    withAnimation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
                                        animate.toggle()
                                    }
                                }

                            Text(timeString(from: timeRemaining))
                                .font(.system(size: 60, weight: .semibold)) // larger timer
                                .foregroundColor(.white)

                            // Controls visible during countdown
                            if !timerFinished {
                                HStack(spacing: 24) {
                                    // Restart Button
                                    Button(action: {
                                        timeRemaining = DIYtimer.duration
                                        timerFinished = false
                                        showConfetti = false
                                        isRunning = true
                                    }) {
                                        ZStack {
                                            Circle()
                                                .fill(Color.mint)
                                                .frame(width: 100, height: 100)
                                            Image(systemName: "arrow.clockwise")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 50, height: 50)
                                                .foregroundColor(.white)
                                        }
                                    }

                                    // Pause/Play Button
                                    if timeRemaining > 0 {
                                        Button(action: {
                                            isRunning.toggle()
                                        }) {
                                            ZStack {
                                                Circle()
                                                    .fill(Color.gray)
                                                    .frame(width: 100, height: 100)
                                                Image(systemName: isRunning ? "pause.fill" : "play.fill")
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 50, height: 50)
                                                    .foregroundColor(.white)
                                            }
                                        }
                                    }
                                }
                                .padding(.top, 20)
                                .padding(.bottom, 40)
                            }
                        }
                        .onReceive(timer) { _ in
                            guard isRunning else { return }
                            if timeRemaining > 0 {
                                timeRemaining -= 1
                                if timeRemaining == 0 {
                                    timerFinished = true
                                    showConfetti = true
                                }
                            }
                        }
                    )

                    .overlay(alignment: .bottomLeading) {
                        if timerFinished {
                            Button(action: {

                                timeRemaining = DIYtimer.duration
                                timerFinished = false
                                showConfetti = false
                                isRunning = true
                            }) {
                                ZStack {
                                    Circle()
                                        .fill(Color.ButtonYellow)
                                        .frame(width: 100, height: 100)
                                    Image(systemName: "house.fill")
                                        .resizable()
                                        .frame(width: 80, height: 70)
                                        .foregroundColor(Color.black)
                                }
                            }
                            .padding(24)
                        }
                    }
                    .overlay(alignment: .bottomTrailing) {
                        if timerFinished {
                            Button(action: {
                                // Camera action
                            }) {
                                ZStack {
                                    Circle()
                                        .fill(Color.ButtonYellow)
                                        .frame(width: 100, height: 100)
                                    Image(systemName: "camera.fill")
                                        .resizable()
                                        .frame(width: 60, height: 60)
                                        .foregroundColor(Color.black)
                                }
                            }
                            .padding(24)
                        }
                    }
                    .frame(width: 760, height: 510)

                if showConfetti {
                    ConfettiView()
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
}

#Preview {
    DIYtimer()
}
