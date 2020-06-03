//
//  CustomAlerts.swift
//  ChatApp
//
//  Created by Sheikh Ahmed on 02/06/2020.
//  Copyright © 2020 Perseus International. All rights reserved.
//
//
//  AppAlerts.swift
//  PrayerTime
//
//  Created by Sheikh Ahmed on 24/05/2020.
//  Copyright © 2020 Sheikh Ahmed. All rights reserved.
//

import SwiftUI
// MARK:- Custom alert base class
struct APPAlertItem: Identifiable {
    var id = UUID()
    var type: APPAlerts
    init(type: APPAlerts){
        self.type = type
    }
    var alert: Alert?
}

// MARK:- APP alerts
enum APPAlerts: String {
    case userNotRegistered
    case invalidEmailAddress
    case emailSentToResetPassword
    case resetPasswordFailed
    case incompleteRequiredData
    case passwordError
    case userAlreadyExists
    case unknownError
    case invalidCredentials
    case passwordAndConfirmPasswordShouldBeSame
    case emailNotSet
    case profileUpdateSuccessfull
    case profileUpdateFailed
    
    
    var title: String{
        return self.rawValue.titleCase()
    }
    var message: String {
        switch self {
        case .userNotRegistered:
            return "Please check the email address."
        case .emailSentToResetPassword:
            return "Please check your email to reset the password."
        case .incompleteRequiredData:
            return "Please check the information you provided."
        default: return self.rawValue.titleCase()
        }
    }
    var dissmissButton: Alert.Button{
        switch self{
        case .invalidEmailAddress, .passwordError, .profileUpdateSuccessfull, .profileUpdateFailed: return .default(Text("OK"))
        case .emailSentToResetPassword, .incompleteRequiredData, .resetPasswordFailed: return .default(Text("OK"))
        default: return .cancel()
        }
        
    }
    var alert: Alert{
        switch self{
        case .userAlreadyExists:
            return Alert(title: Text(self.title),
                         message: Text(self.message),
                         primaryButton: .default(Text("Log in"), action: {
                            //UserDefaults.standard.setView(view: "logIn")
                         }),
                         secondaryButton: .cancel())
        case .userNotRegistered:
            return Alert(title: Text(self.title),
                         message: Text(self.message),
                         primaryButton: .default(Text("Sign up"), action: {
                           // UserDefaults.standard.setView(view: "signUp")
                         }),
                         secondaryButton: .cancel())
        default:
            return Alert(title: Text(self.title), message: Text(self.message), dismissButton: self.dissmissButton )
        }
    }
}
// MARK:- Umbrella Alerts
struct CustomAlerts: Identifiable {
    var id = UUID()
    var alert: Alert
    init(customAlert: APPAlerts, error: Error?){
        if let error = error{
            switch error._code{
            case 17009:
                self.alert = APPAlerts.invalidCredentials.alert
            case 17011:
                self.alert = APPAlerts.userNotRegistered.alert
            case 17007:
                self.alert = APPAlerts.userAlreadyExists.alert
            default:
                let title = Text("Error code: \(error._code)")
                let message = Text(APPAlerts.unknownError.message)
                self.alert = Alert(title: title, message: message, dismissButton: .default(Text("OK")))
            }
        } else {
            self.alert = customAlert.alert
        }
    }
}
