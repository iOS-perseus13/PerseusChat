//
//  UserViewModel.swift
//  ChatApp
//
//  Created by Sheikh Ahmed on 31/05/2020.
//  Copyright © 2020 Perseus International. All rights reserved.
//
import SwiftUI

class UserViewModel: ObservableObject {
    @Published var logInState: LogInState
    @Published var user: User
    @Published var viewToShow: AuthenticationViewTypes = .login
    init(){    
        if let user = UserDefaults.standard.loadUser() {
            self.logInState = .loggedIn
            self.user = user
        } else {
            self.logInState = .unknown
            self.user = User()
        }
    }
}
