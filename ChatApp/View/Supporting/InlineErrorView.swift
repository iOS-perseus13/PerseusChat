//
//  InlineErrorView.swift
//  ChatApp
//
//  Created by Sheikh Ahmed on 21/06/2020.
//  Copyright © 2020 Perseus International. All rights reserved.
//

import SwiftUI

struct InlineErrorView: View {
    @State var message: String
    var body: some View {
        HStack{
            Text(message)
                .font(.caption)
                .fontWeight(.semibold)
            Spacer()
            
        }
    }
}
