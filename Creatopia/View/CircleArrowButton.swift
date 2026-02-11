import SwiftUI

struct CircleArrowButton: View {
    
    let systemName: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ZStack {
                Circle()
                    .fill(Color.ButtonYellow)
                    .frame(width: 100, height: 100)
                
                Image(systemName: systemName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60, height: 60)
                    .foregroundColor(.black)
            }
        }
    }
}
