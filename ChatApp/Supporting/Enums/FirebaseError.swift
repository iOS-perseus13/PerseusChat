//
//  FirebaseErrors.swift
//  ChatApp
//
//  Created by Sheikh Ahmed on 19/06/2020.
//  Copyright © 2020 Perseus International. All rights reserved.
//

import Foundation
enum FireBaseError: Error{
    case invalidCache
    case jsonDecodingError
    case userAlreadyExists
    case userDoesNotExist
<<<<<<< HEAD
    case invalidEmailAddress
    case other(message: String?)
=======
    case other(message: String)
>>>>>>> master
    var localizedDescription: String{
        switch self{
        case .userDoesNotExist: return "no such user"
        case .userAlreadyExists: return "user already exists"
<<<<<<< HEAD
        case .invalidEmailAddress: return "invalid email address"
=======
>>>>>>> master
        default: return "\(self)"
        }
    }
}
