//
//  MainView.swift
//  ChatApp
//
//  Created by Sheikh Ahmed on 31/05/2020.
//  Copyright © 2020 Perseus International. All rights reserved.
//

import SwiftUI

struct MainView: View {
    @ObservedObject var mainViewModel = UserViewModel()
    var body: some View {
        if mainViewModel.logInState == .loggedIn {
            return  AnyView(HomeView(userViewModel: self.mainViewModel))
        } else {
            return AnyView(SignInView(mainViewModel: self.mainViewModel))
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
