//
//  MiddleBackgroundView.swift
//  ChatApp
//
//  Created by Sheikh Ahmed on 01/06/2020.
//  Copyright © 2020 Perseus International. All rights reserved.
//

import SwiftUI

struct MiddleBackgroundView: View {
    var body: some View {
        VStack{
            HStack{
                Text("s")
                Spacer()
            }
            Spacer()
        }
        .background(Color.gray)
        .frame(height: 100)
        .clipShape(Corners(corner: [.topLeft, .bottomRight], size: CGSize(width: 55, height: 55)))
    }
}

struct MiddleBackgroundView_Previews: PreviewProvider {
    static var previews: some View {
        MiddleBackgroundView()
    }
}
