//
//  Corners.swift
//  ChatApp
//
//  Created by Sheikh Ahmed on 31/05/2020.
//  Copyright © 2020 Perseus International. All rights reserved.
//

import SwiftUI

struct Corners: Shape {
    let conner: UIRectCorner
    let size: CGSize
    func path(in rect: CGRect)-> Path{
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: conner, cornerRadii: size)
        return Path(path.cgPath)
    }
}
