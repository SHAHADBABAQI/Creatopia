//
//  DIYtimer.swift
//  Creatopia
//
//  Created by Sarah Khalid Almalki on 20/08/1447 AH.
//

import SwiftUI
import UIKit

struct DIYtimer: View {
    @State private var animate: Bool = false
@State private var TimeRemaining = 60
    var body: some View {
        ZStack{
            Image("timerBackground")
                .resizable()
                .frame(width:1370, height:1037)
            ZStack{
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.panelPink)
                    .overlay(
                        ZStack {
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.panelPink, lineWidth: 5)
                            Text("GO GO GO!")
                                .font(.system(size: 60, weight: .bold, design: .default))
                                .foregroundColor(animate ? .white : .white)
                                .scaleEffect(animate ? 2.0 : 1.0)
                                .onAppear() {
                                    withAnimation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
                                        animate.toggle()
                                    }
                                }
                        }
                    )
                    .frame(width: 760, height: 510)
            }
        }
    }
}

#Preview {
    DIYtimer()
}
