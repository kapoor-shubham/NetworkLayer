//
//  NetworkManager.swift
//  NetworkLayer
//
//  Created by Shubham Kapoor on 19/01/19.
//  Copyright © 2019 Shubham Kapoor. All rights reserved.
//

import Foundation
class NetworkManager: APIClient {
    static let environment : NetworkEnvironment = .production
    
    let session: URLSession
    
    init(configuration: URLSessionConfiguration) {
        self.session = URLSession(configuration: configuration)
    }
    
    convenience init() {
        self.init(configuration: .default)
    }
    
    func apiRequest<T: Decodable>(for: T.Type = T.self, from endPoint: Endpoint, completion: @escaping (Result<T?, APIError>) -> Void){
        let request = endPoint.request
        fetch(with:request, decode: { json -> T? in
            guard let postsOutput = json as? T else { return nil}
            return postsOutput
        }, completion: completion)
    }
}
