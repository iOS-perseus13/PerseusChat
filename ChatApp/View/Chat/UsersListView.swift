//
//  UsersListView.swift
//  ChatApp
//
//  Created by Sheikh Ahmed on 09/06/2020.
//  Copyright © 2020 Perseus International. All rights reserved.
//

import SwiftUI

struct UsersListView: View {
    @ObservedObject var firebaseViewModel: FirebaseViewModel
    var body: some View {
        List{
            ForEach(self.firebaseViewModel.users, id: \.self){
                user in
                NavigationLink(
                    destination: IndividualChatDetailView(firebaseViewModel: self.firebaseViewModel, toUser: user)
                ) {
                    if self.firebaseViewModel.getLastMessage(senderID: user.id) != nil {
                        self.firebaseViewModel.getLastMessage(senderID: user.id).map {
                            lastMessage in
                            LastMessageView(firebaseViewModel: self.firebaseViewModel, lastMessage: lastMessage)
                        }
                    }
                    else {
                        Text(user.name)
                    }
                }
            }
        }
    }
}

struct UsersListView_Previews: PreviewProvider {
    static var previews: some View {
        UsersListView(firebaseViewModel: FirebaseViewModel())
    }
}
