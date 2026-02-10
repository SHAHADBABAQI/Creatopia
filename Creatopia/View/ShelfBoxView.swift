import SwiftUI

struct ShelfBoxView: View {
    var body: some View {
        ZStack {
            // الخلفية
            Image("shelfbox")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            GeometryReader { geo in
                HStack(spacing: 0) {
                    // LEFT HALF
                    ZStack {
                        Image("inbox")
                            .resizable()
                            .frame(width: 673, height: 529)
                    }
                    .frame(width: geo.size.width / 2, height: geo.size.height)
                    .position(x: geo.size.width / 3.80, y: geo.size.height / 2)

                    // RIGHT HALF
                    VStack {
                        ZStack {
                            // رفوف
                            shelf(x: 366, y: 140)
                            shelf(x: 366, y: 365)
                            shelf(x: 366, y: 589)
                            shelf(x: 366, y: 814)
                        }
                        Spacer() // يدفع الأزرار للأسفل

                        // أزرار أسفل النص
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
                                    .position(x: 120, y:422)
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
                                    .position(x: 250, y:422)

                            }
                        }
                        .padding(.bottom, 40) // مسافة من أسفل الشاشة
                    }
                    .frame(width: geo.size.width / 2, height: geo.size.height)
                }
            }
        }
    }

    // MARK: - Shelf Component
    func shelf(x: CGFloat, y: CGFloat) -> some View {
        Image("shelf1")
            .resizable()
            .frame(width: 572, height: 78)
            .position(x: x, y: y)
    }
}

// MARK: - HEX Color Support
extension Color {
    init(hexString: String) {
        let scanner = Scanner(string: hexString)
        scanner.currentIndex = hexString.startIndex
        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)
        let r = Double((rgb >> 16) & 0xFF) / 255
        let g = Double((rgb >> 8) & 0xFF) / 255
        let b = Double(rgb & 0xFF) / 255
        self.init(red: r, green: g, blue: b)
    }
}

#Preview {
    ShelfBoxView()
}
