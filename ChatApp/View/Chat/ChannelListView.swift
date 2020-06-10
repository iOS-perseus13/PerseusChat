//
//  ChannelListView.swift
//  ChatApp
//
//  Created by Sheikh Ahmed on 09/06/2020.
//  Copyright © 2020 Perseus International. All rights reserved.
//

import SwiftUI

struct ChannelListView: View {
    @ObservedObject var firebaseViewModel: FirebaseViewModel
    var body: some View {
        List{
            ForEach(self.firebaseViewModel.chatRooms, id: \.self){
                chatRoom in
                LastMessageView(firebaseViewModel: self.firebaseViewModel, lastMessage: chatRoom.lastMessage)
            }
        }
    }
}

struct ChannelListView_Previews: PreviewProvider {
    static var previews: some View {
        ChannelListView(firebaseViewModel: FirebaseViewModel())
    }
}
