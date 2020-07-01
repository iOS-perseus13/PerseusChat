//
//  SignInView.swift
//  ChatApp
//
//  Created by Sheikh Ahmed on 31/05/2020.
//  Copyright © 2020 Perseus International. All rights reserved.
//

import SwiftUI
import Combine

struct LogInView: View {
    @ObservedObject var loginViewModel: LoginViewModel
    @State var email: String = ""
    @State var emailString: String = ""
    @State var password: String = ""
    @State var passwordString: String = ""
    @State var shouldShowMessage: Bool = false
    
    var body: some View {
        
        LoadingView(isShowing: .constant(self.loginViewModel.isCalculating)){
            NavigationView{
                VStack(){
                    // Registration Shortcut Button
                    HStack {
                        Spacer()
                        Button(action: {
                            self.loginViewModel.switchView(viewToPresent: .register)
                        }) {
                            Text("Register")
                                .font(.footnote)
                                .offset(y: -10)
                        }
                    }.padding()
                    Spacer()
                    VStack{
                        // Label
                        Text("Log in to your account")
                            .font(.title)
                            .fontWeight(.bold)
                            .padding(.top, 35)
                        
                        // Email text box
                        TextField("Email",text:  self.$email)
                            .padding(10)
                            .autocapitalization(.none)
                            .disableAutocorrection(false)
                            .overlay(RoundedRectangle(cornerRadius: 5)
                                .stroke( (self.loginViewModel.textFieldHavingError == .email)
                                    ?  Border.error.color : Border.normal.color, lineWidth: 1)
                                .onReceive(Just(self.email)) { (newValue) in
                                    if self.emailString == newValue {
                                        return
                                    }
                                    else {
                                        self.emailString = newValue
                                        self.shouldShowMessage = false
                                        self.loginViewModel.resetError()
                                    }
                                }
                        )
                        
                        // password text box
                        TextField(TextBoxType.password.placeHolder.titleCase(), text: self.$password)
                            .padding(10)
                            .autocapitalization(.none)
                            .disableAutocorrection(false)
                            .overlay(RoundedRectangle(cornerRadius: 5)
                                .stroke( self.loginViewModel.textFieldHavingError == .password
                                    ?  Border.error.color : Border.normal.color, lineWidth: 1)
                                .onReceive(Just(self.password)) { (newValue) in
                                    if self.passwordString.count == newValue.count {
                                        return
                                    }
                                    if let lastCharacter = newValue.last{
                                        if self.passwordString.count < self.password.count {
                                            self.passwordString.append(lastCharacter)
                                        } else {
                                            self.passwordString = String(self.passwordString.dropLast(1))
                                        }
                                        self.password = String(repeating: "*", count: newValue.count)
                                        self.shouldShowMessage = false
                                        self.loginViewModel.resetError()
                                    }
                                }
                        )
                        // Forgot password
                        HStack{
                            Spacer()
                            Button(action: {
                                self.loginViewModel.sendPasswordResetEmail(email: self.email) { (_) in
                                    self.loginViewModel.isCalculating = false
                                    self.shouldShowMessage = true
                                    self.password = ""
                                }
                            }) {
                                Text("Forget password")
                                    .font(.footnote)
                            }
                        }.padding()
                            .offset(y: -15)
                        
                        // Sign In Button
                        HStack{
                            Button(action: {
                                self.loginViewModel.logIn(email: self.email, password: self.password) { (status) in
                                    switch status{
                                    case true:
                                        self.shouldShowMessage = false
                                        self.loginViewModel.switchView(viewToPresent: .home)
                                    case false:
                                        self.shouldShowMessage = true
                                        self.password = ""
                                        self.loginViewModel.isCalculating = false
                                    }
                                }
                            }) {
                                HStack(spacing: 20){
                                    Image(systemName: CustomButtonTypes.logIn(image: CustomButtonTypes.ButtonImageType.withSystemImage).image)
                                        .resizable()
                                        .frame(width: 25, height: 25)
                                        .foregroundColor(.green)
                                    
                                    Text("Log in")
                                }
                                .padding(10)
                                    .frame(maxWidth: .infinity)//, maxHeight: 40)
                                    .background(
                                        RoundedRectangle(cornerRadius: 5)
                                            .stroke(Color.blue, lineWidth: 1)
                                )
                            }
                        }
                        
                        if self.shouldShowMessage { // Error message
                            if self.loginViewModel.isErrorOccured {
                                InlineErrorView(message: self.loginViewModel.message!)
                                    .foregroundColor(.red)
                            }
                            else {
                                InlineErrorView(message: self.loginViewModel.message!)
                            }
                        }
                        Spacer()
                    }.padding()
                }.navigationBarTitle("Log in",displayMode: .inline)
            }
        }
        .onAppear {
            self.loginViewModel.isCalculating = false 
        }
    }
}


