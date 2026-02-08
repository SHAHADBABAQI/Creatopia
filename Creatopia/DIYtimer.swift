//
//  DIYtimer.swift
//  Creatopia
//
//  Created by Sarah Khalid Almalki on 20/08/1447 AH.
//

import SwiftUI

struct DIYtimer: View {
    var body: some View {
        ZStack{
            Image("timerBackground")
                .resizable()
            ZStack{
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.blue, lineWidth: 5)
                    )
                    .frame(width: 760, height: 510)
            }
        }
    }
}

#Preview {
    DIYtimer()
}
