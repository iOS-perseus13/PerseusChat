//
//  ButtonsWithImage.swift
//  ChatApp
//
//  Created by Sheikh Ahmed on 02/06/2020.
//  Copyright © 2020 Perseus International. All rights reserved.
//

import SwiftUI


/* Custom button with System image
 
 */
struct ButtonsWithSystemImage: View {
    @State var systemImage: CustomButtonTypes
    @State var buttonLabel: String
    var body: some View {
        HStack(spacing: 20){
            Image(systemName: self.systemImage.image)
            .resizable()
                .frame(width: 25, height: 25)
                .foregroundColor(.green)
                
            Text(self.buttonLabel)
        }
        .padding()
        .frame(maxWidth: .infinity, minHeight: 50)
        .background(
            RoundedRectangle(cornerRadius: 5)
                .stroke(Color.blue, lineWidth: 1)
        )
    }
}
