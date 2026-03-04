//
//  RoomView.swift
//  Creatopia
//
//  Created by Maram Ibrahim  on 21/08/1447 AH.
//import SwiftUI
import SwiftUI

struct RoomView: View {

    struct InstructionCard: Identifiable {
        let id = UUID()
        let title: String
        let description: String
        let imageName: String
    }

    let instructionCards: [InstructionCard] = [
        InstructionCard(
            title: "Welcome, little creator!",
            description: "Let’s make something fun today!",
            imageName: "welcomeImage"
        ),

        InstructionCard(
            title: " The Magic Table",
            description: """
Tap the table and shake your device! 🫧

Magical bubbles will appear with surprise tools.
Find these tools around you and start building your very own monster! 👾

When you finish…
📸 Take a photo of your masterpiece!
""",
            imageName: "tableImage"
        ),

        InstructionCard(
            title: "The Creative Board",
            description: """
Love drawing?

Tap the board and start drawing right on your iPad!
Use your imagination and create anything you like 🌈✨

There are no rules — just creativity!
""",
            imageName: "boardImage"
        ),

        InstructionCard(
            title: "The Treasure Box",
            description: """
This is your special treasure box!

All your creations are saved here safely 💛
So you’ll never lose your amazing ideas.
""",
            imageName: "boxImage"
        ),

        InstructionCard(
            title: " Your Mini Museum",
            description: """
Welcome to your mini museum!

Place your masterpieces on the shelves
and proudly show everyone what you created 🌟

You are the artist!
""",
            imageName: "shelfImage"
        )
    ]

    @State private var instructionIndex = 0
    @State private var showInstructions = true
    @State private var showHome = false

    var body: some View {
        ZStack {
            if showHome {
                HomeView()
                    .transition(.opacity)
            } else {
                roomContent
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.4), value: showHome)
    }

    var roomContent: some View {
        ZStack {

            Image("room")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            if showInstructions && instructionIndex < instructionCards.count {

                let currentCard = instructionCards[instructionIndex]

                VStack(spacing: 25) {

                    Text(currentCard.title)
                        .font(.system(size: 44, weight: .bold))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)

                    Text(currentCard.description)
                        .font(.system(size: 37, weight: .semibold))
                        .foregroundColor(.white.opacity(0.95))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 30)

                    Image(currentCard.imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 160)
                        .cornerRadius(20)
                        .padding(.horizontal, 40)

                    HStack {
                        Spacer()

                        Button {
                            withAnimation {
                                instructionIndex += 1

                                if instructionIndex >= instructionCards.count {
                                    showInstructions = false

                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                        showHome = true
                                    }
                                }
                            }
                        } label: {
                            Circle()
                                .fill(Color.yellow)
                                .frame(width: 70, height: 70)
                                .overlay(
                                    Image(systemName: "arrow.right")
                                        .font(.system(size: 28, weight: .bold))
                                        .foregroundColor(.black)
                                )
                                .shadow(radius: 5)
                        }
                    }
                    .padding(.horizontal, 30)
                }
                .padding(.vertical, 40)
                .frame(maxWidth: 850)
                .background(
                    RoundedRectangle(cornerRadius: 30)
                        .fill(Color(red: 1.0, green: 0.70, blue: 0.85))
                )
                .shadow(radius: 15)
                .padding()
                .transition(.scale.combined(with: .opacity))
            }
        }
    }
}

#Preview {
    RoomView()
}
