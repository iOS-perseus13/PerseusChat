//
//  HomeView.swift
//  ChatApp
//
//  Created by Sheikh Ahmed on 31/05/2020.
//  Copyright © 2020 Perseus International. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var userViewModel: UserViewModel
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
                        ProfileImageSection(userViewModel: self.userViewModel)
                            .onTapGesture {
                                print("Change profile picture")
                        }
                        // user name
                        VStack{
                            HStack{
                                Text(userViewModel.user?.name ?? "")
                                Spacer()
                            }
                            HStack{
                                Text("Status")
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
                                self.userViewModel.logOut { (status) in
                                    switch status {
                                    case true:
                                        self.userViewModel.logInState = .notLoggenIn
                                        self.userViewModel.viewToShow = .login
                                    case false:
                                        print("Login failed....")
                                    }
                                }
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
 Profile image section
 */
struct ProfileImageSection: View {
    @ObservedObject var userViewModel: UserViewModel
    var body: some View{
        VStack{
            if self.userViewModel.profileImage == nil {
                Image(systemName: "person")
                    .resizable()
                    .frame(width: 75, height : 75)
                    .clipShape(Circle())
                    .overlay(Circle()
                        .stroke(Color.blue, lineWidth: 1)
                )
            } else {
                Image(uiImage: self.userViewModel.profileImage!)
                    .resizable()
                    .frame(width: 75, height : 75)
                    .clipShape(Circle())
                    .overlay(Circle()
                        .stroke(Color.blue, lineWidth: 1)
                )
            }
        }.padding()
        
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
