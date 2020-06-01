//
//  MainScreenViewModel.swift
//  ChatApp
//
//  Created by Sheikh Ahmed on 31/05/2020.
//  Copyright © 2020 Perseus International. All rights reserved.
//
import SwiftUI

class UserViewModel: ObservableObject {
    @Published var logInState: LogInState
    
    init(){
        if let currentUser = UserDefaults.standard.loadUser() {
            self.logInState = .loggedIn
        } else {
            self.logInState = .unknown
        }
        
    }
}
