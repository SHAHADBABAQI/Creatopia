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
                    .frame(width: 191, height: 247)
                    //.offset(x: moveArt ? -5 : 5)
                    .animation(.easeInOut(duration: 1).repeatForever(), value: moveArt)
            }
            .position(x: 100, y: 166)
            .onAppear { moveArt = true }

            // shelf
            Button {
                print("Shelf tapped")
            } label: {
                Image("shelf")
                    .resizable()
                    .frame(width: 240, height: 210)
                    //.offset(x: moveShelf ? -5 : 5)
                    .animation(.easeInOut(duration: 1.2).repeatForever(), value: moveShelf)
            }
            .position(x: 898, y: 190)
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
            .position(x: 616, y: 580)
            .onAppear { moveTable = true }

            // box
            Button {
                print("Box tapped")
            } label: {
                Image("box")
                    .resizable()
                    .frame(width: 290, height: 223)
                    //.offset(x: moveBox ? -4 : 4)
                    .animation(.easeInOut(duration: 1.3).repeatForever(), value: moveBox)
            }
            .position(x: 161, y: 700)
            .onAppear { moveBox = true }
        }
    }
}

#Preview {
    HomeView()
}
