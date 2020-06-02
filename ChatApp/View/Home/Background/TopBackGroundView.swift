//
//  TopBackGroundView.swift
//  ChatApp
//
//  Created by Sheikh Ahmed on 01/06/2020.
//  Copyright © 2020 Perseus International. All rights reserved.
//

import SwiftUI

struct TopBackGroundView: View {
    var body: some View {
        VStack{
            VStack{
                Color(.clear)
            }
            .frame(height: 75)
            .padding(.horizontal)
            .padding(.top, (UIApplication.shared.windows.first?.safeAreaInsets.top)! + 5)
            .padding(.bottom, 20)
            .background(Color.clear)
            .overlay(Corners(corner: [.bottomRight], size: CGSize(width: 55, height: 55))
                .stroke(Color.blue, lineWidth: 1)
            )
            Text("")
                .frame(height: 150)
            .overlay(
                Rectangle()
                    .background(Color.green)
                )
        }
    }
}

struct TopBackGroundView_Previews: PreviewProvider {
    static var previews: some View {
        TopBackGroundView()
    }
}
