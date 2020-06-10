//
//  ChatView.swift
//  ChatApp
//
//  Created by Sheikh Ahmed on 02/06/2020.
//  Copyright © 2020 Perseus International. All rights reserved.
//

import SwiftUI

struct ChatView: View {
    @ObservedObject var firebaseViewModel: FirebaseViewModel
    var body: some View {
        NavigationView{
            Form{
                // For group chats
                Section(
                    header: ChatRoomHeader(firebaseViewModel: self.firebaseViewModel, chatRoomType: .groupChat),
                    footer: ChatRoomFooter(firebaseViewModel: self.firebaseViewModel, chatRoomType: .groupChat)
                ) {
                    ChannelListView(firebaseViewModel: self.firebaseViewModel)
                }
                
                // For individual users
                Section(
                    header: ChatRoomHeader(firebaseViewModel: self.firebaseViewModel, chatRoomType: .individualChat),
                    footer: ChatRoomFooter(firebaseViewModel: self.firebaseViewModel, chatRoomType: .individualChat)
                ) {
                    UsersListView(firebaseViewModel: self.firebaseViewModel)
                }
            }
            .navigationBarTitle("Chat")
        }
        .onAppear{
            self.firebaseViewModel.loadMessages()
        }
    }
}


