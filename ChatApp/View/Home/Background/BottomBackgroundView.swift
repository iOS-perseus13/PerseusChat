//
//  BottomBackgroundView.swift
//  ChatApp
//
//  Created by Sheikh Ahmed on 01/06/2020.
//  Copyright © 2020 Perseus International. All rights reserved.
//

import SwiftUI

struct BottomBackgroundView: View {
    var body: some View {
        VStack{
            Color(.clear)
            }
        .frame(height: 35)
        .padding(.horizontal)
        .padding(.top, (UIApplication.shared.windows.first?.safeAreaInsets.top)! + 5)
        .padding(.bottom, 20)
        //.background(Color("BottomBackground"))
        .background(Color.clear)
       // .clipShape(Corners(conner: [.topLeft], size: CGSize(width: 55, height: 55)))
        .overlay(Corners(corner: [.topLeft], size: CGSize(width: 55, height: 55))
            .stroke(Color.blue, lineWidth: 1)
        )
    }
}

struct BottomBackgroundView_Previews: PreviewProvider {
    static var previews: some View {
        BottomBackgroundView()
    }
}
