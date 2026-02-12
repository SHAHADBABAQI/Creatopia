import SwiftUI

struct ShelfView: View {
    
    @StateObject private var viewModel = ShelfViewModel()
    @Environment(\.dismiss) private var dismiss   // 👈 هذا مهم
    
    var body: some View {
        ZStack {
            
            // الخلفية
            Image("bkshlf")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea()
            
            // الرفوف
            ZStack {
                
                // العمود اليسار
                Image("shelf1")
                    .resizable()
                    .frame(width: 572, height: 78)
                    .position(x: 366, y: 165)
                
                Image("shelf1")
                    .resizable()
                    .frame(width: 572, height: 78)
                    .position(x: 366, y: 390)
                
                Image("shelf1")
                    .resizable()
                    .frame(width: 572, height: 78)
                    .position(x: 366, y: 614)
                
                Image("shelf1")
                    .resizable()
                    .frame(width: 572, height: 78)
                    .position(x: 366, y: 839)
                
                // العمود اليمين
                Image("shelf1")
                    .resizable()
                    .frame(width: 572, height: 78)
                    .position(x: 990, y: 165)
                
                Image("shelf1")
                    .resizable()
                    .frame(width: 572, height: 78)
                    .position(x: 990, y: 390)
                
                Image("shelf1")
                    .resizable()
                    .frame(width: 572, height: 78)
                    .position(x: 990, y: 614)
                
                Image("shelf1")
                    .resizable()
                    .frame(width: 572, height: 78)
                    .position(x: 990, y: 839)
            }
            
            // 🔥 زر الرجوع
            VStack {
                HStack {
                    Button(action: {
                        dismiss()   // يرجع للـ HomeView
                    }) {
                        Image(systemName: "chevron.left")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 25, height: 25)
                            .foregroundColor(.black)
                            .frame(width: 70, height: 70)
                            .background(Color(hex: "FBDC7E"))
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
        .navigationBarHidden(true) // يخفي زر الرجوع الافتراضي
    }
}

#Preview {
    ShelfView()
}
