//
//  MainView.swift
//  ChatApp
//
//  Created by Sheikh Ahmed on 31/05/2020.
//  Copyright © 2020 Perseus International. All rights reserved.
//

import SwiftUI

struct MainView: View {
    @ObservedObject var userViewModel: UserViewModel
    @State var tabIndex: Int = 0
    var body: some View {
        
        if userViewModel.logInState == .loggedIn {
            return AnyView(
                TabView(selection: self.$tabIndex) {
                    // Home Tab
                    HomeTab(userViewModel: self.userViewModel)
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
                    ChatTab()
                        .tabItem {
                            Image(systemName: TabTypes.message.image)
                                .font(.title)
                            Text(TabTypes.message.rawValue)
                    }.tag(TabTypes.message.tabIndex)
                    
                    //More Tab
                    MoreTab(userViewModel: self.userViewModel)
                        .tabItem {
                            Image(systemName: TabTypes.more.image)
                                .font(.title)
                            Text(TabTypes.more.rawValue)
                    }.tag(TabTypes.more.tabIndex)
                }
            )
        } else if self.userViewModel.viewToShow == .login{
            return AnyView(LogInView(userViewModel: self.userViewModel))
        }
        else {
            return AnyView(RegisterView(userViewModel: self.userViewModel))
        }
    }
}
//
//struct MainView_Previews: PreviewProvider {
//    static var previews: some View {
//        MainView()
//    }
//}
