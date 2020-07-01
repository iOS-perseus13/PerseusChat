//
//  LoggedInView.swift
//  ChatApp
//
//  Created by Sheikh Ahmed on 21/06/2020.
//  Copyright © 2020 Perseus International. All rights reserved.
//

import SwiftUI

struct LoggedInView: View {
    @ObservedObject var loggedInViewViewModel: LoggedInViewViewModel
    @State var tabIndex: Int = 0
    var body: some View {
        TabView(selection: self.$tabIndex) {
            // Home Tab
            HomeView(homeViewModel: HomeViewModel(firebaseViewModel: self.loggedInViewViewModel.firebaseViewModel, mainViewModel: self.loggedInViewViewModel.mainViewModel))
                .tabItem {
                    Image(systemName: TabTypes.home.image)
                        .font(.title)
                    Text(TabTypes.home.rawValue)
            }.tag(TabTypes.home.tabIndex)
            
            // Chat Tab
            CallView()
                .tabItem {
                    Image(systemName: TabTypes.call.image)
                        .font(.title)
                    Text(TabTypes.call.rawValue)
            }.tag(TabTypes.call.tabIndex)
            
            //Message Tab
            ChatView(viewMode: ChatViewModel())
                .tabItem {
                    Image(systemName: TabTypes.message.image)
                        .font(.title)
                    Text(TabTypes.message.rawValue)
            }.tag(TabTypes.message.tabIndex)
            
            //More Tab
            MoreView(viewModel: MoreViewModel())
                .tabItem {
                    Image(systemName: TabTypes.more.image)
                        .font(.title)
                    Text(TabTypes.more.rawValue)
            }.tag(TabTypes.more.tabIndex)
        }
    }
}

