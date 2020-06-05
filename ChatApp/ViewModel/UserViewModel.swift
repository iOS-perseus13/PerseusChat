//
//  UserViewModel.swift
//  ChatApp
//
//  Created by Sheikh Ahmed on 31/05/2020.
//  Copyright © 2020 Perseus International. All rights reserved.
//
import SwiftUI
import Firebase

class UserViewModel: ObservableObject {
    @Published var logInState: LogInState = .unknown
    @Published var user: Firebase.User?
    @Published var viewToShow: AuthenticationViewTypes = .login
    init(){    
//        if let user = UserDefaults.standard.loadUser() {
//            self.logInState = .loggedIn
//            self.user = user
//        } else {
//            self.logInState = .unknown
//            self.user = User()
//        }
    }
    func saveUserProfile(user: Firebase.User?){
        self.user = user
    }
    
    var userName: String {
        return user?.displayName ?? user?.email ?? "not set yet"
    }
    var profilePic: String?{
        return user?.photoURL?.absoluteString
    }
        
    func clearData(){
        self.logInState = .unknown
        self.user = nil
        self.viewToShow = .login
    }
}
