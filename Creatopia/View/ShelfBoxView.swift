import UniformTypeIdentifiers
import SwiftUI

struct ShelfBoxView: View {
    
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
                    
                    // LEFT SIDE
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
                    
                    
                    // RIGHT SIDE
                    VStack {
                        
                        ZStack {
                            shelfDrop(index: 0, x: 366, y: 140)
                            shelfDrop(index: 1, x: 366, y: 365)
                            shelfDrop(index: 2, x: 366, y: 589)
                            shelfDrop(index: 3, x: 366, y: 814)
                        }
                        
                        Spacer()
                        
                        // 🔥 الأسهم نفس مكانك بالضبط
                        HStack(spacing: 40) {
                            
                            Button(action: {
                                print("Left arrow tapped")
                            }) {
                                Image(systemName: "chevron.left")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 70, height: 70)
                                    .foregroundColor(.black)
                                    .padding()
                                    .background(Color(hexString: "FBDC7E"))
                                    .clipShape(Circle())
                                    .position(x: 120, y: 422)
                            }
                            
                            Button(action: {
                                print("Right arrow tapped")
                            }) {
                                Image(systemName: "chevron.right")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 70, height: 70)
                                    .foregroundColor(.black)
                                    .padding()
                                    .background(Color(hexString: "FBDC7E"))
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
            
            // HOME
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
            .background(Color(hexString: "FBDC7E"))
            .clipShape(Circle())
            .position(x: 100, y: 900)
        }
        .navigationBarHidden(true)
    }
    
    
    // MARK: - Shelf Drop
    
    func shelfDrop(index: Int, x: CGFloat, y: CGFloat) -> some View {
        ZStack {
            Image("shelf1")
                .resizable()
                .frame(width: 572, height: 78)
            
            if let item = viewModel.shelves[index] {
                RoundedRectangle(cornerRadius: 12)
                    .fill(randomColor(for: item))
                    .frame(width: 60, height: 60)
            }
        }
        .position(x: x, y: y)
        .onDrop(of: [UTType.text], isTargeted: nil) { providers in
            
            if let provider = providers.first {
                provider.loadObject(ofClass: NSString.self) { object, _ in
                    if let nsString = object as? NSString {
                        let idString = String(nsString)
                        if let item = viewModel.inboxItems.first(where: { $0.id.uuidString == idString }) {
                            DispatchQueue.main.async {
                                viewModel.placeItem(item, at: index)
                            }
                        }
                    }
                }
            }
            
            return true
        }
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

// MARK: - Color + Hex Support
private extension Color {
    init?(hexString: String) {
        // Remove leading '#' if present and ensure 6 or 8 hex chars
        var hex = hexString.trimmingCharacters(in: .whitespacesAndNewlines)
        if hex.hasPrefix("#") { hex.removeFirst() }
        guard hex.count == 6 || hex.count == 8, let intVal = UInt64(hex, radix: 16) else {
            return nil
        }
        let a, r, g, b: Double
        if hex.count == 8 {
            a = Double((intVal & 0xFF00_0000) >> 24) / 255.0
            r = Double((intVal & 0x00FF_0000) >> 16) / 255.0
            g = Double((intVal & 0x0000_FF00) >> 8) / 255.0
            b = Double(intVal & 0x0000_00FF) / 255.0
        } else {
            a = 1.0
            r = Double((intVal & 0xFF00_00) >> 16) / 255.0
            g = Double((intVal & 0x00FF_00) >> 8) / 255.0
            b = Double(intVal & 0x0000_FF) / 255.0
        }
        self = Color(red: r, green: g, blue: b, opacity: a)
    }
}

