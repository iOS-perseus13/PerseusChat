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
            VStack{
                ChatRoomView(firebaseViewModel: self.firebaseViewModel)
            }
            .navigationBarTitle("Chat")
        }
    }
}
