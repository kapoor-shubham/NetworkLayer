//
//  EndPoint.swift
//  NetworkLayer
//
//  Created by Shubham Kapoor on 19/01/19.
//  Copyright © 2019 Shubham Kapoor. All rights reserved.
//
import Foundation

enum NetworkEnvironment {
    case qa
    case production
    case staging
}

public struct Endpoint {
    var path: String?
    var httpMethod: HTTPMethod?
    var headers: HTTPHeaders?
    var body: Data?
    var queryItems: [URLQueryItem]?
    
    init(path: String?, httpMethod:HTTPMethod?, headers: HTTPHeaders? = nil, body: Data? = nil, qeryItems: [URLQueryItem]? = nil ) {
        self.path = path
        self.httpMethod = httpMethod
        self.headers = headers
        self.body = body
        self.queryItems = qeryItems
    }
}

extension Endpoint {
    
    var environmentBaseURL : String {
        switch NetworkManager.environment {
        case .production: return "https://jsonplaceholder.typicode.com"
        case .qa: return "https://jsonplaceholder.typicode.com"
        case .staging: return "https://jsonplaceholder.typicode.com"
        }
    }
    
    var urlComponents: URLComponents {
        var component = URLComponents(string: environmentBaseURL)!
        component.path = path!
        component.queryItems = queryItems
        return component
    }
    
    var request: URLRequest {
        guard let url = urlComponents.url else { fatalError("baseURL could not be configured.")}
        var request = URLRequest(url: url)
        request.httpMethod  = httpMethod?.rawValue
        request.httpBody    = body
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if  let headers = headers {
            for(headerField, headerValue) in headers {
                request.setValue(headerValue, forHTTPHeaderField: headerField)
            }
        }
        request.httpShouldHandleCookies = true
        return request
    }
}

