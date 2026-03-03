import SwiftUI
import SwiftData
import Combine


class ShelfBoxViewModel: ObservableObject {
    
    @Published var currentPage: Int = 0
    
    // نقل عنصر إلى رف
    func placePhotoOnShelf(item: MasterPiece, shelfIndex: Int, modelContext: ModelContext) {
        item.isOnShelf = true
        item.shelfIndex = shelfIndex
        item.pageIndex = currentPage
        
        try? modelContext.save()
    }
    
    // إرجاع عنصر إلى البوكس مع حفظ مكانه
    func movePhotoBackToBox(item: MasterPiece, dropX: CGFloat, dropY: CGFloat, modelContext: ModelContext) {
        item.isOnShelf = false
        item.shelfIndex = nil
        item.pageIndex = nil
        item.boxX = Double(dropX)
        item.boxY = Double(dropY)
        
        try? modelContext.save()
    }
    
    func nextPage(totalPages: Int) {
        if currentPage < totalPages - 1 {
            currentPage += 1
        } else {
            currentPage += 1
        }
    }
    
    func previousPage() {
        if currentPage > 0 {
            currentPage -= 1
        }
    }
}
