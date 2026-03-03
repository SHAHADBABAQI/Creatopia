import SwiftUI
import SwiftData

struct ShelfView: View {
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @StateObject private var viewModel = ShelfBoxViewModel()
    
    @Query(sort: \ShelfItem.id, order: .forward) var items: [ShelfItem]
    
    var body: some View {
        ZStack {
            Image("bkshlf")
                .resizable()
                .scaledToFit()
                .ignoresSafeArea()
            
            // رفوف
            ZStack {
                let xPositions: [CGFloat] = [366, 990]
                let yPositions: [CGFloat] = [165, 390, 614, 839]
                
                ForEach(xPositions, id: \.self) { xPos in
                    ForEach(yPositions, id: \.self) { yPos in
                        let shelfIndex = yPositions.firstIndex(of: yPos)!
                        Image("shelf1")
                            .resizable()
                            .frame(width: 572, height: 78)
                            .position(x: xPos, y: yPos)
                        
                        HStack(spacing: 10) {
                            ForEach(items.filter { $0.isOnShelf && $0.shelfIndex == shelfIndex && $0.pageIndex == viewModel.currentPage }) { item in
                                if let uiImage = UIImage(named: item.imageName) {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 55, height: 55)
                                        .gesture(
                                            DragGesture(coordinateSpace: .global)
                                                .onEnded { value in
                                                    let drop = value.location
                                                    if drop.x <= UIScreen.main.bounds.width / 2 {
                                                        viewModel.movePhotoBackToBox(item: item, dropX: drop.x, dropY: drop.y, modelContext: modelContext)
                                                    }
                                                }
                                        )
                                }
                            }
                        }
                        .padding(.leading, 20)
                        .padding(.top, -30)
                    }
                }
            }
            
            // زر الرجوع
            VStack {
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 25, height: 25)
                            .foregroundColor(.black)
                            .frame(width: 70, height: 70)
                            .background(Color(red: 0.988, green: 0.863, blue: 0.494))
                            .clipShape(Circle())
                            .shadow(radius: 5)
                    }
                    Spacer()
                }
                Spacer()
            }
            .padding(.leading, 40)
            .padding(.top, 40)
        }
        .navigationBarHidden(true)
    }
}
#Preview {
    ShelfView()
}
