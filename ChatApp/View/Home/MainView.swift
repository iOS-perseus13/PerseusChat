//
//  MainView.swift
//  ChatApp
//
//  Created by Sheikh Ahmed on 31/05/2020.
//  Copyright © 2020 Perseus International. All rights reserved.
//

import SwiftUI

struct MainView: View {
    @ObservedObject var firebaseViewModel: FirebaseViewModel
    @State var tabIndex: Int = 0
    
    var body: some View {
        if firebaseViewModel.isLogedIn {
            return AnyView(
                TabView(selection: self.$tabIndex) {
                    // Home Tab
                    HomeView(firebaseViewModel: self.firebaseViewModel)
                        .tabItem {
                            Image(systemName: TabTypes.home.image)
                                .font(.title)
                            Text(TabTypes.home.rawValue)
                    }.tag(TabTypes.home.tabIndex)
                    
                    // Chat Tab
                    CallTab()
                        .tabItem {
                            Image(systemName: TabTypes.call.image)
                                .font(.title)
                            Text(TabTypes.call.rawValue)
                    }.tag(TabTypes.call.tabIndex)
                    
                    //Message Tab
                    ChatView(firebaseViewModel: self.firebaseViewModel)
                        .tabItem {
                            Image(systemName: TabTypes.message.image)
                                .font(.title)
                            Text(TabTypes.message.rawValue)
                    }.tag(TabTypes.message.tabIndex)
                    
                    //More Tab
                    MoreView(firebaseViewModel: self.firebaseViewModel)
                        .tabItem {
                            Image(systemName: TabTypes.more.image)
                                .font(.title)
                            Text(TabTypes.more.rawValue)
                    }.tag(TabTypes.more.tabIndex)
                }
            )
        } else if self.firebaseViewModel.viewToShow == .login{
            return AnyView(LogInView(firebaseViewModel: self.firebaseViewModel))
        }
        else if self.firebaseViewModel.viewToShow == .register{
            return AnyView(RegisterView(firebaseViewModel: self.firebaseViewModel))
        } else {
            return AnyView(ActivityIndicatorView(isAnimating: true))
        }
    }
}
//
//struct MainView_Previews: PreviewProvider {
//    static var previews: some View {
//        MainView()
//    }
//}
