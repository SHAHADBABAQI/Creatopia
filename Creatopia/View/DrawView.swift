import SwiftUI
import SwiftData

struct DrawView: View {
    @Environment(\.modelContext) private var modelContext
    
    @State private var strokes: [Stroke] = []
    @State private var currentStroke: Stroke?
    
    @State private var selectedColor: Color = .black
    @State private var lineWidth: CGFloat = 6
    @State private var isEraser: Bool = false
    
    @State private var isProcessing = false
    @State private var navigateToShelfBox = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                
                // Canvas
                Canvas { context, size in
                    
                    for stroke in strokes {
                        var path = Path()
                        guard let first = stroke.points.first else { continue }
                        
                        path.move(to: first)
                        
                        for point in stroke.points.dropFirst() {
                            path.addLine(to: point)
                        }
                        
                        context.stroke(
                            path,
                            with: .color(stroke.color),
                            lineWidth: stroke.lineWidth
                        )
                    }
                    
                    if let stroke = currentStroke {
                        var path = Path()
                        
                        if let first = stroke.points.first {
                            path.move(to: first)
                            
                            for point in stroke.points.dropFirst() {
                                path.addLine(to: point)
                            }
                            
                            context.stroke(
                                path,
                                with: .color(stroke.color),
                                lineWidth: stroke.lineWidth
                            )
                        }
                    }
                }
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { value in
                            
                            if currentStroke == nil {
                                
                                currentStroke = Stroke(
                                    points: [value.location],
                                    color: isEraser ? .white : selectedColor,
                                    lineWidth: lineWidth
                                )
                                
                            } else {
                                currentStroke?.points.append(value.location)
                            }
                        }
                        .onEnded { _ in
                            
                            if let stroke = currentStroke {
                                strokes.append(stroke)
                            }
                            
                            currentStroke = nil
                        }
                )
                .ignoresSafeArea()
                
                
                // Toolbar
                VStack {
                    Spacer()
                    
                    HStack(spacing: 14) {
                        
                        colorButton(.black)
                        colorButton(.white)
                        colorButton(.red)
                        colorButton(.blue)
                        colorButton(.green)
                        colorButton(.yellow)
                        colorButton(.purple)
                        colorButton(.orange)
                        
                        Divider().frame(height: 24)
                        
                        Button {
                            isEraser.toggle()
                        } label: {
                            Image(systemName: "eraser")
                                .foregroundColor(isEraser ? .red : .black)
                        }
                        
                        Slider(value: $lineWidth, in: 2...14)
                            .frame(width: 100)
                        
                        Button {
                            saveDrawing()
                        } label: {
                            
                            ZStack {
                                Circle()
                                    .fill(Color.yellow)
                                    .frame(width: 64, height: 64)
                                
                                Image(systemName: "checkmark")
                                    .font(.system(size: 28, weight: .bold))
                                    .foregroundColor(.black)
                            }
                        }
                        .buttonStyle(.plain)
                    }
                    .padding()
                    .background(Color(white: 0.9).opacity(0.7))
                }
                
                
                // Processing overlay
                if isProcessing {
                    
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()
                    
                    VStack(spacing: 20) {
                        
                        ProgressView()
                            .scaleEffect(2)
                            .tint(.white)
                        
                        Text("Processing drawing...")
                            .foregroundColor(.white)
                            .font(.headline)
                    }
                    .padding(40)
                    .background(Color.yellow)
                    .cornerRadius(20)
                }
                
                
                // Navigation
                NavigationLink(
                    destination: ShelfBoxView(),
                    isActive: $navigateToShelfBox
                ) {
                    EmptyView()
                }
                .hidden()
            }
        }
        .navigationBarBackButtonHidden(true)
    }
    
    
    // MARK: Color Button
    private func colorButton(_ color: Color) -> some View {
        
        Circle()
            .fill(color)
            .frame(width: 24, height: 24)
            .overlay(
                Circle()
                    .stroke(
                        selectedColor == color && !isEraser ? Color.black : .clear,
                        lineWidth: 2
                    )
            )
            .onTapGesture {
                selectedColor = color
                isEraser = false
            }
    }
    
    
    // MARK: Save Drawing
    private func saveDrawing() {
        
        guard !strokes.isEmpty || currentStroke != nil else { return }
        
        isProcessing = true
        
        var allStrokes = strokes
        
        if let current = currentStroke {
            allStrokes.append(current)
        }
        
        let screenSize = UIScreen.main.bounds.size
        
        let image = exportDrawing(
            strokes: allStrokes,
            size: screenSize
        )
        
        if let data = image.pngData() {
            
            let newPhoto = MasterPiece(imageData: data)
            
            // يظهر داخل الصندوق
            newPhoto.isOnShelf = false
            newPhoto.pageIndex = 0
            
            // مكان داخل الصندوق
            newPhoto.boxX = Double.random(in: 150...500)
            newPhoto.boxY = Double.random(in: 250...650)
            
            modelContext.insert(newPhoto)
            
            do {
                try modelContext.save()
                print("Drawing saved successfully")
            } catch {
                print("Save error:", error)
            }
        }
        
        // تنظيف اللوحة
        strokes.removeAll()
        currentStroke = nil
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            
            isProcessing = false
            navigateToShelfBox = true
        }
    }
    
    
    // MARK: Export Drawing
    private func exportDrawing(
        strokes: [Stroke],
        size: CGSize
    ) -> UIImage {
        
        let renderer = UIGraphicsImageRenderer(size: size)
        
        return renderer.image { ctx in
            
            UIColor.white.setFill()
            ctx.fill(CGRect(origin: .zero, size: size))
            
            for stroke in strokes {
                
                guard let first = stroke.points.first else { continue }
                
                let path = UIBezierPath()
                path.move(to: first)
                
                for point in stroke.points.dropFirst() {
                    path.addLine(to: point)
                }
                
                path.lineWidth = stroke.lineWidth
                UIColor(stroke.color).setStroke()
                path.stroke()
            }
        }
    }
}


// Stroke Model
struct Stroke {
    
    var points: [CGPoint]
    var color: Color
    var lineWidth: CGFloat
}


// Preview
#Preview {
    
    do {
        
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(
            for: MasterPiece.self,
            configurations: config
        )
        
        return DrawView()
            .modelContainer(container)
        
    } catch {
        
        return DrawView()
    }
}
