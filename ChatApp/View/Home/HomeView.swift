//
//  HomeView.swift
//  ChatApp
//
//  Created by Sheikh Ahmed on 31/05/2020.
//  Copyright © 2020 Perseus International. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var userViewModel: UserViewModel
    @State var user: User = User()
    @State var shouldShowLogInView: Bool = false 
    var body: some View {
        ZStack {
            Color(.clear)
            
            GeometryReader{ geometry in
                TopBackGroundView()
                    .position(x: geometry.size.width / 2, y: 147)
            }
            GeometryReader{ geometry in
                TopView(shoudlShowLoginView: self.$shouldShowLogInView)
                    .position(x: geometry.size.width / 2, y: 80)
            }
            
            GeometryReader{ geometry in
                BottomBackgroundView()
                    .position(x: geometry.size.width / 2, y: geometry.size.height - 50)
            }
            GeometryReader{ geometry in
                TabbedView()
                    .position(x: geometry.size.width / 2, y: geometry.size.height - 90)
                .padding()
            }
            
        }
        .background(Color(.clear))
        .edgesIgnoringSafeArea(.all)
        .statusBar(hidden: true)
        
        .sheet(isPresented: self.$shouldShowLogInView) {
            SignInView(mainViewModel: self.userViewModel)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(userViewModel: UserViewModel())
    }
}
