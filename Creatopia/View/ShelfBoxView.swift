import SwiftUI

struct ShelfBoxView: View {
    
    @StateObject private var viewModel = ShelfBoxViewModel()
    
    var body: some View {
        GeometryReader { geo in
            HStack(spacing: 0) {
                
                ZStack {
                    
                    Color(hex: "CCB490")                        .frame(
                            width: geo.size.width / 2,
                            height: geo.size.height
                        )
                    
                    // Box في النص
                    Image("inbox")
                        .resizable()
                        .frame(width: 673, height: 529)
                        .position(
                            x: (geo.size.width / 2) / 2,
                            y: geo.size.height / 2
                        )
                }
                .frame(
                    width: geo.size.width / 2,
                    height: geo.size.height
                )
                
                //  النص الأيمن (Shelf)
                ZStack {
                    
                    // الخلفية
                    Image("bkshlf")
                        .resizable()
                        .scaledToFill()
                        .frame(
                            width: geo.size.width / 2,
                            height: geo.size.height
                        )
                        .clipped()
                    
                    ShelfColumnView(
                        xPosition: viewModel.currentShelfIndex == 0 ? 366 : 658
                    )
                    
                    // الأسهم
                    HStack {
                        Button {
                            viewModel.goPrevious()
                        } label: {
                            Image(systemName: "chevron.left")
                                .font(.largeTitle)
                                .foregroundColor(.black)
                        }
                        .disabled(viewModel.currentShelfIndex == 0)
                        
                        Spacer()
                        
                        Button {
                            viewModel.goNext()
                        } label: {
                            Image(systemName: "chevron.right")
                                .font(.largeTitle)
                                .foregroundColor(.black)
                        }
                        .disabled(viewModel.currentShelfIndex == viewModel.totalShelves - 1)
                    }
                    .padding(.horizontal, 24)
                }
                .frame(
                    width: geo.size.width / 2,
                    height: geo.size.height
                )
            }
            .ignoresSafeArea() // يغطي كامل الشاشة
        }
    }
}



#Preview {
    ShelfBoxView()
}
