//
//  HomeView.swift
//  ChatApp
//
//  Created by Sheikh Ahmed on 31/05/2020.
//  Copyright © 2020 Perseus International. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var homeViewModel: HomeViewModel
    var body: some View {
        NavigationView{
            Form{
                // profile section
                Section(header:
                    Text("PROFILE")
                ) {
                    HStack(spacing: 10){
                        // profile picture
                        ProfileImageSection(homeViewModel: self.homeViewModel)
                            .onTapGesture {
                                print("Change profile picture")
                        }
                        // user name
                        VStack{
                            HStack{
                                Text(homeViewModel.firebaseViewModel.user?.name ?? "")
                                Spacer()
                            }
                            HStack{
                                Text("Status")
                                Spacer()
                            }
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
                                self.homeViewModel.logOut { (result) in
                                    switch result{
                                    case true:
                                        self.homeViewModel.mainViewModel.switchView(.login)
                                    case false:
                                        print("logout failed: ....")
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
    @ObservedObject var homeViewModel: HomeViewModel
    var body: some View{
        VStack{
            if self.homeViewModel.firebaseViewModel.profileImage == nil {
                Image(systemName: "person")
                    .resizable()
                    .frame(width: 75, height : 75)
                    .clipShape(Circle())
                    .overlay(Circle()
                        .stroke(Color.blue, lineWidth: 1)
                )
            } else {
                Image(uiImage: self.homeViewModel.firebaseViewModel.profileImage!)
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
