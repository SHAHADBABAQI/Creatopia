//
//  start.swift
//  Creatopia
//
//  Created by Maram Ibrahim  on 21/08/1447 AH.
//

import SwiftUI

struct start: View {
    
    @State private var showRoom = false
    var body: some View {
        if showRoom {
            RoomView()
        } else {
            ZStack {
                // Background image
                Image("start")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()

                // Title centered
                Text("Creatopia")
                    .font(.system(size: 128, weight: .bold))

                // Play button pinned to bottom
                VStack {
                    Spacer()
                    
                    Button {
                        showRoom = true
                    } label: {
                        Circle()
                            .fill(Color.yellow)
                            .frame(width: 110, height: 110)
                            .overlay(
                                Image(systemName: "play.fill")
                                    .font(.system(size: 40))
                                    .foregroundColor(.black)
                            )
                    }
                    .padding(.bottom, 80)
                }
            }
        }
    }
}


#Preview {
    start()
}
