//
//  TopView.swift
//  ChatApp
//
//  Created by Sheikh Ahmed on 01/06/2020.
//  Copyright © 2020 Perseus International. All rights reserved.
//

import SwiftUI

struct TopView: View {
    @Binding var shoudlShowLoginView: Bool
    var body: some View {
        HStack{
            Text("User Name: ")
            Spacer()
            Button(action: {
                // go to profile edit page
                self.shoudlShowLoginView = true
            }) {
                Image(systemName: "person")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .font(.title)
                    //.foregroundColor(.white)
                    .clipShape(Circle())
                    .padding(5)
                    .overlay(
                        Circle()
                            .stroke(Color.blue, lineWidth: 1)
                )
            }
        }
        .background(Color.clear)
        .padding()
    }
}

