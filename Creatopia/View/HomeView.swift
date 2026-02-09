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

            Image("room")
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
                    //.offset(x: moveArt ? -5 : 5)
                    .animation(.easeInOut(duration: 1).repeatForever(), value: moveArt)
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
                    //.offset(x: moveShelf ? -5 : 5)
                    .animation(.easeInOut(duration: 1.2).repeatForever(), value: moveShelf)
            }
            .position(x: 1022, y: 203)
            .onAppear { moveShelf = true }

            // table
            Button {
            } label: {
                Image("2")
                    .resizable()
                    .frame(width: 588, height: 420)
                    //.offset(x: moveTable ? -6 : 6)
                    .animation(.easeInOut(duration: 1).repeatForever(), value: moveTable)
            }
            .position(x: 770, y: 668)
            .onAppear { moveTable = true }

            // box
            Button {
                print("Box tapped")
            } label: {
                Image("box")
                    .resizable()
                    .frame(width: 290, height: 252)
                    //.offset(x: moveBox ? -4 : 4)
                    .animation(.easeInOut(duration: 1.3).repeatForever(), value: moveBox)
            }
            .position(x: 180, y: 795)
            .onAppear { moveBox = true }
        }
    }
}

#Preview {
    HomeView()
}
