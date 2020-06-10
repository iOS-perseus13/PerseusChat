//
//  IndividualChatDetailView.swift
//  ChatApp
//
//  Created by Sheikh Ahmed on 09/06/2020.
//  Copyright © 2020 Perseus International. All rights reserved.
//

import SwiftUI

struct IndividualChatDetailView: View {
    @ObservedObject var firebaseViewModel: FirebaseViewModel
    @State var toUser: FirebaseUser
    @State var message: String = ""
    var body: some View {
        VStack {
            List{
                ForEach(firebaseViewModel.getMessages(roomID: toUser.id, roomType: .individualChat), id: \.self){
                    message in
                    MessageDetailView(message: message, isOwnMessage: message.fromUserId == self.toUser.id)
                }
            }
            Spacer()
            HStack{
                TextField("", text: self.$message, onEditingChanged: { _ in
                    //
                }) {
                    print("Committed.....")
                }.textFieldStyle(RoundedBorderTextFieldStyle()).padding(.horizontal, 20)
                Image(systemName: "chevron.right.circle")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .foregroundColor(.blue)
                    .onTapGesture {
                        guard !self.message.isEmpty else { return}
                        var messageDictionary: [String: Any] = [:]
                        messageDictionary["toUserId"] = self.toUser.id
                        messageDictionary["body"] = self.message.trimmingCharacters(in: .whitespacesAndNewlines)
                        self.firebaseViewModel.sendMessage(message: messageDictionary) { (result) in
                            switch result{
                            case true:
                                print("send the message")
                            case false:
                                print("Should show error")
                            }
                        }
                }
            }
        }.padding()
            .navigationBarTitle("\(toUser.name)", displayMode: .inline)
//            .onAppear{
//                UITableView.appearance().tableFooterView = UIView()
//                UITableView.appearance().separatorStyle = .none
//                UITableView.appearance().backgroundColor = .clear
//                UITableViewCell.appearance().backgroundColor = .clear
//        }
    }
}

struct IndividualChatDetailView_Previews: PreviewProvider {
    static var previews: some View {
        IndividualChatDetailView(firebaseViewModel: FirebaseViewModel(), toUser: FirebaseUser())
    }
}
