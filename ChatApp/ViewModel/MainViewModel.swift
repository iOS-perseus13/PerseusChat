//
//  MainViewModel.swift
//  ChatApp
//
//  Created by Sheikh Ahmed on 22/06/2020.
//  Copyright © 2020 Perseus International. All rights reserved.
//

import SwiftUI

class MainViewModel: ObservableObject{
    @Published var loginState: LogInState = .notDetermined
    @Published var viewToPresent: AuthenticationViewTypes = .unknown
    @Published var isCalculating: Bool = true
    init(){
    }
    func switchView(_ toView: AuthenticationViewTypes){
        switch toView{
        case .login:
            self.loginState = .notLoggenIn
            self.viewToPresent = .login
        case .register:
            self.loginState = .notLoggenIn
            self.viewToPresent = .register
        case .home:
            self.loginState = .loggedIn
            self.viewToPresent = .home
        case .unknown:
            self.loginState = .notDetermined
            self.viewToPresent = .unknown
        }
        self.isCalculating = false
    }    
}
