//
//  FirebaseModels.swift
//  ChatApp
//
//  Created by Sheikh Ahmed on 04/06/2020.
//  Copyright © 2020 Perseus International. All rights reserved.
//

import SwiftUI

struct FirebaseUser: Codable, Hashable{
    var id: String = ""
    var email: String = ""
    var name: String = ""
    var profileImageURL: String?
    var loginState: Bool = false 
}

struct FirebaseMessage{
    var id: String
    var body: String
    var fromUserId: String
    var toUserId: String
    var roomId: String
    var createdTime: Int
}


struct FirebaseChatRoom : Hashable {
    var id: String
    var name: String
    var admin: String
}

struct FirebaseUserProfile{
    var user: FirebaseUser
    var avatar: UIImage
}

enum FirebaseChatRoomType: String {
    case groupChat
    case individualChat
}

