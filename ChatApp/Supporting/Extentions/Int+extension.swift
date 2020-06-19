//
//  Int+extension.swift
//  ChatApp
//
//  Created by Sheikh Ahmed on 19/06/2020.
//  Copyright © 2020 Perseus International. All rights reserved.
//

import Foundation
extension Int {
    func toLocalDate()->String{
        var result = ""
        let messageTime = Double(self)
        let messageDate = Date(timeIntervalSince1970: messageTime)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        result = dateFormatter.string(from: messageDate)
        
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let messageDateOnly = dateFormatter.string(from: Date(timeIntervalSince1970: messageTime)).split(separator: "/")
        
        let now = Date().timeIntervalSince1970
        let nowString = dateFormatter.string(from: Date(timeIntervalSince1970: now)).split(separator: "/")
    
        if messageDateOnly.count == 3, nowString.count == 3, messageDateOnly[1] == nowString[1], messageDateOnly[2] == nowString[2] {
            if messageDateOnly[0] == nowString[0] {
                result = "Today " + result
            } else if let messageDay = Int(messageDateOnly[0]), let nowDay = Int(nowString[0]), nowDay - messageDay == 1{
                result = "Yesterday " + result
            }
        }
        if !result.contains("Today") && !result.contains("Yesterday") {
            result = messageDateOnly.joined(separator: "/") + result
        }
        return result
    }
}
