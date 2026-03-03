import SwiftUI
import SwiftData

@Model
class MasterPiece: Identifiable {
    @Attribute(.unique) var id: UUID = UUID()
    var date: Date = Date()
    var imageData: Data
    
    // Box position
    var boxX: Double? = nil
    var boxY: Double? = nil
    
    // Shelf placement state
    var isOnShelf: Bool = false
    var shelfIndex: Int? = nil
    var pageIndex: Int? = nil

    init(imageData: Data) {
        self.id = UUID()
        self.imageData = imageData
    }

    init(date: Date, imageData: Data) {
        self.id = UUID()
        self.date = date
        self.imageData = imageData
    }
}
