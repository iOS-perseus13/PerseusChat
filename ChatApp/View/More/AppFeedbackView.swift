//
//  AppFeedbackView.swift
//  ChatApp
//
//  Created by Sheikh Ahmed on 02/06/2020.
//  Copyright © 2020 Perseus International. All rights reserved.
//
import SwiftUI
import MessageUI

struct AppFeedbackView: View {
    @State var result: Result<MFMailComposeResult, Error>? = nil
    @State var isShowingMailView = false
    @State var alertNoMail = false
    var body: some View {
        ZStack{
            VStack{
                Spacer()
                Button(action: {
                    MFMailComposeViewController.canSendMail() ? self.isShowingMailView.toggle() : self.alertNoMail.toggle()
                }) {
                    HStack(spacing: 0){
                        Spacer()
                        Text("sendFeedback".titleCase())
                            .font(.system(size: 14))
                            .fontWeight(.bold)
                            .padding()
                        Spacer()
                    }
                }.overlay(RoundedRectangle(cornerRadius: 40)
                    .stroke(Color.gray, lineWidth: 1)
                )
                    .padding()
                    .frame(height: 50)
                Spacer()
            }.padding()
        }
        .navigationBarTitle(Text(MoreListRowType.appFeedback.rawValue.titleCase()).bold(),displayMode: .inline)
        .sheet(isPresented: $isShowingMailView) {
            SendEMailView(result: self.$result)
            
        }
        .alert(isPresented: self.$alertNoMail) {
            CustomAlerts.init(customAlert: .emailNotSet, error: nil).alert
        }
    }
}

struct AppFeedbackView_Previews: PreviewProvider {
    static var previews: some View {
        AppFeedbackView()
    }
}
