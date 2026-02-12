import SwiftUI
import Combine

class ShelfGameViewModel: ObservableObject {
    
    struct PlacedShelfItem: Identifiable {
        let id = UUID()
        var item: ShelfItem
        var position: CGPoint
        var startPosition: CGPoint
        var isPlaced: Bool = false
    }
    
    // العناصر داخل البوكس
    @Published var items: [PlacedShelfItem] = []
    
    // رقم صفحة الرفوف
    @Published var currentShelfPage: Int = 0
    
    // أماكن الرفوف (يمين الشاشة)
    var shelfPositions: [[CGPoint]] = [
        [
            CGPoint(x: 990, y: 165),
            CGPoint(x: 990, y: 390),
            CGPoint(x: 990, y: 614),
            CGPoint(x: 990, y: 839)
        ],
        [
            CGPoint(x: 990, y: 200),
            CGPoint(x: 990, y: 425),
            CGPoint(x: 990, y: 650),
            CGPoint(x: 990, y: 875)
        ]
    ]
    
    init() {
        setupItems()
    }
    
    func setupItems() {
        items = [
            PlacedShelfItem(
                item: ShelfItem(imageName: "item1"),
                position: CGPoint(x: 250, y: 500),
                startPosition: CGPoint(x: 250, y: 500)
            ),
            PlacedShelfItem(
                item: ShelfItem(imageName: "item2"),
                position: CGPoint(x: 350, y: 600),
                startPosition: CGPoint(x: 350, y: 600)
            )
        ]
    }
    
    // تغيير صفحة الرفوف
    func nextShelf() {
        currentShelfPage = (currentShelfPage + 1) % shelfPositions.count
    }
    
    // التحقق عند الإفلات
    func checkDrop(for index: Int) {
        let itemPosition = items[index].position
        let shelves = shelfPositions[currentShelfPage]
        
        for shelf in shelves {
            let shelfFrame = CGRect(x: shelf.x - 250,
                                    y: shelf.y - 40,
                                    width: 500,
                                    height: 100)
            
            if shelfFrame.contains(itemPosition) {
                // ✨ يوقف على بداية الرف بالضبط
                items[index].position = CGPoint(
                    x: shelf.x - 200,
                    y: shelf.y - 25
                )
                items[index].isPlaced = true
                return
            }
        }
        
        // ❌ إذا ما انحط فوق رف يرجع للبوكس
        withAnimation(.easeInOut) {
            items[index].position = items[index].startPosition
        }
    }
}

