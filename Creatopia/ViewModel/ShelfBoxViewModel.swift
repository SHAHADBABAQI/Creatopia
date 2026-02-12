import Combine
import SwiftUI

class ShelfBoxViewModel: ObservableObject {
    
    @Published var inboxItems: [ShelfItem] = [
        ShelfItem(imageName: "item1"),
        ShelfItem(imageName: "item2"),
        ShelfItem(imageName: "item3"),
        ShelfItem(imageName: "item4")
    ]
    
    @Published var shelves: [ShelfItem?] = Array(repeating: nil, count: 4)
    
    func placeItem(_ item: ShelfItem, at index: Int) {
        if shelves[index] == nil {
            shelves[index] = item
            inboxItems.removeAll { $0 == item }
        }
    }
}

