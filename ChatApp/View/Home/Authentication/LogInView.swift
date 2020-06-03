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
                            .stroke( (self.textFieldHavingError == .password) && (self.password.count < 6)
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
                            if self.email.isValidEmailAddress(){
                                let firebaseManager = FirebaseAuthManager.shared
                                firebaseManager.sendPasswordReset(email: self.email) { (result) in
                                    switch result{
                                    case .success(let status):
                                        switch status{
                                        case true?:
                                            let customAlert = APPAlerts.emailSentToResetPassword
                                            self.alertItem = customAlert.alert
                                            self.shouldShowAlert = true
                                        case false?:
                                            let customAlert = APPAlerts.resetPasswordFailed
                                            self.alertItem = customAlert.alert
                                            self.shouldShowAlert = true
                                        case .none: break
                                        }
                                        break
                                    case .failure(let error):
                                        let customAlert = APPAlerts.resetPasswordFailed
                                        self.alertItem = Alert(title: Text(customAlert.title), message: Text(error.localizedDescription), dismissButton: customAlert.dissmissButton)
                                        self.shouldShowAlert = true
                                    }
                                }
                                
                            } else {
                                let customAlert = APPAlerts.invalidEmailAddress
                                self.alertItem = customAlert.alert
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
                            let firebaseManager = FirebaseAuthManager.shared
                            if self.checkForValidInput() {
                                firebaseManager.loginUser(loginInfo: LoginInfo(email: self.email, password: self.passwordString)){ (response) in
                                    switch response{
                                    case .success(let data):
                                        if let _ = data{
                                            self.userViewModel.logInState = .loggedIn
                                        }
                                    case .failure(let error):
                                        let customAlertType = APPAlerts.unknownError
                                        self.alertItem = Alert(title: Text(customAlertType.title),
                                                               message: Text(error.localizedDescription),
                                                               dismissButton: customAlertType.dissmissButton)
                                        self.shouldShowAlert = true
                                    }
                                }
                            }
                            else {
                                var customAlertType = APPAlerts.unknownError
                                switch self.textFieldHavingError {
                                case .email:
                                    customAlertType = .invalidEmailAddress
                                case .password:
                                    customAlertType = .passwordError
                                default:
                                    break
                                }
                                self.alertItem = Alert(title: Text(customAlertType.title),
                                                       message: Text(customAlertType.message),
                                                       dismissButton: customAlertType.dissmissButton)
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
                        return Alert(title: Text("Unknown alert"))
                    }
            }
        }
    }
    private func checkForValidInput()->Bool{
        let emailAddress = self.email.trimmingCharacters(in: .whitespacesAndNewlines)
        if !emailAddress.isValidEmailAddress(){
            self.textFieldHavingError = .email
            return false
        }
        if self.password.isEmpty {
            self.textFieldHavingError = .password
            return false
        }
        self.textFieldHavingError = nil
        return true
    }
}

