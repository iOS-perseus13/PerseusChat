//
//  AboutView.swift
//  ChatApp
//
//  Created by Sheikh Ahmed on 02/06/2020.
//  Copyright © 2020 Perseus International. All rights reserved.
//


import SwiftUI
import Combine

struct AboutTheAppView: View {
    var body: some View {
        ZStack{
            VStack{
                Text("Perseus International© \(Date().getYear())")
                    //.foregroundColor(Color.black)
                    .bold()
                Spacer()
            }.padding()
        }.navigationBarTitle(Text(MoreListRowType.theApp.rawValue.titleCase()).bold(),displayMode: .inline)
    }
}

struct AboutTheAppView_Previews: PreviewProvider {
    static var previews: some View {
        AboutTheAppView()
    }
}
