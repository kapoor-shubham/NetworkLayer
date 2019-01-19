//
//  RequestHandler.swift
//  NetworkLayer
//
//  Created by Shubham Kapoor on 19/01/19.
//  Copyright © 2019 Shubham Kapoor. All rights reserved.
//

import Foundation
typealias JSONTaskCompletionHandler = (Decodable?, APIError?) -> Void

protocol APIClient {
    var session: URLSession { get }
    // Generic function
    func fetch<T: Decodable>(with request: URLRequest, decode: @escaping(Decodable)->T?, completion: @escaping(Result<T,APIError>) ->Void)
}

extension APIClient{
    private func decodingTask<T: Decodable>(with request: URLRequest, decodingType: T.Type, completionHandler completion:@escaping JSONTaskCompletionHandler) -> URLSessionDataTask{
        
        if Reachability.isConnectedToNetwork() == false {
            completion(nil, .connectionError)
        }
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(nil, .requestFailed)
                return
            }
            
            if httpResponse.statusCode == 200 {
                if let data = data {
                    do {
                        let genericModel = try JSONDecoder().decode(decodingType, from: data)
                        completion(genericModel, nil)
                    } catch {
                        completion(nil, .jsonConversionFailure)
                    }
                } else {
                    completion(nil, .invalidData)
                }
            } else {
                completion(nil, .responseUnsuccessful)
            }
            
        }
        return task
    }
    
   func fetch<T: Decodable>(with request: URLRequest, decode: @escaping(Decodable)->T?, completion: @escaping(Result<T,APIError>) ->Void) {
    
        let task = decodingTask(with: request, decodingType: T.self) { (json , error) in
            
            //MARK: change to main queue
            DispatchQueue.main.async {
                guard let json = json else {
                    if let error = error {
                        completion(Result.failure(error))
                    } else {
                        completion(Result.failure(.invalidData))
                    }
                    return
                }
                
                if let value = decode(json) {
                    completion(.success(value))
                } else {
                    completion(.failure(.jsonParsingFailure))
                }
            }
        }
        task.resume()
    }
}
