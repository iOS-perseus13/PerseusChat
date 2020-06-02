//
//  SignUpView.swift
//  ChatApp
//
//  Created by Sheikh Ahmed on 31/05/2020.
//  Copyright © 2020 Perseus International. All rights reserved.
//

import SwiftUI

struct RegisterView: View {
    @ObservedObject var userViewModel: UserViewModel
    @Environment(\.presentationMode) var presentation
    @State var email: String = ""
    @State var password: String = ""
    @State var shouldShowSheet: Bool = false
    var body: some View {
        NavigationView{
            VStack(){
                // Registration Button
                HStack {
                    Spacer()
                    Button(action: {
                        self.userViewModel.viewToShow = AuthenticationViewTypes.login
                    }) {
                        Text("Log in")
                            .font(.footnote)
                            .offset(y: -10)
                    }
                }.padding()
                Spacer()
                // Sample Image
                VStack{
                    Image(systemName: "person.badge.plus")
                        .resizable()
                        .padding()
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .stroke(Color.blue, lineWidth: 1)
                    )
                        .frame(width: 100, height: 100)
                    // Label
                    Text("Register yourself")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.top, 35)
                    // Email text box
                    TextField("Email",text:  self.$email)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.blue, lineWidth: 1))
                    // password text box
                    SecureField("Password",text:  self.$password)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.blue, lineWidth: 1))
                    // password text box
                    SecureField("Password",text:  self.$password)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.blue, lineWidth: 1))
                    // Sign Up Button
                    HStack{
                        ButtonsWithSystemImage(systemImage: .register(image: CustomButtonTypes.ButtonImageType.withSystemImage), buttonLabel: "Register")
                            .onTapGesture {
                                self.userViewModel.logInState = .loggedIn
                        }
                    }
                    Spacer()
                }.padding()
                
            }.navigationBarTitle("Register",displayMode: .inline)
            //                .alert(isPresented: self.$shouldShowSheet) {
            //                    Alert(title: Text("Should send email to reset password."))
            //            }
        }
    }
}



