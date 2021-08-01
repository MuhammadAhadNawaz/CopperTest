//
//  OrdersAPIRequests.swift
//  CopperTest
//
//  Created by Muhammad Ahad on 31/07/2021.
//

import Foundation

/*
 Remote order API Service.
 it take HTTP client & URL as dependency. (so that can be replaced in tests)
 Remote API Service implements the OrderLoaded protocol.
 Check RemoteOrderLoaderTests.
 */

public class RemoteOrderLoader: OrderLoader {
    let client: HTTPClient
    let url: URL
    
    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    public typealias Result = LoadOrderResult
    
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    public func load(completion: @escaping (Result) -> Void ) {
        client.get(from: url) { [weak self] result in
            guard let _ = self else { return }
            switch result {
            case .success(let data, let response):
                completion(RemoteOrderLoader.map(data, response))
            case .failure:
                completion(.failure(Error.connectivity))
            }
        }
    }
    
    private static func map(_ data: Data, _ response: HTTPURLResponse) -> Result {
        do {
            let orders = try OrderResultMapper.map(data: data, response: response)
            return .success(orders)
        } catch {
            return .failure(error)
        }
    }
}
