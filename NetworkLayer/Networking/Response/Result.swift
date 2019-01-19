//
//  Result.swift
//  NetworkLayer
//
//  Created by Shubham Kapoor on 19/01/19.
//  Copyright © 2019 Shubham Kapoor. All rights reserved.
//

import Foundation
enum Result<T, U> where U: Error{
    case success(T)
    case failure(U)
}
