import SwiftUI

struct ShelfView: View {
    
    @StateObject private var viewModel = ShelfViewModel()
    
    var body: some View {
        ZStack {
            
            //  الخلفية
            Image("bkshlf")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea()
            
            //  الرفوف
            ZStack {
                
                //  العمود اليسار
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
                
                
                //  العمود اليمين
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
        }
    }
}

#Preview {
    ShelfView()
}
