import SwiftUI
import SwiftData
import Combine
import UniformTypeIdentifiers // هذي هي المكتبة اللي سألتي عنها

// MARK: - View
struct ShelfBoxView: View {
    
    // جلب الصور الحقيقية من SwiftData (شغل زميلتك)
    @Query(sort: \MasterPiece.date, order: .forward) var photos: [MasterPiece]
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    // استخدام الـ ViewModel الخاص بالرفوف
    @StateObject private var viewModel = LocalShelfBoxViewModel()
    
    @State private var draggingPhoto: MasterPiece?
    @State private var dragOffset: CGSize = .zero
    
    var body: some View {
        ZStack {
            // 1. الخلفية
            Image("shelfbox")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            GeometryReader { geo in
                let fullWidth = geo.size.width
                let fullHeight = geo.size.height
                
                HStack(spacing: 0) {
                    
                    // 2. الجانب الأيسر (صندوق الوارد - Inbox)
                    ZStack {
                        Image("inbox")
                            .resizable()
                            .frame(width: 673, height: 529)
                        
                        // عرض الصور المأخوذة من الكاميرا
                        ForEach(Array(photos.enumerated()), id: \.element.id) { index, photo in
                            if let uiImage = UIImage(data: photo.imageData) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 110, height: 110)
                                    .rotationEffect(.degrees(getRotation(for: index)))
                                    .shadow(radius: 5)
                                    // منطق السحب (Drag)
                                    .offset(draggingPhoto?.id == photo.id ? dragOffset : CGSize(width: getXOffset(for: index), height: getYOffset(for: index)))
                                    .zIndex(draggingPhoto?.id == photo.id ? 100 : 1)
                                    .gesture(
                                        DragGesture(coordinateSpace: .global)
                                            .onChanged { value in
                                                draggingPhoto = photo
                                                dragOffset = value.translation
                                            }
                                            .onEnded { value in
                                                let dropPoint = value.location
                                                
                                                // الحسابات اللي ضبطناها مع بعض للرفوف
                                                if let targetIndex = shelfIndexForDrag(position: dropPoint) {
                                                    let shelfStartX: CGFloat = 366 - (572 / 2)
                                                    let localX = dropPoint.x - shelfStartX
                                                    
                                                    // نقل الصورة من البوكس للرف
                                                    placePhotoOnShelf(photo, at: targetIndex, dropX: localX)
                                                }
                                                
                                                withAnimation(.easeOut) {
                                                    dragOffset = .zero
                                                    draggingPhoto = nil
                                                }
                                            }
                                    )
                            }
                        }
                    }
                    .frame(width: fullWidth / 2, height: fullHeight)
                    .position(x: fullWidth / 3.80, y: fullHeight / 2)
                    
                    // 3. الجانب الأيمن (الرفوف)
                    VStack {
                        ZStack {
                            shelfView(index: 0, x: 366, y: 140)
                            shelfView(index: 1, x: 366, y: 365)
                            shelfView(index: 2, x: 366, y: 589)
                            shelfView(index: 3, x: 366, y: 814)
                        }
                        
                        Spacer()
                        
                        // أزرار التنقل (يمين - يسار)
                        HStack(spacing: 40) {
                            paginationButton(icon: "chevron.left", action: viewModel.previousPage, posX: 120)
                            paginationButton(icon: "chevron.right", action: viewModel.nextPage, posX: 250)
                        }
                        .padding(.bottom, 40)
                    }
                    .frame(width: fullWidth / 2, height: fullHeight)
                }
            }
            
            // 4. زر العودة (Home)
            homeButton
        }
        .navigationBarHidden(true)
    }
    
    // MARK: - Shelf Logic
    func shelfView(index: Int, x: CGFloat, y: CGFloat) -> some View {
        ZStack(alignment: .topLeading) {
            Image("shelf1")
                .resizable()
                .frame(width: 572, height: 78)
            
            HStack(spacing: 10) {
                // الصور اللي استقرت على الرف
                ForEach(viewModel.shelfPages[viewModel.currentPage][index]) { photo in
                    if let uiImage = UIImage(data: photo.imageData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 55, height: 55)
                    }
                }
            }
            .padding(.leading, 20)
            .padding(.top, -30) // لرفع الصورة قليلاً فوق الرف
        }
        .position(x: x, y: y)
    }
    
    // دالة النقل الأساسية
    func placePhotoOnShelf(_ photo: MasterPiece, at index: Int, dropX: CGFloat) {
        viewModel.addPhotoToShelf(photo, shelfIndex: index, dropX: dropX)
        modelContext.delete(photo) // حذفها من صندوق الوارد في الداتا
        try? modelContext.save()
    }
    
    // دالة تحديد رقم الرف بناءً على مكان الإفلات
    func shelfIndexForDrag(position: CGPoint) -> Int? {
        let shelvesY: [CGFloat] = [140, 365, 589, 814]
        let tolerance: CGFloat = 100
        for (index, yCenter) in shelvesY.enumerated() {
            if position.y >= (yCenter - tolerance) && position.y <= (yCenter + tolerance) {
                return index
            }
        }
        return nil
    }

    // MARK: - Helpers (تنسيقات عشوائية لتوزيع الصور)
    func getRotation(for index: Int) -> Double {
        let rotations: [Double] = [-12, 6, -5, 10, -8, 4]
        return rotations[index % rotations.count]
    }
    
    func getXOffset(for index: Int) -> CGFloat {
        let offsets: [CGFloat] = [-60, 50, -20, 70, -40, 30]
        return offsets[index % offsets.count]
    }
    
    func getYOffset(for index: Int) -> CGFloat {
        let offsets: [CGFloat] = [-40, 20, -60, 40, -30, 50]
        return offsets[index % offsets.count]
    }

    var homeButton: some View {
        Button(action: { dismiss() }) {
            Image(systemName: "house.fill").resizable().scaledToFit().frame(width: 95, height: 95).foregroundColor(.black)
        }
        .frame(width: 160, height: 151).background(Color(red: 0.984, green: 0.863, blue: 0.494)).clipShape(Circle())
        .position(x: 100, y: 900)
    }

    func paginationButton(icon: String, action: @escaping () -> Void, posX: CGFloat) -> some View {
        Button(action: action) {
            Image(systemName: icon).resizable().scaledToFit().frame(width: 70, height: 70).foregroundColor(.black)
                .padding().background(Color(red: 0.988, green: 0.863, blue: 0.494)).clipShape(Circle())
        }
        .position(x: posX, y: 422)
    }
}

// MARK: - ViewModel
final class LocalShelfBoxViewModel: ObservableObject {
    @Published var shelfPages: [[[MasterPiece]]] = [Array(repeating: [], count: 4)]
    @Published var currentPage = 0
    
    func addPhotoToShelf(_ photo: MasterPiece, shelfIndex: Int, dropX: CGFloat) {
        let itemWidth: CGFloat = 60
        let insertIndex = Int(dropX / itemWidth)
        let safeIndex = min(max(insertIndex, 0), shelfPages[currentPage][shelfIndex].count)
        shelfPages[currentPage][shelfIndex].insert(photo, at: safeIndex)
    }
    
    func nextPage() {
        if currentPage == shelfPages.count - 1 {
            shelfPages.append(Array(repeating: [], count: 4))
        }
        currentPage += 1
    }
    
    func previousPage() {
        if currentPage > 0 { currentPage -= 1 }
    }
}

// MARK: - Preview
#Preview {
    ShelfBoxView()
}
