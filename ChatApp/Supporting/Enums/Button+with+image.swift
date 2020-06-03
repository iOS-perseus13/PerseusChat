//
//  Button+with+image.swift
//  ChatApp
//
//  Created by Sheikh Ahmed on 03/06/2020.
//  Copyright © 2020 Perseus International. All rights reserved.
//

import Foundation
enum SystemImages: String{
    case register = "person.badge.plus.fill"
    case logIn = "person.fill"
}

enum CustomButtonTypes {
    enum ButtonImageType{
        case withSystemImage
        case withCustomImage
    }
    case logIn(image: ButtonImageType)
    case register(image: ButtonImageType)
    var image: String {
        switch self {
        case .register(image: .withSystemImage): return SystemImages.register.rawValue
        case .logIn(image: .withSystemImage): return SystemImages.logIn.rawValue
        case .logIn(image: .withCustomImage): break
        case .register(image: .withCustomImage): break
        }
        return ""
    }
}
