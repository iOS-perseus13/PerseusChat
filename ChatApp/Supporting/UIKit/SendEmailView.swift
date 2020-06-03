//
//  SendEmailView.swift
//  ChatApp
//
//  Created by Sheikh Ahmed on 02/06/2020.
//  Copyright © 2020 Perseus International. All rights reserved.
//

import Foundation
import SwiftUI
import UIKit
import MessageUI
struct SendEMailView: UIViewControllerRepresentable{
    @Environment(\.presentationMode) var presentation
    @Binding var result: Result<MFMailComposeResult, Error>?
    class Coordinator: NSObject, MFMailComposeViewControllerDelegate{
        @Binding var presentation: PresentationMode
        @Binding var result: Result<MFMailComposeResult, Error>?
        init(presentaion: Binding<PresentationMode>, result: Binding<Result<MFMailComposeResult, Error>?>){
            _presentation = presentaion
            _result = result
        }
        func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            defer {
                $presentation.wrappedValue.dismiss()
            }
            guard let error = error else {
                self.result = .success(result)
                return
            }
            self.result = .failure(error)
        }
        
    }
    func makeCoordinator() -> Coordinator {
        return Coordinator(presentaion: presentation, result: $result)
    }
    func makeUIViewController(context: UIViewControllerRepresentableContext<SendEMailView>) -> MFMailComposeViewController {
        let vc = MFMailComposeViewController()
        vc.mailComposeDelegate = context.coordinator
        vc.setSubject("Feedback for Chat App")
        vc.setToRecipients(["iosperseus@gmail.com"])
        return vc
    }
    func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: UIViewControllerRepresentableContext<SendEMailView>) {
        
    }
}

