//
//  SignInView.swift
//  ChatApp
//
//  Created by Sheikh Ahmed on 31/05/2020.
//  Copyright © 2020 Perseus International. All rights reserved.
//

import SwiftUI

struct LogInView: View {
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
                        self.userViewModel.viewToShow = AuthenticationViewTypes.register
                    }) {
                        Text("Register")
                            .font(.footnote)
                            .offset(y: -10)
                    }
                }.padding()
                Spacer()
                // Sample Image
                VStack{
                    Image(systemName: "person")
                        .resizable()
                        .padding()
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .stroke(Color.blue, lineWidth: 1)
                    )
                        .frame(width: 100, height: 100)
                    // Label
                    Text("Log in to your account")
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
                    // Forgot password
                    HStack{
                        Spacer()
                        Button(action: {
                            self.shouldShowSheet = true
                        }) {
                            Text("Forget password")
                                .font(.footnote)
                        }
                    }.padding()
                        .offset(y: -15)
                    
                    // Sign In Button
                    HStack{
                        ButtonsWithSystemImage(systemImage: .logIn(image: CustomButtonTypes.ButtonImageType.withSystemImage), buttonLabel: "Log in")
                            .onTapGesture {
                                self.userViewModel.logInState = .loggedIn
                        }
                    }
                    Spacer()
                }.padding()
                
            }.navigationBarTitle("Log in",displayMode: .inline)
                
                .alert(isPresented: self.$shouldShowSheet) {
                    Alert(title: Text("Should send email to reset password."))
            }
        }
    }
}

