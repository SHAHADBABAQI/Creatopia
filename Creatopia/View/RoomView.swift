//
//  RoomView.swift
//  Creatopia
//
//  Created by Maram Ibrahim  on 21/08/1447 AH.
//

import SwiftUI

struct RoomView: View {

    struct GameItem: Identifiable {
        let id = UUID()
        let name: String
        let instruction: String
        let position: CGPoint
        let size: CGSize
    }

    let gameItems: [GameItem] = [
        GameItem(name: "طاولة", instruction: "Shake it and see the magic!", position: CGPoint(x: 808, y: 734), size: CGSize(width: 300, height: 180)),
        GameItem(name: "رف", instruction: "Put your things here\nKeep them nice and tidy", position: CGPoint(x: 1019, y: 281), size: CGSize(width: 150, height: 120)),
        GameItem(name: "لوحة", instruction: "Draw your ideas!", position: CGPoint(x: 144, y: 384), size: CGSize(width: 200, height: 150)),
        GameItem(name: "صندوق", instruction: "All your things are here!\nTap to explore", position: CGPoint(x: 259, y: 882), size: CGSize(width: 150, height: 150))
    ]

    @State private var instructionIndex = 0
    @State private var showInstructions = true

    var body: some View {
        ZStack {

            // Background image
            Image("start")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            ForEach(gameItems) { item in
                Button {
                } label: {
                    Color.clear
                        .frame(width: item.size.width, height: item.size.height)
                }
                .position(item.position)
            }

            if showInstructions && instructionIndex < gameItems.count {
                let currentItem = gameItems[instructionIndex]

                HStack(spacing: 15) {

                    Text(currentItem.instruction)
                        .font(.system(size: 24, weight: .semibold))
                    
                        .foregroundColor(.black)
                        .multilineTextAlignment(.leading)

                    Button(action: {
                        let key = "seen_\(currentItem.name)"
                        UserDefaults.standard.set(true, forKey: key)
                        instructionIndex += 1
                        if instructionIndex >= gameItems.count {
                            showInstructions = false
                        }
                    }) {
                        Image(systemName: "arrow.right.circle.fill")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .foregroundColor(.yellow)
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(15)
                .shadow(radius: 5)
                .position(x: currentItem.position.x,
                          y: currentItem.position.y - currentItem.size.height/2 - 60)
            }
        }
        .navigationBarTitle("Home", displayMode: .inline)
    }
}
#Preview {
    HomeView()
}
