//
//  BaseViewModel.swift
//  ChatApp
//
//  Created by Sheikh Ahmed on 23/06/2020.
//  Copyright © 2020 Perseus International. All rights reserved.
//

import SwiftUI
class BaseViewModel: ObservableObject{
    @Published var message: String?
    @Published var isError: Bool
    @Published var isCalculating: Bool
    @ObservedObject var mainViewModel: MainViewModel
    @ObservedObject var firebaseViewModel: FirebaseViewModel
    
    init(firebaseViewModel: FirebaseViewModel, mainViewModel: MainViewModel){
        self.firebaseViewModel = firebaseViewModel
        self.mainViewModel = mainViewModel
        self.message = nil
        self.isError = false
        self.isCalculating = true
    }
    func switchView(viewToPresent: AuthenticationViewTypes){
        self.mainViewModel.switchView(viewToPresent)
    }
}
