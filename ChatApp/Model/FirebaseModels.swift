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
    var profileImage: String?
}

struct FirebaseMessage: Codable, Hashable{
    var id: String?
    var body: String = ""
    var fromUserId: String = ""
    var toUserId: String?
    var roomId: String?
    var createdTime: Int = 0
    var readStatus: Bool = false
    var sequenceNumner: Int = 0
}

struct FirebaseChatRoom : Hashable, Equatable {
    static func == (lhs: FirebaseChatRoom, rhs: FirebaseChatRoom) -> Bool {
        rhs.lastMessage?.createdTime == rhs.lastMessage?.createdTime
    }
    var id: String
    var name: String
    var admin: String
    var lastMessage: FirebaseMessage?
}

enum FirebaseChatRoomType: String {
    case groupChat
    case individualChat
}
