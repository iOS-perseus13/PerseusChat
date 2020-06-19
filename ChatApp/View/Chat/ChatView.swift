//
//  ChatView.swift
//  ChatApp
//
//  Created by Sheikh Ahmed on 02/06/2020.
//  Copyright © 2020 Perseus International. All rights reserved.
//

import SwiftUI

struct ChatView: View {
    @ObservedObject var userViewModel: UserViewModel
    var body: some View {
        NavigationView{
            Form{
                // For group chats
                Section(
                    header: ChatRoomHeader(userViewModel: self.userViewModel, chatRoomType: .groupChat),
                    footer: ChatRoomFooter(userViewModel: self.userViewModel, chatRoomType: .groupChat)
                ) {
                    ChannelListView(userViewModel: self.userViewModel)
                }
                
                // For individual users
                Section(
                    header: ChatRoomHeader(userViewModel: self.userViewModel, chatRoomType: .individualChat),
                    footer: ChatRoomFooter(userViewModel: self.userViewModel, chatRoomType: .individualChat)
                ) {
                    UsersListView(userViewModel: self.userViewModel)
                }
            }
            .navigationBarTitle("Chat")
        }
    }
}
