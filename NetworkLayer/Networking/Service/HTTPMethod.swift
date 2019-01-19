//
//  HTTPMethod.swift
//  NetworkLayer
//
//  Created by Shubham Kapoor on 19/01/19.
//  Copyright © 2019 Shubham Kapoor. All rights reserved.
//

import Foundation

typealias HTTPHeaders = [String:String]

enum HTTPMethod: String {
    case get    = "GET"
    case post   = "POST"
}

