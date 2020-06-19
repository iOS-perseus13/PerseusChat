//
//  UserListView.swift
//  ChatApp
//
//  Created by Sheikh Ahmed on 19/06/2020.
//  Copyright © 2020 Perseus International. All rights reserved.
//

import SwiftUI

struct UsersListView: View {
    @ObservedObject var userViewModel: UserViewModel
    var body: some View {
        List{
            ForEach(self.userViewModel.users.filter({
                $0 != userViewModel.user
            }), id: \.self){
                user in
                NavigationLink(
                    destination: IndividualChatDetailView(userViewModel: self.userViewModel, toUser: user)
                ) {
                    self.userViewModel.user.map({ fromUser in
                        LastMessageView(userViewModel: self.userViewModel, fromUser: fromUser, toUser: user)
                    })
                }
            }
        }
    }
}
