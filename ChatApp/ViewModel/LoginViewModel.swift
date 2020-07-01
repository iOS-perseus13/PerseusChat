//
//  LoginViewModel.swift
//  ChatApp
//
//  Created by Sheikh Ahmed on 21/06/2020.
//  Copyright © 2020 Perseus International. All rights reserved.
//

import SwiftUI

class LoginViewModel: BaseViewModel{
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
    private func checkForValidCustomizedEmail(email: String)->Bool{
        return self.inputCheck.checkForValidCustomizedEmail(email: email)
    }
    func sendPasswordResetEmail(email: String, completion: @escaping(Bool)->Void){
        if checkForValidCustomizedEmail(email: email){
            isCalculating = true
            self.firebaseViewModel.sendPasswordResetEmail(email: email) { (result) in
                switch result{
                case .success(_):
                    self.isErrorOccured = false
                    self.message = "Email sent. Please check your email to reset password."
                    completion(true)
                case .failure(let error):
                    self.message = error.localizedDescription
                    self.isErrorOccured = true
                    self.textFieldHavingError = .email
                    completion(false)
                }
            }
        }
        else {
            if email.isEmpty {
                self.message = "Email can't be empty. Please provide a valid email."
            } else {
                self.message = "The email domain currently not allowed on this App"
            }
            self.isErrorOccured = true
            self.textFieldHavingError = .email
            completion(false)
        }
    }
    func logIn(email: String, password: String, completion: @escaping(Bool)->Void) {
        if checkForValidInput(email: email, password: password) {
            isCalculating = true
            firebaseViewModel.loginUser(email: email, password: password) { (result) in
                switch result{
                case .success(let status):
                    completion(status)
                case .failure(let error):
                    self.message = error.localizedDescription
                    self.isErrorOccured = true
                    completion(false)
                }
            }
        }
        else {
            self.isErrorOccured = true
            completion(false)
        }
    }
    private func checkForValidInput(email: String, password: String)->Bool{
        let result = self.inputCheck.checkForValidInput(email: email, password: password)
        self.textFieldHavingError = result.0
        self.message = result.1
        return result.2
    }
    
}
