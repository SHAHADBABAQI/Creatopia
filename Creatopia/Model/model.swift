//
//  model.swift
//  Creatopia
//
//  Created by shahad khaled on 20/08/1447 AH.
//
import SwiftUI
import SwiftData

@Model
class MasterPiece: Identifiable {
    @Attribute(.unique) var id: UUID = UUID()
    var date: Date = Date()
    var imageData: Data

    init(imageData: Data) {
        self.imageData = imageData
    }

    init(date: Date, imageData: Data) {
        self.id = UUID()
        self.date = date
        self.imageData = imageData
    }
}
