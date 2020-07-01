//
//  UserDefaults+extension.swift
//  ChatApp
//
//  Created by Sheikh Ahmed on 31/05/2020.
//  Copyright © 2020 Perseus International. All rights reserved.
//

import SwiftUI


enum UserDefaultsOperationTypes: String {
    case create
    case delete
    case update
    case search
}




//extension UserDefaults{
//    enum UserDefaultsKeysType: String{
//        case currentUser
//    }
//    /*
//     Save the user object to user defaults
//     */
//    func saveUser(for user: User) {
//        let userObject = UserObject(user: user)
//
//        let encoder = JSONEncoder()
//        if let encoded = try? encoder.encode(userObject) {
//            set(encoded, forKey: UserDefaultsKeysType.currentUser.rawValue)
//            synchronize()
//        }
//    }
//    /*
//     Retrieve the user object from UserDefaults
//     */
//    func loadUser()-> User?{
//        var result: User?
//        if let savedValue = object(forKey: UserDefaultsKeysType.currentUser.rawValue) as? Data {
//            let decoder = JSONDecoder()
//            if let loadedObject = try? decoder.decode(UserObject.self, from: savedValue) {
//                result = loadedObject.user
//            }
//        }
//        return result
//    }
//}
