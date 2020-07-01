//
//  CheckForValidInput.swift
//  ChatApp
//
//  Created by Sheikh Ahmed on 23/06/2020.
//  Copyright © 2020 Perseus International. All rights reserved.
//

import SwiftUI

class CheckForValidInput{
    init(){
    }
    func checkForValidCustomizedEmail(email: String)->Bool{
        let emailAddress = email.trimmingCharacters(in: .whitespacesAndNewlines)
        if !emailAddress.isValidEmailAddress(){
            return false
        }
        if let domain = emailAddress.split(separator: "@").last, domain != defaultEnding{
            return false
        }
        return true
    }
    func checkForValidInput(name: String? = nil, email: String, password: String, confirmPassword: String? = nil)->(TextBoxType?, String?, Bool){
        if let name = name?.trimmingCharacters(in: .whitespacesAndNewlines), name.isEmpty{
            return (.name, "Name can't be empty", false)
        }
        let emailAddress = email.trimmingCharacters(in: .whitespacesAndNewlines)
        if !emailAddress.isValidEmailAddress(){
            return (.email, "Not a valid email. Please check the email.", false)
        }
        if let domain = emailAddress.split(separator: "@").last, domain != defaultEnding{
            return (.email, "Email domain not allowed on this App.", false)
        }
        if password.isEmpty {
            return (.password, "Password can't be empty.", false)
        }
        if let confirmPassword = confirmPassword, confirmPassword.isEmpty {
            return (.confirmPassword, "Confirm password can't be empty.", false)
        }
        if let confirmPassword = confirmPassword, confirmPassword != password {
            return (.password, "Password and confirm password should match", false)
        }
        return (nil, nil, true)
    }
}
