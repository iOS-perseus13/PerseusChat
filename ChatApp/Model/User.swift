////
////  User.swift
////  ChatApp
////
////  Created by Sheikh Ahmed on 31/05/2020.
////  Copyright © 2020 Perseus International. All rights reserved.
////
//
//import SwiftUI
//
//
///*
// Types of user defined in the App
// 1. Restricted: is unable to chat
// 2. normal: (create group chat, ono to one chat)
// 3. admin: (normal user rights, restrict user)
// 
// */
//enum UserType: String, Codable {
//    case restricted
//    case normal
//    case admin
//}
//
//
///*
// User struct to store the current user
// 1. name: user name
// 2. email: user's email
// 3. userType: user type
// 4. loggedInSince: timestamp UTC time (from 1970)
// 5. loggedInState: user's logged in state
// */
//struct User: Codable{
//    var name: String = ""
//    var email: String = ""
//    var userType: UserType = .normal
//    var loggInSince: Int = -1
//    var logInState: LogInState = .unknown
//    var image: String? = nil
//    var currentStatus: String = ""
//    var allowNotifcation: Bool = false
//    var doNotDisturb: Bool = false
//}
///*
// Object to store in UserDefaults
// */
//struct UserObject: Codable{
//    var user: User
//}
//// MARK:- UserProfile
//struct UserProfile{
//    var userID: String? = nil
//    var firstName: String? = nil
//    var lastName: String? = nil
//    var profileImage: UIImage? = nil
//}
