//
//  CreatopiaApp.swift
//  Creatopia
//
//  Created by shahad khaled on 16/08/1447 AH.
//

import SwiftUI
import SwiftData

@main
struct CreatopiaApp: App {
    var body: some Scene {
        WindowGroup {
            start()
        }
        .modelContainer(for: MasterPiece.self)
    }
}
