//
//  HomeView.swift
//  Creatopia
//
//  Created by Maram Ibrahim  on 21/08/1447 AH.
//


import SwiftUI

struct HomeView: View {

    @State private var moveTable = false
    @State private var moveShelf = false
    @State private var moveArt = false
    @State private var moveBox = false

    var body: some View {
        ZStack {

            Image("home")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            // Art
            Button {
                print("Art tapped")
            } label: {
                Image("Art")
                    .resizable()
                    .frame(width: 199, height: 247)
                    .rotationEffect(.degrees(moveArt ? 3 : -3))
                    .animation(.easeInOut(duration: 0.5).repeatForever(), value: moveArt)
            }
            .position(x: 115, y: 189)
            .onAppear { moveArt = true }

            // shelf
            Button {
                print("Shelf tapped")
            } label: {
                Image("shelf")
                    .resizable()
                    .frame(width: 270, height: 210)
                    .rotationEffect(.degrees(moveShelf ? 3 : -3))                    .animation(.easeInOut(duration: 0.5).repeatForever(), value: moveShelf)
            }
            .position(x: 1017, y: 211)
            .onAppear { moveShelf = true }

            // table
            Button {
            } label: {
                Image("table")
                    .resizable()
                    .frame(width: 690, height: 457)
                    .rotationEffect(.degrees(moveTable ? 2 : -2))                    .animation(.easeInOut(duration: 0.5).repeatForever(), value: moveTable)
            }
            .position(x: 702, y: 656)
            .onAppear { moveTable = true }

            // box
            Button {
                print("Box tapped")
            } label: {
                Image("box")
                    .resizable()
                    .frame(width: 290, height: 252)
                    .rotationEffect(.degrees(moveBox ? 3 : -3))                    .animation(.easeInOut(duration: 0.5).repeatForever(), value: moveBox)
            }
            .position(x: 180, y: 795)
            .onAppear { moveBox = true }
        }
    }
}

#Preview {
    HomeView()
}
