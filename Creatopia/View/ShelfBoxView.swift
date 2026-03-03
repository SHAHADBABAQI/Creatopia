import SwiftUI
import SwiftData
import Combine
import UniformTypeIdentifiers


struct ShelfBoxView: View {
    
    @Query(sort: \ShelfItem.id, order: .forward) var items: [ShelfItem]
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @StateObject private var viewModel = ShelfBoxViewModel()
    
    @State private var draggingItem: ShelfItem?
    @State private var dragOffset: CGSize = .zero
    
    var body: some View {
        ZStack {
            Image("shelfbox")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            GeometryReader { geo in
                let fullWidth = geo.size.width
                let fullHeight = geo.size.height
                
                HStack(spacing: 0) {
                    
                    // LEFT SIDE (BOX)
                    ZStack {
                        Image("inbox")
                            .resizable()
                            .frame(width: 673, height: 529)
                        
                        ForEach(Array(items.filter { !$0.isOnShelf }), id: \.id) { item in
                            if let uiImage = UIImage(named: item.imageName) {
                                let isDragging = draggingItem?.id == item.id
                                let baseX = CGFloat(item.boxX ?? fullWidth / 4)
                                let baseY = CGFloat(item.boxY ?? fullHeight / 2)
                                
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 110, height: 110)
                                    .position(x: isDragging ? baseX + dragOffset.width : baseX,
                                              y: isDragging ? baseY + dragOffset.height : baseY)
                                    .zIndex(isDragging ? 100 : 1)
                                    .shadow(radius: 5)
                                    .gesture(
                                        DragGesture(coordinateSpace: .global)
                                            .onChanged { value in
                                                draggingItem = item
                                                dragOffset = value.translation
                                            }
                                            .onEnded { value in
                                                let dropPoint = value.location
                                                
                                                // إذا وقعت على رف
                                                if let shelfIndex = shelfIndexForDrag(position: dropPoint) {
                                                    viewModel.placePhotoOnShelf(item: item, shelfIndex: shelfIndex, modelContext: modelContext)
                                                } else {
                                                    viewModel.movePhotoBackToBox(item: item, dropX: dropPoint.x, dropY: dropPoint.y, modelContext: modelContext)
                                                }
                                                
                                                withAnimation(.easeOut) {
                                                    draggingItem = nil
                                                    dragOffset = .zero
                                                }
                                            }
                                    )
                            }
                        }
                    }
                    .frame(width: fullWidth / 2, height: fullHeight)
                    .position(x: fullWidth / 3.8, y: fullHeight / 2)
                    
                    // RIGHT SIDE (SHELVES)
                    VStack {
                        ZStack {
                            ForEach(0..<4) { index in
                                shelfView(index: index, x: 366, y: [140,365,589,814][index])
                            }
                        }
                        
                        Spacer()
                        
                        HStack(spacing: 40) {
                            paginationButton(icon: "chevron.left", action: viewModel.previousPage, posX: 120)
                            paginationButton(icon: "chevron.right", action: { viewModel.nextPage(totalPages: items.count) }, posX: 250)
                        }
                        .padding(.bottom, 40)
                    }
                    .frame(width: fullWidth / 2, height: fullHeight)
                }
            }
            
            homeButton
        }
        .navigationBarHidden(true)
    }
    
    // MARK: - Shelf
    func shelfView(index: Int, x: CGFloat, y: CGFloat) -> some View {
        ZStack(alignment: .topLeading) {
            Image("shelf1")
                .resizable()
                .frame(width: 572, height: 78)
            
            HStack(spacing: 10) {
                ForEach(Array(items.filter { $0.isOnShelf && $0.shelfIndex == index && $0.pageIndex == viewModel.currentPage }), id: \.id) { item in
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
        .position(x: x, y: y)
    }
    
    // MARK: - Helpers
    func shelfIndexForDrag(position: CGPoint) -> Int? {
        let yCenters: [CGFloat] = [140, 365, 589, 814]
        for (index, y) in yCenters.enumerated() {
            if position.y >= y - 50 && position.y <= y + 50 { return index }
        }
        return nil
    }
    
    var homeButton: some View {
        Button(action: { dismiss() }) {
            Image(systemName: "house.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 95, height: 95)
                .foregroundColor(.black)
        }
        .frame(width: 160, height: 151)
        .background(Color(red: 0.984, green: 0.863, blue: 0.494))
        .clipShape(Circle())
        .position(x: 100, y: 900)
    }
    
    func paginationButton(icon: String, action: @escaping ()->Void, posX: CGFloat) -> some View {
        Button(action: action) {
            Image(systemName: icon)
                .resizable()
                .scaledToFit()
                .frame(width: 70, height: 70)
                .foregroundColor(.black)
                .padding()
                .background(Color(red: 0.988, green: 0.863, blue: 0.494))
                .clipShape(Circle())
        }
        .position(x: posX, y: 422)
    }
}
#Preview {
    ShelfBoxView()
}
