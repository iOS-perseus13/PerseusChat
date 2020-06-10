//
//  ChatRoomFooter.swift
//  ChatApp
//
//  Created by Sheikh Ahmed on 09/06/2020.
//  Copyright © 2020 Perseus International. All rights reserved.
//

import SwiftUI

struct ChatRoomFooter: View {
    @ObservedObject var firebaseViewModel: FirebaseViewModel
    @State var chatRoomType: FirebaseChatRoomType
    var body: some View {
        HStack{
            Spacer()
            Text(chatRoomType == .groupChat ?
                "Total channels: \(firebaseViewModel.chatRooms.count)" : "Total users: \(firebaseViewModel.users.count)")
        }
    }
}

struct ChatRoomFooter_Previews: PreviewProvider {
    static var previews: some View {
        ChatRoomFooter(firebaseViewModel: FirebaseViewModel(), chatRoomType: .individualChat)
    }
}
