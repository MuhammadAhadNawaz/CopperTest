//
//  NetworkManager.swift
//  CopperTest
//
//  Created by Muhammad Ahad on 31/07/2021.
//

import Foundation

public class URLSessionHTTPClient: HTTPClient {
    let session: URLSession
    
    public init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    private enum Error: Swift.Error {
        case UnexpectedError
    }
    
    public func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void) {
        session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            if let data = data, let response = response as? HTTPURLResponse {
                completion(.success(data, response))
                return
            }
            completion(.failure(Error.UnexpectedError))
            
        }.resume()
    }
}
