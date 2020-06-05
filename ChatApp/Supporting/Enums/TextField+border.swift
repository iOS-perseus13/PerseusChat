//
//  TextField+border.swift
//  ChatApp
//
//  Created by Sheikh Ahmed on 03/06/2020.
//  Copyright © 2020 Perseus International. All rights reserved.
//

import SwiftUI

enum Border{
    case error
    case normal
    var color: Color{
        switch self{
        case .error: return .red
        case .normal: return .blue
        }
    }
}
enum TextBoxType: Equatable{
    case email
    case password
    case confirmPassword
    case name
    
    var placeHolder: String{
        switch self{
        case .password: return "Password"
        case .confirmPassword: return "Confirm password"
        case .email: return "Email address"
        case .name: return "Your name"
        }
    }
}
