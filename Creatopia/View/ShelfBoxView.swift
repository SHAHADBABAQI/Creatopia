import UniformTypeIdentifiers
import SwiftUI
import SwiftData

struct ShelfBoxView: View {
    @Query(sort: \MasterPiece.date, order: .forward) var photos: [MasterPiece]
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = ShelfBoxViewModel()
    
    var body: some View {
        ZStack {
            
            Image("shelfbox")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            GeometryReader { geo in
                HStack(spacing: 0) {
                    
                    // LEFT SIDE (Inbox)
                    ZStack {
                        Image("inbox")
                            .resizable()
                            .frame(width: 673, height: 529)
                        
                        HStack(spacing: 20) {
                            ForEach(viewModel.inboxItems) { item in
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(randomColor(for: item))
                                    .frame(width: 70, height: 70)
                                    .onDrag {
                                        NSItemProvider(object: item.id.uuidString as NSString)
                                    }
                            }
                        }
                    }
                    .frame(width: geo.size.width / 2,
                           height: geo.size.height)
                    .position(x: geo.size.width / 3.80,
                              y: geo.size.height / 2)
                    
                    
                    // RIGHT SIDE (Shelves)
                    VStack {
                        
                        ZStack {
                            shelfDrop(index: 0, x: 366, y: 140)
                            shelfDrop(index: 1, x: 366, y: 365)
                            shelfDrop(index: 2, x: 366, y: 589)
                            shelfDrop(index: 3, x: 366, y: 814)
                        }
                        
                        Spacer()
                        
                        // 🔥 الأسهم نفس مكانك بالضبط (بس غيرت الأكشن)
                        HStack(spacing: 40) {
                            Button(action: {
                                viewModel.previousPage()
                            }) {
                                Image(systemName: "chevron.left")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 70, height: 70)
                                    .foregroundColor(.black)
                                    .padding()
                                    .background(Color(red: 0.988, green: 0.863, blue: 0.494))
                                    .clipShape(Circle())
                                    .position(x: 120, y: 422)
                            }
                            
                            Button(action: {
                                viewModel.nextPage()
                            }) {
                                Image(systemName: "chevron.right")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 70, height: 70)
                                    .foregroundColor(.black)
                                    .padding()
                                    .background(Color(red: 0.988, green: 0.863, blue: 0.494))
                                    .clipShape(Circle())
                                    .position(x: 250, y: 422)
                            }
                        }
                        .padding(.bottom, 40)
                    }
                    .frame(width: geo.size.width / 2,
                           height: geo.size.height)
                }
            }
            
            // HOME BUTTON
            Button(action: {
                dismiss()
            }) {
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
            
            // Processing overlay
            if isProcessing {
                ZStack {
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()
                    
                    VStack(spacing: 20) {
                        ProgressView()
                            .scaleEffect(2)
                            .tint(.white)
                        Text("Processing photo...")
                            .font(.headline)
                            .foregroundColor(.white)
                    }
                    .padding(40)
                    .background(Color(hexString: "FBDC7E"))
                    .cornerRadius(20)
                }
            }
        }
        .navigationBarHidden(true)
    }
    
    
    // MARK: - Shelf Drop (الدروب فوق الرف فقط + أكثر من عنصر)
    
    func shelfDrop(index: Int, x: CGFloat, y: CGFloat) -> some View {
        ZStack(alignment: .topLeading) {
            
            Image("shelf1")
                .resizable()
                .frame(width: 572, height: 78)
            
            HStack(spacing: 10) {
                ForEach(viewModel.currentShelves[index]) { item in
                    RoundedRectangle(cornerRadius: 8)
                        .fill(randomColor(for: item))
                        .frame(width: 45, height: 45)
                }
            }
            .padding(.leading, 20)
            .padding(.top, -22) // 🔥 يخليها على أعلى حد الرف
            
        }
        .position(x: x, y: y)
        .overlay(
            Rectangle()
                .fill(Color.clear)
                .frame(width: 572, height: 30) // 🔥 منطقة الدروب أعلى الرف فقط
                .offset(y: -25)
                .onDrop(of: [UTType.text], isTargeted: nil) { providers in
                    
                    if let provider = providers.first {
                        provider.loadObject(ofClass: NSString.self) { object, _ in
                            if let nsString = object as? NSString {
                                let idString = String(nsString)
                                
                                if let item = viewModel.inboxItems.first(where: {
                                    $0.id.uuidString == idString
                                }) {
                                    DispatchQueue.main.async {
                                        viewModel.placeItem(item, at: index)
                                    }
                                }
                            }
                        }
                    }
                    
                    return true
                }
        )
    }
    
    
    func randomColor(for item: ShelfItem) -> Color {
        switch item.imageName {
        case "item1": return .red
        case "item2": return .blue
        case "item3": return .green
        case "item4": return .orange
        default: return .gray
        }
    }
}
#Preview {
    ShelfBoxView()
}
