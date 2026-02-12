//
//  model.swift
//  Creatopia
//
//  Created by shahad khaled on 20/08/1447 AH.
//
import SwiftUI
import SwiftData
//need init
@Model
class MasterPiece: Identifiable {
    //var id:UUID
    @Attribute(.unique) var id: UUID
    var date: Date
    var imageData: Data
    //i have to intilise all data i can not init some of data
    init( date: Date, imageData: Data) {
        self.id = UUID()
        self.date = date
        self.imageData = imageData
    }
    
    
}//class
