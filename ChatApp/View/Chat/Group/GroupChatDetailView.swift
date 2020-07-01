<<<<<<< HEAD
////
////  GroupChatDetailVoew.swift
////  ChatApp
////
////  Created by Sheikh Ahmed on 19/06/2020.
////  Copyright © 2020 Perseus International. All rights reserved.
////
//
//import SwiftUI
//
//struct GroupChatDetailView: View {
//    @ObservedObject var firebaseViewModel: FirebaseViewModel
//    @State var roomID: String
//    var body: some View {
//        List{
//            ForEach(self.firebaseViewModel.getMessages(roomID: roomID, roomType: .groupChat), id: \.self){
//                message in
//                Text(message.body)
//            }
//        }
//        .navigationBarTitle("room ID", displayMode: .inline)
//    }
//}
//
//struct GroupChatDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        GroupChatDetailView(firebaseViewModel: FirebaseViewModel(), roomID: "")
//    }
//}
=======
//
//  GroupChatDetailView.swift
//  ChatApp
//
//  Created by Sheikh Ahmed on 01/07/2020.
//  Copyright © 2020 Perseus International. All rights reserved.
//

import SwiftUI

struct GroupChatDetailView: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct GroupChatDetailView_Previews: PreviewProvider {
    static var previews: some View {
        GroupChatDetailView()
    }
}
>>>>>>> master
