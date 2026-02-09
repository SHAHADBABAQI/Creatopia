import SwiftUI

struct ShelfColumnView: View {
    
    let xPosition: CGFloat
    
    var body: some View {
        ZStack {
            Image("shelf1")
                .resizable()
                .frame(width: 572, height: 78)
                .position(x: xPosition, y: 165)
            
            Image("shelf1")
                .resizable()
                .frame(width: 572, height: 78)
                .position(x: xPosition, y: 390)
            
            Image("shelf1")
                .resizable()
                .frame(width: 572, height: 78)
                .position(x: xPosition, y: 614)
            
            Image("shelf1")
                .resizable()
                .frame(width: 572, height: 78)
                .position(x: xPosition, y: 839)
        }
    }
}
#Preview {
    ShelfColumnView(xPosition: 286)
}
