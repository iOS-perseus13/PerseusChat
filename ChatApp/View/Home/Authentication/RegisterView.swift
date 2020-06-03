//
//  SignUpView.swift
//  ChatApp
//
//  Created by Sheikh Ahmed on 31/05/2020.
//  Copyright © 2020 Perseus International. All rights reserved.
//

import SwiftUI
import Combine




struct RegisterView: View {
   
    @ObservedObject var userViewModel: UserViewModel
    @Environment(\.presentationMode) var presentation
    
    @State var email: String = ""
    @State var password: String = ""
    @State var confirmPassword: String = ""
    @State var passwordString: String = ""
    @State var confirmPasswordString: String = ""
    
    @State var textFieldHavingError: TextBoxType?
    
    @State var shouldShowAlert: Bool = false
    @State var alertItem: Alert?
    var body: some View {
        NavigationView{
            VStack{
                // Login Stortcut Button
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
                        .padding(10)
                        .autocapitalization(.none)
                        .disableAutocorrection(false)
                        .overlay(RoundedRectangle(cornerRadius: 5)
                            .stroke(self.email.count > 8 && !self.email.isEmpty && !self.email.isValidEmailAddress()
                                ?  Border.error.color : Border.normal.color, lineWidth: 1)
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
                    // Confirm password text box
                    TextField(TextBoxType.confirmPassword.placeHolder.titleCase(), text: $confirmPassword, onEditingChanged: { _ in
                        self.textFieldHavingError = nil
                    })
                        .padding(10)
                        .autocapitalization(.none)
                        .disableAutocorrection(false)
                        .overlay(RoundedRectangle(cornerRadius: 5)
                            .stroke( (self.textFieldHavingError == .confirmPassword) && (self.confirmPassword.count < 6)
                                ?  Border.error.color : Border.normal.color, lineWidth: 1)
                            .onReceive(Just(confirmPassword)) { (newValue) in
                                if self.confirmPasswordString.count == newValue.count {
                                    return
                                }
                                if let lastCharacter = newValue.last{
                                    if self.confirmPasswordString.count < self.confirmPassword.count {
                                        self.confirmPasswordString.append(lastCharacter)
                                    } else {
                                        self.confirmPasswordString = String(self.confirmPasswordString.dropLast(1))
                                    }
                                    self.confirmPassword = String(repeating: "*", count: newValue.count)
                                }
                            }
                    )
                    // Sign Up Button
                    HStack{
                        Button(action: {
                            let firebaseManager = FirebaseAuthManager.shared
                            if self.checkForValidInput() {
                                firebaseManager.createUser(loginInfo: LoginInfo(email: self.email, password: self.passwordString)){ (response) in
                                    switch response{
                                    case .success(let data):
                                        if let _ = data{
                                            print("Success")
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
                                case .password, .confirmPassword:
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
                                Image(systemName: CustomButtonTypes.register(image: CustomButtonTypes.ButtonImageType.withSystemImage).image)
                                    .resizable()
                                    .frame(width: 25, height: 25)
                                    .foregroundColor(.green)
                                
                                Text("Register")
                            }
                            .padding(10)
                            .frame(maxWidth: .infinity)//, minHeight: 50)
                            .background(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(Color.blue, lineWidth: 1)
                            )
                        }
                    }
                    Spacer()
                }.padding()
                
            }.navigationBarTitle("Register",displayMode: .inline)
                .alert(isPresented: self.$shouldShowAlert) {
                    if let alertItem = self.alertItem {
                        return alertItem
                    } else {
                        return Alert(title: Text("Unknown alert"))
                    }
            }
        }
    }
    /*
     Function to check for valid input
     */
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
        if self.confirmPassword.isEmpty{
            self.textFieldHavingError = .confirmPassword
            return false
        }
        if self.password != self.confirmPassword {
            self.textFieldHavingError = .password
            return false
        }
        self.textFieldHavingError = nil
        return true
    }
}



