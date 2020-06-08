//
//  FirebaseUsersViewModel.swift
//  ChatApp
//
//  Created by Sheikh Ahmed on 07/06/2020.
//  Copyright © 2020 Perseus International. All rights reserved.
//

import SwiftUI

//class FirebaseUsersViewModel: ObservableObject {
//    @ObservedObject var firebaseViewModel: FirebaseViewModel
//    @Published var users: [FirebaseUser] = []
//    @Published var apiError: Error?
//    
//    init(firebaseViewModel: FirebaseViewModel){
//        self.firebaseViewModel = firebaseViewModel
//        if let _ = firebaseViewModel.currentUser {
//            firebaseViewModel.loadUsers { (result) in
//                switch result {
//                case .success(let users):
//                    self.users = users
//                case .failure(let error):
//                    self.apiError = error
//                }
//            }
//        }
//    }
//}
