import SwiftUI
import SwiftData

struct ShelfBoxView: View {
    @Query(sort: \MasterPiece.date, order: .forward) var photos: [MasterPiece]
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @State private var showCamera = false
    @State private var isProcessing = false

    var body: some View {
        ZStack {
            
            // الخلفية
            Image("shelfbox")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            GeometryReader { geo in
                HStack(spacing: 0) {
                    
                    // LEFT HALF - INBOX WITH PHOTOS
                    ZStack {
                        Image("inbox")
                            .resizable()
                            .frame(width: 673, height: 529)
                        
                        // Display photos as scattered papers INSIDE the inbox
                        ForEach(Array(photos.enumerated()), id: \.element.id) { index, photo in
                            if let image = UIImage(data: photo.imageData) {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 120, height: 120)
                                    .rotationEffect(.degrees(getRotation(for: index)))
                                    .offset(x: getXOffset(for: index),
                                            y: getYOffset(for: index))
                                    .shadow(radius: 5)
                            }
                        }
                    }
                    .frame(width: geo.size.width / 2, height: geo.size.height)
                    .position(x: geo.size.width / 3.80, y: geo.size.height / 2)
                    
                    // RIGHT HALF
                    VStack {
                        ZStack {
                            // الرفوف
                            shelf(x: 366, y: 140)
                            shelf(x: 366, y: 365)
                            shelf(x: 366, y: 589)
                            shelf(x: 366, y: 814)
                        }
                        
                        Spacer()
                        
                        // أزرار الأسهم
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
                    .frame(width: geo.size.width / 2, height: geo.size.height)
                }
            }
            
            // 🔥 Camera Button
            Button(action: {
                showCamera = true
            }) {
                ZStack {
                    Circle()
                        .fill(Color(hexString: "FBDC7E"))
                        .frame(width: 100, height: 100)
                    Image(systemName: "camera.fill")
                        .resizable()
                        .frame(width: 60, height: 60)
                        .foregroundColor(.black)
                }
            }
            .position(x: 350, y: 900)
            .sheet(isPresented: $showCamera) {
                CameraView(
                    onImagePicked: { _ in
                        isProcessing = true
                    },
                    onProcessedImage: { processedImage in
                        if let data = processedImage.pngData() {
                            let newPhoto = MasterPiece(imageData: data)
                            modelContext.insert(newPhoto)
                            try? modelContext.save()
                        }
                        isProcessing = false
                    }
                )
            }

            // 🔥 Home Button
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

    // MARK: - Shelf Component
    func shelf(x: CGFloat, y: CGFloat) -> some View {
        Image("shelf1")
            .resizable()
            .frame(width: 572, height: 78)
            .position(x: x, y: y)
    }
    
    // MARK: - Photo Positioning Helpers
    // These create consistent but scattered positions for photos
    func getRotation(for index: Int) -> Double {
        let rotations: [Double] = [-15, -8, 5, 12, -10, 7, -5, 10]
        return rotations[index % rotations.count]
    }
    
    func getXOffset(for index: Int) -> CGFloat {
        let offsets: [CGFloat] = [-80, 60, -40, 80, -60, 40, -100, 70]
        return offsets[index % offsets.count]
    }
    
    func getYOffset(for index: Int) -> CGFloat {
        let offsets: [CGFloat] = [-60, 40, -80, 60, -40, 80, -50, 70]
        return offsets[index % offsets.count]
    }
}


// MARK: - HEX Color Support
extension Color {
    init(hexString: String) {
        let scanner = Scanner(string: hexString)
        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)
        let r = Double((rgb >> 16) & 0xFF) / 255
        let g = Double((rgb >> 8) & 0xFF) / 255
        let b = Double(rgb & 0xFF) / 255
        self.init(red: r, green: g, blue: b)
    }
}

// MARK: - Preview with ModelContainer
#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: MasterPiece.self, configurations: config)

        // Add sample data for testing
        let sampleImage = UIImage(systemName: "star.fill")!
        if let data = sampleImage.pngData() {
            let sample1 = MasterPiece(imageData: data)
            let sample2 = MasterPiece(imageData: data)
            container.mainContext.insert(sample1)
            container.mainContext.insert(sample2)
        }

        return ShelfBoxView()
            .modelContainer(container)
    } catch {
        return ShelfBoxView()
    }
}
