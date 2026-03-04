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
            title: String(localized: "instruction.welcome.title"),
            description: String(localized: "instruction.welcome.description"),
            imageName: "welcomeImage"
        ),

        InstructionCard(
            title: String(localized: "instruction.table.title"),
            description: String(localized: "instruction.table.description"),
            imageName: "tableImage"
        ),

        InstructionCard(
            title: String(localized: "instruction.board.title"),
            description: String(localized: "instruction.board.description"),
            imageName: "boardImage"
        ),

        InstructionCard(
            title: String(localized: "instruction.box.title"),
            description: String(localized: "instruction.box.description"),
            imageName: "boxImage"
        ),

        InstructionCard(
            title: String(localized: "instruction.museum.title"),
            description: String(localized: "instruction.museum.description"),
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
