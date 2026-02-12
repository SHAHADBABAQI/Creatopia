import SwiftUI
import Combine

class ShelfBoxViewModel: ObservableObject {
    
    @Published var inboxItems: [ShelfItem] = [
        ShelfItem(imageName: "item1"),
        ShelfItem(imageName: "item2"),
        ShelfItem(imageName: "item3"),
        ShelfItem(imageName: "item4")
    ]
    
    // كل صفحة فيها 4 رفوف
    @Published var shelfPages: [[[ShelfItem]]] = [
        Array(repeating: [], count: 4)
    ]
    
    @Published var currentPage = 0
    
    var currentShelves: [[ShelfItem]] {
        shelfPages[currentPage]
    }
    
    func placeItem(_ item: ShelfItem, at shelfIndex: Int) {
        shelfPages[currentPage][shelfIndex].append(item)
        inboxItems.removeAll { $0 == item }
    }
    
    func nextPage() {
        if currentPage == shelfPages.count - 1 {
            // نسوي صفحة جديدة
            shelfPages.append(Array(repeating: [], count: 4))
        }
        currentPage += 1
    }
    
    func previousPage() {
        if currentPage > 0 {
            currentPage -= 1
        }
    }
}
