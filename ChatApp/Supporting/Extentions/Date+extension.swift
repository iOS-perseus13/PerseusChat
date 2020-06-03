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
}
