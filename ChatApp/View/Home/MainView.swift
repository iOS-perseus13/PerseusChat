//
//  MainView.swift
//  ChatApp
//
//  Created by Sheikh Ahmed on 31/05/2020.
//  Copyright © 2020 Perseus International. All rights reserved.
//

import SwiftUI

struct MainView: View {
    @ObservedObject var mainViewModel: MainViewModel = MainViewModel()
    @ObservedObject var firebaseViewModel: FirebaseViewModel = FirebaseViewModel()
    var body: some View {
        LoadingView(isShowing: .constant(self.mainViewModel.isCalculating)) {
            VStack{
                if self.mainViewModel.loginState == .loggedIn{
                    LoggedInView(loggedInViewViewModel: LoggedInViewViewModel(firebaseViewModel: self.firebaseViewModel, mainViewModel: self.mainViewModel))
                }
                if self.mainViewModel.loginState == .notLoggenIn {
                    if self.mainViewModel.viewToPresent == .register {
                        RegisterView(registerViewModel: RegisterViewModel(firebaseViewModel: self.firebaseViewModel, mainViewModel: self.mainViewModel))
                    }
                    if self.mainViewModel.viewToPresent == .login {
                        LogInView(loginViewModel: LoginViewModel(firebaseViewModel: self.firebaseViewModel, mainViewModel: self.mainViewModel))
                    }
                }
            }
        }
        .onAppear{
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2) {
                self.firebaseViewModel.loadUserProfile() { (result) in
                    switch result{
                    case .success(_):
                        self.mainViewModel.switchView(.home)
                    case .failure(_):
                        self.mainViewModel.switchView(.login)
                    }
                }
            }
        }
    }
}





/*
 if self.userViewModel.logInState == .loggedIn{
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
 CallView()
 .tabItem {
 Image(systemName: TabTypes.call.image)
 .font(.title)
 Text(TabTypes.call.rawValue)
 }.tag(TabTypes.call.tabIndex)
 
 //Message Tab
 ChatView(userViewModel: self.userViewModel)
 .tabItem {
 Image(systemName: TabTypes.message.image)
 .font(.title)
 Text(TabTypes.message.rawValue)
 }.tag(TabTypes.message.tabIndex)
 
 //More Tab
 MoreView(userViewModel: self.userViewModel)
 .tabItem {
 Image(systemName: TabTypes.more.image)
 .font(.title)
 Text(TabTypes.more.rawValue)
 }.tag(TabTypes.more.tabIndex)
 }
 )
 }
 if self.userViewModel.logInState ==  .notLoggenIn{
 if self.userViewModel.viewToShow == .login {
 //return AnyView(LogInView(userViewModel: self.userViewModel))
 return AnyView(LogInView(loginViewModel: LoginViewModel(userViewModel: self.userViewModel)))
 } else {
 return AnyView(RegisterView(userViewModel: self.userViewModel))
 }
 }
 }
 
 
 
 
 */
