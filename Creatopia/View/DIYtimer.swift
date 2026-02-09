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
    static let duration = 900
    @State private var timeRemaining = DIYtimer.duration
    @State private var showConfetti = false
    @State private var timerFinished = false
    @State private var isRunning = true
    @State private var timeConsumed: Int = 0 // in seconds

    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    private var finishedMessage: String {
        if timeConsumed < 60 {
            // Show seconds if less than a minute
            let seconds = max(0, timeConsumed)
            return "you finished crafting in \(seconds) second\(seconds == 1 ? "" : "s"), yay!"
        } else {
            // Show whole minutes (floor)
            let minutes = max(1, timeConsumed / 60)
            return "you finished crafting in \(minutes) minute\(minutes == 1 ? "" : "s"), yay!"
        }
    }

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
                        VStack(spacing: 60) {
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

                            // Subtitle while running vs finished
                            if !timerFinished {
                                Text("Let’s make something amazing in the next \(DIYtimer.duration / 60) minutes")
                                    .font(.system(size: 36, weight: .medium))
                                    .foregroundColor(.white.opacity(0.95))
                                    .transition(.opacity)
                            } else {
                                Text(finishedMessage)
                                    .font(.system(size: 36, weight: .medium))
                                    .foregroundColor(.white.opacity(0.95))
                                    .transition(.opacity)
                            }

                            // Show countdown only while not finished
                            if !timerFinished {
                                Text(timeString(from: timeRemaining))
                                    .font(.system(size: 60, weight: .semibold))
                                    .foregroundColor(.white)
                            }

                            // Controls visible during countdown
                            if !timerFinished {
                                VStack(spacing: 90) {
                                    // Top row: Restart + Pause/Play
                                    HStack(spacing: 250) {
                                        // Pause/Play Button
                                        if timeRemaining > 0 {
                                            Button(action: {
                                                isRunning.toggle()
                                            }) {
                                                ZStack {
                                                    Circle()
                                                        .fill(Color.ButtonYellow)
                                                        .frame(width: 100, height: 100)
                                                    Image(systemName: isRunning ? "pause.fill" : "play.fill")
                                                        .resizable()
                                                        .bold()
                                                        .scaledToFit()
                                                        .frame(width: 50, height: 50)
                                                        .foregroundColor(.black)
                                                }
                                                .opacity(0.8)
                                            }
                                        }
                                        // "I finished" Button
                                        Button(action: {
                                            // Immediately transition to finished state
                                            isRunning = false
                                            timeConsumed = DIYtimer.duration - timeRemaining
                                            timerFinished = true
                                            showConfetti = true
                                        }) {
                                            ZStack {
                                                Circle()
                                                    .fill(Color.ButtonYellow)
                                                    .frame(width: 100, height: 100)
                                                Image(systemName: "checkmark")
                                                    .resizable()
                                                    .bold()
                                                    .scaledToFit()
                                                    .frame(width: 50, height: 50)
                                                    .foregroundColor(.black)
                                            }
                                        }
                                    
                                        Button(action: {
                                            timeRemaining = DIYtimer.duration
                                            timerFinished = false
                                            showConfetti = false
                                            isRunning = true
                                            timeConsumed = 0
                                        }) {
                                            ZStack {
                                                Circle()
                                                    .fill(Color.ButtonYellow)
                                                    .frame(width: 100, height: 100)
                                                Image(systemName: "arrow.clockwise")
                                                    .resizable()
                                                    .bold()
                                                    .scaledToFit()
                                                    .frame(width: 50, height: 50)
                                                    .foregroundColor(.black)
                                            }
                                            .opacity(0.8)
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
                                    timeConsumed = DIYtimer.duration // consumed entire duration
                                }
                            }
                        }
                    )

                    .overlay(alignment: .bottomLeading) {
                        if timerFinished {
                            Button(action: {

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
                        delay: Double.random(in: 0...3),
                        availableHeight: geo.size.height
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
        let availableHeight: CGFloat

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
                        y = availableHeight + 20
                        rotation = Double.random(in: 0...360)
                    }
                }
        }
    }
}

#Preview {
    DIYtimer()
}
