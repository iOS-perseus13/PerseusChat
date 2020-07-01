//
//  ChatRoomFooter.swift
//  ChatApp
//
//  Created by Sheikh Ahmed on 19/06/2020.
//  Copyright © 2020 Perseus International. All rights reserved.
//

import SwiftUI

struct ChatRoomFooter: View {
    @ObservedObject var userViewModel: UserViewModel
    @State var chatRoomType: FirebaseChatRoomType
    var body: some View {
        HStack{
            Spacer()
            Text(chatRoomType == .groupChat ?
                "Total channels: \(userViewModel.chatRooms.count)" : "Total users: \(userViewModel.users.count > 0 ?  (userViewModel.users.count - 1) : 0)")
        }
    }
}
