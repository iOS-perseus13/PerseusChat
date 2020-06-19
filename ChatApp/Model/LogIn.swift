//
//  LogIn.swift
//  ChatApp
//
//  Created by Sheikh Ahmed on 03/06/2020.
//  Copyright © 2020 Perseus International. All rights reserved.
//

import Foundation
// MARK:- Login Info
struct LoginInfo{
    let email: String
    let password: String
}

/*
 User login State of an user
 1. loggedIn: user is logged in
 3. notLoggenIn: user is logged out
 */
enum LogInState: String, Codable {
    case loggedIn
    case notLoggenIn
    case notDetermined
    case error
}
