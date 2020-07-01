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

enum UserDefaultsKeysType: String{
    case currentUser
    case profileImage
}

extension UserDefaults{
    func getCurrentUser()->FirebaseUser?{
        var result: FirebaseUser?
        if let savedValue = object(forKey: UserDefaultsKeysType.currentUser.rawValue) as? Data {
            let decoder = JSONDecoder()
            if let loadedObject = try? decoder.decode(FirebaseUserObject.self, from: savedValue) {
                result = loadedObject.user
            }
        }
        return result
    }
    func saveUser(user: FirebaseUser) {
        let userObject = FirebaseUserObject(user: user)
        
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(userObject) {
            set(encoded, forKey: UserDefaultsKeysType.currentUser.rawValue)
            synchronize()
        }
    }
    func clearUserData(){
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeysType.currentUser.rawValue)
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeysType.profileImage.rawValue)
    }
    func getProfileImage()->UIImage?{
        var result: UIImage?
        if let savedValue = object(forKey: UserDefaultsKeysType.profileImage.rawValue) as? Data {
            result = UIImage(data: savedValue)
        }
        return result
    }
    func saveProfileImage(image: UIImage) {
        if let imageData = image.jpegData(compressionQuality: 0.35) {
            set(imageData, forKey: UserDefaultsKeysType.profileImage.rawValue)
            synchronize()
        }
    }
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
