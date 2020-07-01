//
//  ChannelListView.swift
//  ChatApp
//
//  Created by Sheikh Ahmed on 19/06/2020.
//  Copyright © 2020 Perseus International. All rights reserved.
//

import SwiftUI

struct ChannelListView: View {
    @ObservedObject var userViewModel: UserViewModel
    var body: some View {
        List{
            ForEach(self.userViewModel.chatRooms, id: \.self){
                chatRoom in
                //LastMessageView(userViewModel: self.userViewModel, lastMessage: chatRoom.lastMessage)
                Text("Last message comes here")
            }
        }
    }
}
