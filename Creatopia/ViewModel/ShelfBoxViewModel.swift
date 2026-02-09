import Foundation
import Combine

class ShelfBoxViewModel: ObservableObject {
    
    let totalShelves = 2
    
    @Published var currentShelfIndex: Int = 0
    
    func goNext() {
        guard currentShelfIndex < totalShelves - 1 else { return }
        currentShelfIndex += 1
    }
    
    func goPrevious() {
        guard currentShelfIndex > 0 else { return }
        currentShelfIndex -= 1
    }
}
