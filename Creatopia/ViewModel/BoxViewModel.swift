import SwiftUI
import Combine

final class BoxViewModel: ObservableObject {

    // MARK: - iPad 12.9 exact size
    let screenWidth: CGFloat = 1366
    let screenHeight: CGFloat = 1024

    // MARK: - Background
    let backgroundColor = Color(hex: "#A4DBFC")
    let stripeColor = Color(hex: "#C0E7FD")

    let stripeWidth: CGFloat = 97
    let stripeHeight: CGFloat = 1024

    let stripeXPositions: [CGFloat] = [
        86, 242, 398, 554, 710, 866, 1022, 1178
    ]

    // MARK: - Shelf sizes (NEW)
    let shelfWidth: CGFloat = 542
    let shelfHeight: CGFloat = 46

    let shadowWidth: CGFloat = 572
    let shadowHeight: CGFloat = 78

    // MARK: - Shelf Position (FIRST ONE)
    let startX: CGFloat = 74
    let startY: CGFloat = 165

    // MARK: - Grid
    let rows: Int = 4
    let columns: Int = 2

    let horizontalSpacing: CGFloat = 80
    let verticalSpacing: CGFloat = 110

    // MARK: - Colors
    let shelfColor: Color = .white
    let shadowColor = Color(red: 110/255, green: 147/255, blue: 169/255)

    // MARK: - Shadow Offset (tilted right)
    let shadowOffsetX: CGFloat = 20
    let shadowOffsetY: CGFloat = 18
}
