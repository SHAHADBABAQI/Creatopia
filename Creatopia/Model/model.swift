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
    var boxX: Double?
    var boxY: Double?
    
    // Shelf placement state
    var isOnShelf: Bool = false
    var shelfIndex: Int?
    var pageIndex: Int?

    init(imageData: Data) {
        self.imageData = imageData
    }

    init(date: Date, imageData: Data) {
        self.id = UUID()
        self.date = date
        self.imageData = imageData
    }
}
