//
//  Date+extension.swift
//  ChatApp
//
//  Created by Sheikh Ahmed on 02/06/2020.
//  Copyright © 2020 Perseus International. All rights reserved.
//

import SwiftUI
extension Date{
    func getYear()->String{
        let date = Date()
        let calender = Calendar.current
        return "\(calender.component(.year, from: date))"
    }

   struct Formatter {
       static let utcFormatter: DateFormatter = {
           let dateFormatter = DateFormatter()
 
           dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss'Z'"
           dateFormatter.timeZone = TimeZone(identifier: "GMT")
 
           return dateFormatter
       }()
   }
 
   var dateToUTC: String {
       return Formatter.utcFormatter.string(from: self)
   }
}
 
