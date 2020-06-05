//
//  FirebaseModels.swift
//  ChatApp
//
//  Created by Sheikh Ahmed on 04/06/2020.
//  Copyright © 2020 Perseus International. All rights reserved.
//

import SwiftUI

struct FirebaseUser{
    var id: String
    var email: String
    var name: String
}

struct FirebaseMessage{
    var id: String
    var body: String
    var fromUserId: String
    var toUserId: String
    var roomId: String
    var createdTime: Int
}


struct FirebaseChatRoom {
    var id: String
    var name: String
}

struct FirebaseUserProfile{
    var user: FirebaseUser
    var avatar: UIImage
}
