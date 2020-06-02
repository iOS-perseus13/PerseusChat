//
//  AppVersion.swift
//  ChatApp
//
//  Created by Sheikh Ahmed on 02/06/2020.
//  Copyright © 2020 Perseus International. All rights reserved.
//


import SwiftUI

struct AppVersionView: View {
    var body: some View {
        ZStack {
            VStack{
                Text(Bundle.main.appName)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    //.foregroundColor(Color.black)
                Image(systemName: "bubble.left.and.bubble.right.fill")
                    .resizable()
                    .frame(width: 75, height: 75)
                    .foregroundColor(.blue)
                Text("Version: \(Bundle.main.shortVersion)")
                   // .foregroundColor(.black)
                Text("Build: \(Bundle.main.buildVersion)")
                 //   .foregroundColor(.black)
                Spacer()
            }.padding()
        }.navigationBarTitle(Text(MoreListRowType.appVersion.rawValue.titleCase()).bold(),displayMode: .inline)
    }
}

struct AppVersionView_Previews: PreviewProvider {
    static var previews: some View {
        AppVersionView()
    }
}
