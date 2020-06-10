//
//  HomeView.swift
//  ChatApp
//
//  Created by Sheikh Ahmed on 31/05/2020.
//  Copyright © 2020 Perseus International. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var firebaseViewModel: FirebaseViewModel
    @State var isUserNameEditing: Bool = false
    @State var userName: String = ""
    @State var userStatus: String = ""
    var body: some View {
        NavigationView{
            Form{
                // profile section
                Section(header:
                    Text("PROFILE")
                ) {
                    HStack(spacing: 10){
                        // profile picture
                        FirebaseImage(userID: self.firebaseViewModel.currentUser?.id)
                            .frame(width: 75, height: 75)
                            .clipShape(Circle())
                            .overlay(Circle()
                                .stroke(Color.blue, lineWidth: 1)
                        )
                            .onTapGesture {
                                print("Change profile picture")
                        }
                        // user name
                        VStack{
                            HStack{
                                Text(firebaseViewModel.currentUser?.name ?? "")
                                Spacer()
                            }
                            //                            HStack{
                            //                                Text("Status")
                            //                                Spacer()
                            //                            }
                        }
                        Spacer()
                    }
                }
                Section(header:
                    EmptyView()
                ){
                    HStack{
                        LogOutSection()
                            .onTapGesture {
                                //                                self.firebaseViewModel.logoutUser { (_) in
                                //                                    self.firebaseViewModel.clearData()
                                //                                }
                        }
                    }
                }
            }
            .navigationBarTitle("User settings", displayMode: .inline)
        }.padding()
    }
}

/*
 Log out section
 */
struct LogOutSection: View {
    var body: some View {
        HStack{
            Spacer()
            Text("Log out")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.red)
        }
    }
}
/*
 Editable label section
 1. For user name
 2. for current status
 */
struct EditableLabel: View {
    @Binding var isEditingMode: Bool
    @State var newText: String
    @State var placeHolder: String
    var body: some View{
        ZStack {
            if isEditingMode {
                TextField(placeHolder, text: $newText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
            } else {
                Text(placeHolder)
                    .opacity(isEditingMode ? 0 : 0.9)
            }
        }
    }
}
