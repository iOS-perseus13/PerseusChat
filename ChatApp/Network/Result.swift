//
//  Result.swift
//  ChatApp
//
//  Created by Sheikh Ahmed on 03/06/2020.
//  Copyright © 2020 Perseus International. All rights reserved.
//

enum Result<T, U> where U: Error  {
    case success(T)
    case failure(U)
}
enum TupleResult<T, A , U> where U: Error  {
    case success(T, A)
    case failure(U)
}
