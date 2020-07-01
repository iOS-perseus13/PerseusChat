//
//  FirebaseLocation.swift
//  ChatApp
//
//  Created by Sheikh Ahmed on 19/06/2020.
//  Copyright © 2020 Perseus International. All rights reserved.
//

import Foundation


enum FirebaseLocations: String{
    case userProfiles
    case profileImages
    case messages
    var location: String {
        switch self{
        case .profileImages: return "gs://perseus-chat-app.appspot.com/"
        default: return ""
        }
    }
}
