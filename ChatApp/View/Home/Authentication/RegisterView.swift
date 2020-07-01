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
    
    @State var name: String = ""
    @State var email: String = ""
    @State var password: String = ""
    @State var confirmPassword: String = ""
    @State var passwordString: String = ""
    @State var confirmPasswordString: String = ""
    
    @State var textFieldHavingError: TextBoxType?
    
    @State var shouldShowAlert: Bool = false
    @State var alertItem: Alert?
    
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    @State private var profileImage: Image?
    
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
                    Text("Register")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.top, 35)
                    
                    // Avatag image
                    HStack {
                        Text("Profile picture")
                            .font(.body)
                        Spacer()
                        
                        // Image
                        HStack{
                            if self.profileImage == nil {
                                Image(systemName: "person")
                                    .resizable()
                                    .frame(width: 75, height: 75)
                                    .clipShape(Circle())
                                    .overlay(Circle()
                                        .stroke(Color.blue)
                                )
                            } else {
                                self.profileImage?
                                    .resizable()
                                    .frame(width: 75, height: 75)
                                    .clipShape(Circle())
                                    .overlay(Circle()
                                        .stroke(Color.blue)
                                )
                            }
                            Button(action: {
                                self.showingImagePicker = true
                            }) {
                                Text("Choose image")
                            }
                        }.onTapGesture {
                            self.showingImagePicker = true
                        }
                    }
                    
                    // Name text Field
                    TextField(TextBoxType.name.placeHolder.titleCase(), text:  self.$name)
                        .padding(10)
                        .autocapitalization(.none)
                        .disableAutocorrection(false)
                        .overlay(RoundedRectangle(cornerRadius: 5)
                            .stroke(self.textFieldHavingError == .name && self.name.count < 5
                                ?  Border.error.color : Border.normal.color, lineWidth: 1)
                    )
                    // Email text box
                    TextField(TextBoxType.email.placeHolder.titleCase(), text:  self.$email)
                        .padding(10)
                        .autocapitalization(.none)
                        .disableAutocorrection(false)
                        .overlay(RoundedRectangle(cornerRadius: 5)
                            .stroke(self.textFieldHavingError == .email && !self.email.contains(defaultEnding)
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
                            .stroke( self.textFieldHavingError == .password && self.password.count < 5
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
                            .stroke( self.textFieldHavingError == .confirmPassword && self.confirmPassword.count < 5
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
                            if self.checkForValidInput() {
                                self.userViewModel.register(name: self.name, profileImage: self.inputImage?.jpegData(compressionQuality: 0.25), email: self.email, password: self.password) { (status) in
                                    switch status{
                                    case true:
                                        self.shouldShowAlert = false
                                        self.userViewModel.logInState = .loggedIn
                                        self.userViewModel.viewToShow = .home
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
                
            }
            .onAppear{
                //   self.profileImage = Image(userViewModel.)
            }
            .navigationBarTitle("Register",displayMode: .inline)
            .alert(isPresented: self.$shouldShowAlert) {
                if let alertItem = self.alertItem {
                    return alertItem
                } else {
                    let message = self.userViewModel.error?.localizedDescription.getCustomErrorMessage()
                    let title = Text("Register error")
                    return Alert(title: title, message: message)
                }
            }
            .sheet(isPresented: $showingImagePicker, onDismiss: refreshProfileImage) {
                ImagePickerView(image: self.$inputImage)
            }
        }
    }
    private func refreshProfileImage(){
        self.profileImage = Image(uiImage: self.inputImage ?? UIImage())
    }
    /*
     Function to check for valid input
     */
    private func checkForValidInput()->Bool{
        
        let name = self.name.trimmingCharacters(in: .whitespacesAndNewlines)
        let emailAddress = self.email.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if name.count < 4 {
            self.textFieldHavingError = .name
            self.alertItem = APPAlerts.nameShouldNotBeLessThanFourCharacters.alert
            return false
        }
        
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
        if self.confirmPassword.isEmpty{
            self.textFieldHavingError = .confirmPassword
            self.alertItem = APPAlerts.confirmPasswordError.alert
            return false
        }
        if self.passwordString != self.confirmPasswordString {
            self.textFieldHavingError = .confirmPassword
            self.alertItem = APPAlerts.passwordAndConfirmPasswordShouldBeSame.alert
            return false
        }
        self.textFieldHavingError = nil
        return true
    }
}



