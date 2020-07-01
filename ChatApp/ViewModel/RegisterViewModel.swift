//
//  RegisterViewModel.swift
//  ChatApp
//
//  Created by Sheikh Ahmed on 23/06/2020.
//  Copyright © 2020 Perseus International. All rights reserved.
//

import SwiftUI

class RegisterViewModel: BaseViewModel{
    @Published var isErrorOccured: Bool = false
    @Published var textFieldHavingError: TextBoxType?
    private let inputCheck = CheckForValidInput()
    
    override init(firebaseViewModel: FirebaseViewModel, mainViewModel: MainViewModel){
        super.init(firebaseViewModel: firebaseViewModel, mainViewModel: mainViewModel)
    }
    func resetError(){
        self.message = nil
        self.textFieldHavingError = nil
        self.isCalculating = false
        self.isErrorOccured = false
    }
    func checkForValidInput(name: String? = nil, email: String, password: String, confirmPassword: String? = nil)-> Bool{
        let result = self.inputCheck.checkForValidInput(name: name, email: email, password: password, confirmPassword: confirmPassword)
        self.textFieldHavingError = result.0
        self.message = result.1
        return result.2
    }
    func register(name: String, profileImage: Data?, email: String, password: String, confirmPassword: String?, completion: @escaping(Bool)->Void) {
        if checkForValidInput(name: name, email: email, password: password, confirmPassword: confirmPassword) {
            isCalculating = true
            firebaseViewModel.register(name: name, profileImage: profileImage, email: email, password: password) { result in
                completion(result)
            }
        }
        else {
            print("found error....")
            print("message: \(self.message)")
            print("isError: \(self.isError)")
        }
    }
            
}

