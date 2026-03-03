import Foundation
import SwiftData
import CoreGraphics

@Model
class ShelfItem {
    
    var id: UUID
    var imageName: String
    
    // هل العنصر على رف؟ false → في البوكس
    var isOnShelf: Bool = false
    
    // إذا على رف → رقم الرف (0 - 3)
    var shelfIndex: Int? = nil
    
    // الصفحة الحالية
    var pageIndex: Int? = nil
    
    // مكان الصورة داخل البوكس
    var boxX: Double? = nil
    var boxY: Double? = nil
    
    init(imageName: String) {
        self.id = UUID()
        self.imageName = imageName
    }
}
