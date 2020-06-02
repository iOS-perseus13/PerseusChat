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
                        ProfileImageSection(image: self.userViewModel.user.image)
                            .onTapGesture {
                                print("Change profile picture")
                        }
                        // user name
                        VStack{
                            HStack{
                                EditableLabel(isEditingMode: self.$isUserNameEditing, newText: self.userName, placeHolder: "Set user name")
                                Spacer()
                            }
                            HStack{
                                EditableLabel(isEditingMode: self.$isUserNameEditing, newText: self.userStatus, placeHolder: "Set status")
                                Spacer()
                            }
                        }
                        Spacer()
                        Button(action: {
                            self.isUserNameEditing.toggle()
                        }) {
                            if !isUserNameEditing {
                                Text("Edit")
                            } else {
                                Text("Done")
                            }
                        }
                    }
                }
                // settings section
                Section(header: Text("OTHER SETTINGS"))  {
                    Toggle(isOn: $userViewModel.user.allowNotifcation) {
                        Text("Notifications")
                    }
                    Toggle(isOn: $userViewModel.user.doNotDisturb) {
                        Text("Do not disturb")
                    }
                }
                // log out section
                Section(header:
                    EmptyView()
                ){
                    HStack{
                        LogOutSection()
                            .onTapGesture {
                                self.userViewModel.logInState = .loggedOut
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
    @State var image: String?
    var body: some View{
        VStack{
            if self.image == nil {
                Image(systemName: "person")
                    .resizable()
            } else {
                Image(systemName: image!)
                    .resizable()
            }
        }.padding()
            .frame(width: 75, height : 75)
            .clipShape(Circle())
            .overlay(Circle()
                .stroke(Color.blue, lineWidth: 1)
        )
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
