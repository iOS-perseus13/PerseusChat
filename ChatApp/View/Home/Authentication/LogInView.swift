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
    @ObservedObject var userViewModel: UserViewModel
    @Environment(\.presentationMode) var presentation
    @State var email: String = ""
    @State var password: String = ""
    @State var passwordString: String = ""
    @State var shouldShowAlert: Bool = false
    @State var alertItem: Alert?
    @State var textFieldHavingError: TextBoxType?
    
    var body: some View {
        NavigationView{
            VStack(){
                // Registration Shortcut Button
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
                            .stroke(self.email.count > 8 && !self.email.isEmpty && !self.email.isValidEmailAddress()
                                ?  Color.red : Color.blue, lineWidth: 1)
                    )
                    
                    // password text box
                    
                    TextField(TextBoxType.password.placeHolder.titleCase(), text: $password, onEditingChanged: { _ in
                        self.textFieldHavingError = nil
                    })
                        .padding(10)
                        .autocapitalization(.none)
                        .disableAutocorrection(false)
                        .overlay(RoundedRectangle(cornerRadius: 5)
                            .stroke( (self.textFieldHavingError == .password) && (self.password.count < 5)
                                ?  Border.error.color : Border.normal.color, lineWidth: 1)
                            .onReceive(Just(password)) { (newValue) in
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
                                }
                            }
                    )
                    // Forgot password
                    HStack{
                        Spacer()
                        Button(action: {
                            if self.checkForValidCustomizedEmail(){
                                self.userViewModel.sendPasswordResetEmail(email: self.email) { (result) in
                                    switch result{
                                    case true:
                                        self.alertItem = APPAlerts.emailSentToResetPassword.alert
                                    case false:
                                        let message = self.userViewModel.error?.localizedDescription.getCustomErrorMessage()
                                        let title = Text("Forget password error")
                                        self.alertItem = Alert(title: title, message: message)
                                    }
                                    self.shouldShowAlert = true
                                }
                            }
                            else {
                                self.alertItem = APPAlerts.invalidEmailAddress.alert
                                self.shouldShowAlert = true
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
                            if self.checkForValidInput() {
                                self.userViewModel.logIn(email: self.email, password: self.password) { (status) in
                                    switch status{
                                    case true:
                                        self.shouldShowAlert = false
                                    case false:
                                        self.shouldShowAlert = true
                                    }
                                }
                            }
                            else {
                                self.shouldShowAlert = true
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
                    Spacer()
                }.padding()
                
            }.navigationBarTitle("Log in",displayMode: .inline)
                
                .alert(isPresented: self.$shouldShowAlert) {
                    if let alertItem = self.alertItem {
                        return alertItem
                    } else {
                        let message = self.userViewModel.error?.localizedDescription.getCustomErrorMessage()
                        let title = Text("Login error")
                        return Alert(title: title, message: message)
                    }
            }
        }
    }
    private func checkForValidCustomizedEmail()->Bool{
        let emailAddress = self.email.trimmingCharacters(in: .whitespacesAndNewlines)
        if !emailAddress.isValidEmailAddress(){
            self.alertItem = APPAlerts.invalidEmailAddress.alert
            return false
        }
        if let domain = emailAddress.split(separator: "@").last, domain != defaultEnding{
            self.alertItem = APPAlerts.emailDomainNotPermitted.alert
            return false
        }
        return true
    }
    private func checkForValidInput()->Bool{
        let emailAddress = self.email.trimmingCharacters(in: .whitespacesAndNewlines)
        if !emailAddress.isValidEmailAddress(){
            self.textFieldHavingError = .email
            self.alertItem = APPAlerts.invalidEmailAddress.alert
            return false
        }
        if let domain = emailAddress.split(separator: "@").last, domain != defaultEnding{
            self.textFieldHavingError = .email
            self.alertItem = APPAlerts.emailDomainNotPermitted.alert
            return false
        }
        if self.password.isEmpty {
            self.textFieldHavingError = .password
            self.alertItem = APPAlerts.passwordError.alert
            return false
        }
        self.textFieldHavingError = nil
        return true
    }
}

