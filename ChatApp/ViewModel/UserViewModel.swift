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
    @Published var user: FirebaseUser?
    @Published var viewToShow: AuthenticationViewTypes = .login
    @Published var chatrooms: [FirebaseChatRoom] = []
    @Published var messages: [FirebaseMessage] = []
    init(){
        
    }
    func saveUserProfile(user: FirebaseUser?){
        self.user = user
        self.logInState = (user?.loginState ?? false) ? .loggedIn : .unknown
    }
    
    var userName: String {
        return user?.name ?? user?.email ?? "not set yet"
    }
    var profilePic: String?{
        return user?.profileImageURL
    }
        
    func clearData(){
        self.logInState = .unknown
        self.user = nil
        self.viewToShow = .login
    }
}
