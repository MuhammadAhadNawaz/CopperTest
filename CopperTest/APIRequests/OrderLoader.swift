//
//  OrderLoader.swift
//  CopperTest
//
//  Created by Muhammad Ahad on 01/08/2021.
//

public enum LoadOrderResult {
    case success([OrderModel])
    case failure(Error)
}

protocol OrderLoader {
    func load(completion: @escaping (LoadOrderResult) -> Void)
}

